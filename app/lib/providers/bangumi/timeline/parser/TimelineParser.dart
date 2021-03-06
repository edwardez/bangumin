import 'package:built_collection/built_collection.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parseFragment;
import 'package:meta/meta.dart';
import 'package:munin/models/bangumi/BangumiUserSmall.dart';
import 'package:munin/models/bangumi/common/BangumiImage.dart';
import 'package:munin/models/bangumi/setting/mute/MutedUser.dart';
import 'package:munin/models/bangumi/timeline/BlogCreationSingle.dart';
import 'package:munin/models/bangumi/timeline/CollectionUpdateSingle.dart';
import 'package:munin/models/bangumi/timeline/FriendshipCreationSingle.dart';
import 'package:munin/models/bangumi/timeline/GroupJoinSingle.dart';
import 'package:munin/models/bangumi/timeline/IndexFavoriteSingle.dart';
import 'package:munin/models/bangumi/timeline/MonoFavoriteSingle.dart';
import 'package:munin/models/bangumi/timeline/ProgressUpdateEpisodeSingle.dart';
import 'package:munin/models/bangumi/timeline/ProgressUpdateEpisodeUntil.dart';
import 'package:munin/models/bangumi/timeline/PublicMessageNoReply.dart';
import 'package:munin/models/bangumi/timeline/PublicMessageNormal.dart';
import 'package:munin/models/bangumi/timeline/StatusUpdateMultiple.dart';
import 'package:munin/models/bangumi/timeline/UnknownTimelineActivity.dart';
import 'package:munin/models/bangumi/timeline/WikiCreationSingle.dart';
import 'package:munin/models/bangumi/timeline/common/BangumiContent.dart';
import 'package:munin/models/bangumi/timeline/common/FeedLoadType.dart';
import 'package:munin/models/bangumi/timeline/common/FeedMetaInfo.dart';
import 'package:munin/models/bangumi/timeline/common/HyperBangumiItem.dart';
import 'package:munin/models/bangumi/timeline/common/HyperImage.dart';
import 'package:munin/models/bangumi/timeline/common/Mono.dart';
import 'package:munin/models/bangumi/timeline/common/TimelineFeed.dart';
import 'package:munin/models/bangumi/timeline/common/TimelineSource.dart';
import 'package:munin/providers/bangumi/timeline/BangumiTimelineService.dart';
import 'package:munin/providers/bangumi/util/utils.dart';
import 'package:munin/redux/timeline/FeedChunks.dart';
import 'package:munin/shared/exceptions/exceptions.dart';
import 'package:munin/shared/utils/common.dart';
import 'package:munin/shared/utils/misc/constants.dart';
import 'package:quiver/core.dart';
import 'package:quiver/strings.dart';

class GetTimelineParsedResponse {
  /// http feeds response
  final List<TimelineFeed> feeds;
  final FeedLoadType feedLoadType;

  /// whether current feeds in store need to be truncated
  /// Depends on type of feed load, this value might not be observed,
  /// see [loadTimelineFeedSuccessReducer] in [timelineReducers]
  final bool truncateFeedsInStore;

  /// see [lastFetchedTime] in [FeedChunks]
  final DateTime fetchedTime;

  const GetTimelineParsedResponse({
    @required this.feeds,
    @required this.feedLoadType,
    @required this.fetchedTime,
    this.truncateFeedsInStore = false,
  })  : assert(feeds != null),
        assert(feedLoadType != null),
        assert(fetchedTime != null),
        assert(truncateFeedsInStore != null);
}

/// TODO: merge code since some parts can be reused
class TimelineParser {
  static const String doujinServerSubDomain = 'doujin.';

  static const Set<String> subjectAction = {
    '在读',
    '在看',
    '在玩',
    '想玩',
    '玩过',
    '在听',
    '想听',
    '听过'
  };

  /// might indicates: have read one volume of a book, one episode of a show, or have watched a whole subject
  static const Set<String> subjectOrEpOrBookVolAction = {
    '读过',
    '看过',
    '想看',
    '想读',
    '抛弃了',
    '搁置了'
  };

  final BuiltMap<String, MutedUser> mutedUsers;

  /// Whether this should check authentication. Throws [AuthenticationExpiredException]
  /// if check fails.
  /// Default to true.
  final bool checkAuthentication;

  const TimelineParser({
    @required this.mutedUsers,
    this.checkAuthentication = true,
  });

  /// verify whether user is authenticated
  /// tricky part is: bangumi WILL returns site global timeline instead of returning
  /// an error code or rendering an error page
  /// The only way to distinguish global timeline from user main timeline
  /// seems to be: if it's user timeline, there will be an '下一页' element
  /// This method will thus check whether '下一页' elements exist, if not,
  /// an [AuthenticationExpiredError] will be thrown
  _verifyAuthentication(DocumentFragment document) {
    Element nextPageIndicatorElement = document.querySelector('#tmlPager');
    if (document.querySelector('#timeline') == null) {
      throw BangumiResponseIncomprehensibleException();
    }

    if (checkAuthentication && !nextPageIndicatorElement.text.contains('下一页')) {
      throw AuthenticationExpiredException('认证已过期，或你没有关注任何用户');
    }
  }

  /// Parses single timeline feed, according to [timelineSource] feed is aprsed
  /// slightly differently.
  /// If timelineSource is [TimelineSource.UserProfile], [userBasicInfo] must
  /// not be null, feed is parsed as a feed in user profile page.
  /// Otherwise feed is parsed as a feed on main home timeline, an additional
  /// [userAvatarImageCache] can be used as an alternative source to retrieve
  /// user avatar.
  TimelineFeed _parseFeed(
    Element timelineItem,
    int feedId, {
    @required TimelineSource timelineSource,
    Map<String, String> userAvatarImageCache,
    BangumiUserSmall userBasicInfo,
  }) {
    Optional<FeedMetaInfo> maybeUserInfo;

    if (timelineSource == TimelineSource.UserProfile) {
      assert(userBasicInfo != null);

      maybeUserInfo =
          _parseProfilePageFeedMetaInfo(timelineItem, feedId, userBasicInfo);
      if (maybeUserInfo.isEmpty) {
        print('Skipping unknown timeline item ${timelineItem.innerHtml}');
        return null;
      }
    } else {
      maybeUserInfo = _parseHomePageFeedMetaInfo(
          timelineItem, userAvatarImageCache, feedId);
      if (maybeUserInfo.isEmpty) {
        print('Skipping unknown timeline item ${timelineItem.innerHtml}');
        return null;
      }
    }

    FeedMetaInfo userInfo = maybeUserInfo.value;

    String selectorName =
        timelineSource == TimelineSource.UserProfile ? '.info_full' : '.info';

    final Element singleTimelineContent =
        timelineItem.querySelector(selectorName);
    final Optional<String> maybeActionPrefix =
    firstTextNodeContent(singleTimelineContent.nodes);

    /// Uses a greedy-based approach to parse timeline event
    /// doujin event is parsed firstly, they make things more complicated and we just need the action name and url
    /// O(1) string equals is parsed secondly
    /// then feed is parsed based on action keyword
    /// finally unknown event is processed
    final doujinItemElements =
        timelineItem.querySelectorAll('a[href*="$doujinServerSubDomain"]');
    if (doujinItemElements.length != 0) {
      return _parseDoujinActivity(singleTimelineContent, userInfo);
    }

    if (maybeActionPrefix.isEmpty) {
      return _parseUnknownTimelineActivity(singleTimelineContent);
    }

    String actionPrefix = maybeActionPrefix.value;

    if (isEmpty(actionPrefix)) {
      return _parsePublicMessage(singleTimelineContent, userInfo);
    }

    if (actionPrefix == '收藏了角色') {
      return _parseCharacterFavoriteSingle(singleTimelineContent, userInfo);
    }

    if (actionPrefix == '收藏了人物') {
      return _parsePersonFavoriteSingle(singleTimelineContent, userInfo);
    }

    if (actionPrefix == '收藏了') {
      return _parseMonoFavoriteUpdateMultiple(singleTimelineContent, userInfo);
    }

    if (actionPrefix == '将') {
      return _parseFriendshipActivity(singleTimelineContent, userInfo);
    }

    if (actionPrefix == '完成了') {
      return _parseProgressUpdateEpisodeUntil(singleTimelineContent, userInfo);
    }

    if (actionPrefix == '加入了') {
      return _parseGroupJoinActivity(singleTimelineContent, userInfo);
    }

    if (actionPrefix == '发表了新日志') {
      return _parseBlogCreationSingle(singleTimelineContent, userInfo);
    }

    if (actionPrefix.startsWith('创建了新目录') || actionPrefix.startsWith('收藏了目录')) {
      return _parseIndexFavoriteSingle(
          singleTimelineContent, userInfo, actionPrefix);
    }

    if (actionPrefix.startsWith('添加了')) {
      return _parseWikiCreationSingle(
          singleTimelineContent, userInfo, actionPrefix);
    }

    if (subjectAction.contains(actionPrefix)) {
      return _parseCollectionUpdate(
          singleTimelineContent, userInfo, actionPrefix);
    }

    if (subjectOrEpOrBookVolAction.contains(actionPrefix)) {
      return _parseSubjectOrEpOrBookVolAction(
          singleTimelineContent, userInfo, actionPrefix);
    }

    return _parseUnknownTimelineActivity(singleTimelineContent);
  }

  Optional<int> _parseUpdateTime(Element updatedAtElement) {
    if (updatedAtElement == null) {
      return Optional.absent();
    }

    DateTime updateTime = parseBangumiTime(updatedAtElement.text);
    return updateTime == null
        ? Optional.absent()
        : Optional.of(updateTime.millisecondsSinceEpoch);
  }

  Optional<FeedMetaInfo> _parseProfilePageFeedMetaInfo(
    Element timelineItem,
    int feedId,
    BangumiUserSmall userBasicInfo,
  ) {
    Optional<int> maybeUpdateTime =
        _parseUpdateTime(timelineItem.querySelector('.date'));

    if (maybeUpdateTime.isNotPresent) {
      return Optional.absent();
    }

    /// Sets actionName to a dummy place holder, this will be correctly
    /// set by later method
    FeedMetaInfo userInfo = FeedMetaInfo((b) => b
      ..nickName = userBasicInfo.nickname
      ..updatedAt = maybeUpdateTime.value
      ..feedId = feedId
      ..username = userBasicInfo.username
      ..avatar.replace(BangumiImage.fromBangumiUserAvatar(userBasicInfo.avatar))
      ..actionName = '');

    return Optional.of(userInfo);
  }

  Optional<FeedMetaInfo> _parseHomePageFeedMetaInfo(Element timelineItem,
      Map<String, String> userAvatarImageCache, int feedId) {
    Element userNameElement =
        timelineItem.querySelector('${aHrefContains('/user/')}.l');

    if (userNameElement?.children?.length != 0) {
      for (var possibleUserElement
          in timelineItem.querySelectorAll('${aHrefContains('/user/')}.l')) {
        if (possibleUserElement.children.length == 0) {
          userNameElement = possibleUserElement;
          break;
        }
      }
    }

    Optional<int> maybeUpdateTime =
        _parseUpdateTime(timelineItem.querySelector('.date'));

    if (userNameElement == null || maybeUpdateTime.isNotPresent) {
      return Optional.absent();
    }

    Match idMatchers = RegExp(r'user\/(\w+)')
        .firstMatch(userNameElement.attributes['href'] ?? '');
    String username = idMatchers?.group(1);

    String nickName = userNameElement.text.trim();

    if (username == null || nickName == null) {
      /// these two must not be null, otherwise it's an unknown situation
      return Optional.absent();
    }

    /// bangumi timeline might omit avatar, so it's optional
    Element userAvatarElement =
        timelineItem.querySelector('${aHrefContains('/user/')}.avatar');
    String avatarImageUrl = userAvatarImageCache[username];
    if (userAvatarElement != null && avatarImageUrl == null) {
      Match imageMatchers = RegExp(r"""background-image:url\('([^']*)'\)""")
          .firstMatch(userAvatarElement?.innerHtml ?? '');
      avatarImageUrl = normalizeImageUrl(imageMatchers?.group(1));
    }

    /// Sets actionName to a dummy place holder, this will be correctly
    /// set by later method
    FeedMetaInfo userInfo = FeedMetaInfo((b) => b
      ..nickName = nickName
      ..updatedAt = maybeUpdateTime.value
      ..feedId = feedId
      ..username = username
      ..avatar.replace(BangumiImage.fromImageUrl(
          avatarImageUrl, ImageSize.Unknown, ImageType.UserAvatar))
      ..actionName = '');

    userAvatarImageCache[username] = avatarImageUrl;

    return Optional<FeedMetaInfo>.of(userInfo);
  }

  UnknownTimelineActivity _parseUnknownTimelineActivity(
      Element singleTimelineContent) {
    return UnknownTimelineActivity(
        (b) => b..content = singleTimelineContent.text);
  }

  TimelineFeed _parsePublicMessageNormal(
      Element singleTimelineContent, FeedMetaInfo userInfo) {
    Element statusElement = singleTimelineContent.querySelector('.status');
    Element replyElement = singleTimelineContent.querySelector('.tml_comment');
    if (statusElement == null || replyElement == null) {
      return _parseUnknownTimelineActivity(singleTimelineContent);
    }
    Match replyCountMatcher =
        RegExp(r'^\d+').firstMatch(replyElement.text.trim());
    String replyCountStr = replyCountMatcher?.group(0);
    int replyCount = int.parse(replyCountStr ?? '0');

    return PublicMessageNormal((b) => b
      ..contentHtml = statusElement.outerHtml
      ..contentText = statusElement.text
      ..user.replace(userInfo)
      ..replyCount = replyCount
      ..bangumiContent = BangumiContent.PublicMessage);
  }

  TimelineFeed _parsePublicMessageNoReply(
      Element singleTimelineContent, FeedMetaInfo userInfo) {
    Element statusElement = singleTimelineContent.querySelector('.status');
    if (statusElement == null) {
      return _parseUnknownTimelineActivity(singleTimelineContent);
    }

    /// This public message doesn't quite fit this actionName: 'xx 注册成为了 Bangumi 成员'
    /// But that action will currently be parsed as UnknownTimelineActivity and this
    /// method won't be called
    userInfo = userInfo.rebuild((b) => b..actionName = '资料更新');

    PublicMessageNoReply publicMessageNoReply = PublicMessageNoReply((b) => b
      ..user.replace(userInfo)
      ..content = statusElement.text.trim()
      ..bangumiContent = BangumiContent.PublicMessage);

    return publicMessageNoReply;
  }

  TimelineFeed _parsePublicMessage(
      Element singleTimelineContent, FeedMetaInfo userInfo) {
    userInfo = userInfo.rebuild((b) => b..actionName = '说');
    if (singleTimelineContent.querySelector('.tml_comment') != null) {
      return _parsePublicMessageNormal(singleTimelineContent, userInfo);
    } else {
      return _parsePublicMessageNoReply(singleTimelineContent, userInfo);
    }
  }

  TimelineFeed _parseCharacterFavoriteSingle(
      Element singleTimelineContent, FeedMetaInfo userInfo) {
    userInfo = userInfo.rebuild((b) => b..actionName = '收藏了角色');
    return _parseMonoFavoriteSingle(
        singleTimelineContent, userInfo, Mono.Character);
  }

  TimelineFeed _parsePersonFavoriteSingle(
      Element singleTimelineContent, FeedMetaInfo userInfo) {
    userInfo = userInfo.rebuild((b) => b..actionName = '收藏了人物');
    return _parseMonoFavoriteSingle(
        singleTimelineContent, userInfo, Mono.Person);
  }

  TimelineFeed _parseMonoFavoriteSingle(
      Element singleTimelineContent, FeedMetaInfo userInfo, Mono monoType) {
    String selectorName;
    if (monoType == Mono.Character) {
      selectorName = 'character';
    } else if (monoType == Mono.Person) {
      selectorName = 'person';
    } else {
      /// even if we assign a default type here, rest of the application won't
      /// be able to recognize, so it's better to throw error
      /// and let developers be aware of it
      throw ('Unsupported monoType $monoType');
    }
    String monoName;
    String id;

    Element monoNameElement = singleTimelineContent
        .querySelector('${aHrefContains('/$selectorName/')}.l');
    Element monoImageElement = singleTimelineContent
        .querySelector('${aHrefContains('/$selectorName/')}>img');

    if (monoNameElement == null) {
      return _parseUnknownTimelineActivity(singleTimelineContent);
    }

    monoName = monoNameElement.text;
    id = parseHrefId(monoNameElement, digitOnly: true);

    return MonoFavoriteSingle((b) => b
      ..id = id
      ..avatar.replace(BangumiImage.fromImageUrl(
          imageSrcOrFallback(monoImageElement),
          ImageSize.Unknown,
          ImageType.MonoAvatar))
      ..monoName = monoName
      ..monoType = monoType
      ..user.replace(userInfo)
      ..bangumiContent = monoType.bangumiContent);
  }

  List<HyperImage> _parseAllHyperImages(Element singleTimelineContent,
      BangumiContent contentType, String keywordName,
      {Set<String> filterIds}) {
    filterIds = filterIds ?? Set<String>();
    String aHrefSelector = aHrefContains('$keywordName');
    List<Element> hyperImageElements =
        singleTimelineContent.querySelectorAll('$aHrefSelector>img');

    List<HyperImage> hyperImages = [];
    for (var imageElement in hyperImageElements) {
      String id = parseHrefId(imageElement.parent);
      if (filterIds.contains(id)) {
        continue;
      }

      String pageUrl = imageElement.parent?.attributes['href'];
      String imageUrl = imageSrcOrFallback(imageElement);

      HyperImage hyperImage = HyperImage((b) => b
        ..id = id
        ..image.replace(BangumiImage.fromImageUrl(
            imageUrl, ImageSize.Unknown, contentType.imageType))
        ..contentType = contentType
        ..pageUrl = pageUrl);
      hyperImages.add(hyperImage);
    }

    return hyperImages;
  }

  List<HyperBangumiItem> _parseAllHyperLinks(Element singleTimelineContent,
      BangumiContent contentType, String keywordName,
      {Set<String> filterIds}) {
    filterIds ??= Set<String>();
    String aHrefSelector = aHrefContains('$keywordName');
    List<Element> hyperTextElements =
        singleTimelineContent.querySelectorAll('$aHrefSelector.l');

    List<HyperBangumiItem> hyperBangumiItems = [];

    for (var textElement in hyperTextElements) {
      String id = parseHrefId(textElement);

      /// Item name, i.e. user name, subject name...
      String name = textElement.text;

      String pageUrl = textElement.attributes['href'];

      if (filterIds.contains(id) || isEmpty(name)) {
        continue;
      }

      HyperBangumiItem hyperBangumiItem = HyperBangumiItem((b) => b
        ..id = id
        ..name = name ?? ''
        ..contentType = contentType
        ..pageUrl = pageUrl);
      hyperBangumiItems.add(hyperBangumiItem);
    }

    return hyperBangumiItems;
  }

  TimelineFeed _parseMonoFavoriteUpdateMultiple(
      Element singleTimelineContent, FeedMetaInfo userInfo) {
    userInfo = updateUserAction(singleTimelineContent, userInfo);

    List<HyperBangumiItem> characterTextList = _parseAllHyperLinks(
        singleTimelineContent,
        BangumiContent.Character,
        BangumiContent.Character.webPageRouteName);
    List<HyperImage> characterImageList = _parseAllHyperImages(
        singleTimelineContent,
        BangumiContent.Character,
        BangumiContent.Character.webPageRouteName);
    List<HyperBangumiItem> personTextList = _parseAllHyperLinks(
        singleTimelineContent,
        BangumiContent.Person,
        BangumiContent.Person.webPageRouteName);
    List<HyperImage> personImageList = _parseAllHyperImages(
        singleTimelineContent,
        BangumiContent.Person,
        BangumiContent.Person.webPageRouteName);

    characterImageList.addAll(personImageList);
    characterTextList.addAll(personTextList);
    StatusUpdateMultiple statusUpdateMultiple = StatusUpdateMultiple((b) => b
      ..user.replace(userInfo)
      ..bangumiContent = BangumiContent.CharacterOrPerson
      ..hyperBangumiItems.replace(characterTextList)
      ..hyperImages.replace(characterImageList));
    return statusUpdateMultiple;
  }

  TimelineFeed _parseFriendshipActivity(
      Element singleTimelineContent, FeedMetaInfo userInfo) {
    Optional<String> maybeActionName =
        getMergedTextNodeContent(singleTimelineContent.nodes);
    String actionName = maybeActionName.isEmpty ? '' : maybeActionName.value;

    /// Action name contains '位成员' if and only if it's a multi-friend activity
    bool isFriendshipCreationMultiple = actionName.contains('位成员');

    if (!isFriendshipCreationMultiple) {
      actionName = '将1位成员加为了好友';
    }
    userInfo = userInfo.rebuild((b) => b..actionName = actionName);

    if (!isFriendshipCreationMultiple) {
      return _parseFriendshipCreationSingle(singleTimelineContent, userInfo);
    }

    return _parseFriendshipCreationMultiple(singleTimelineContent, userInfo);
  }

  TimelineFeed _parseFriendshipCreationSingle(
      Element singleTimelineContent, FeedMetaInfo userInfo) {
    List<HyperBangumiItem> friendTextList = _parseAllHyperLinks(
        singleTimelineContent,
        BangumiContent.User,
        BangumiContent.User.webPageRouteName,
        filterIds: {userInfo.username});

    Element hyperImageElement = singleTimelineContent.querySelector('a>img.rr');

    /// single friendship creation should only return one link
    /// per bangumi rule, each user must have a avatar
    if (friendTextList.length != 1 || hyperImageElement == null) {
      return _parseUnknownTimelineActivity(singleTimelineContent);
    }

    String friendNickName = friendTextList[0].name;
    String friendId = friendTextList[0].id;

    return FriendshipCreationSingle((b) => b
      ..user.replace(userInfo)
      ..friendNickName = friendNickName
      ..friendId = friendId
      ..friendAvatar.replace(BangumiImage.fromImageUrl(
          imageSrcOrFallback(hyperImageElement),
          ImageSize.Unknown,
          ImageType.UserAvatar))
      ..bangumiContent = BangumiContent.User);
  }

  TimelineFeed _parseFriendshipCreationMultiple(
      Element singleTimelineContent, FeedMetaInfo userInfo) {
    TimelineFeed timelineFeed = _parseStatusUpdateMultiple(
        singleTimelineContent, userInfo, BangumiContent.User);
    if (timelineFeed is StatusUpdateMultiple) {
      // Images are using digit id here, alphanumeric id is available in `hyperBangumiItems`
      // so converting hyperImages ids here
      // This assumes every user has an avatar and these two list has the same length
      BuiltList<HyperBangumiItem> hyperBangumiItems =
          timelineFeed.hyperBangumiItems;
      BuiltList<HyperImage> hyperImages = timelineFeed.hyperImages;
      assert(hyperBangumiItems.length == hyperImages.length);
      int index = 0;
      List<HyperImage> updatedImages = [];
      for (HyperImage image in hyperImages) {
        updatedImages.add(image
            .rebuild((b) => b..id = hyperBangumiItems.elementAt(index).id));
        index++;
      }

      return timelineFeed.rebuild((b) =>
          b..hyperImages.replace(BuiltList<HyperImage>.of(updatedImages)));
    }

    return timelineFeed;
  }

  TimelineFeed _parseStatusUpdateMultiple(Element singleTimelineContent,
      FeedMetaInfo userInfo, BangumiContent contentType,
      {List<HyperImage> imageList,
      List<HyperBangumiItem> hyperLinkList,
      parseActionName = false}) {
    hyperLinkList ??= _parseAllHyperLinks(
        singleTimelineContent, contentType, contentType.webPageRouteName,
        filterIds: {userInfo.username});

    imageList ??= _parseAllHyperImages(
        singleTimelineContent, contentType, contentType.webPageRouteName,
        filterIds: {userInfo.username});

    if (parseActionName) {
      userInfo = updateUserAction(singleTimelineContent, userInfo);
    }

    if (hyperLinkList.length <= 0) {
      return _parseUnknownTimelineActivity(singleTimelineContent);
    }

    StatusUpdateMultiple statusUpdateMultiple = StatusUpdateMultiple((b) => b
      ..bangumiContent = contentType
      ..user.replace(userInfo)
      ..hyperBangumiItems.replace(hyperLinkList)
      ..hyperImages.replace(imageList));
    return statusUpdateMultiple;
  }

  TimelineFeed _parseProgressUpdateEpisodeUntil(
      Element singleTimelineContent, FeedMetaInfo userInfo) {
    Optional<String> maybeActionName = getMergedTextNodeContent(
        singleTimelineContent.nodes,
        trimExtraChars: false,
        mergeExtraWhiteSpace: true);

    if (maybeActionName.isEmpty) {
      return _parseUnknownTimelineActivity(singleTimelineContent);
    }

    userInfo = userInfo.rebuild((b) => b..actionName = maybeActionName.value);

    List<HyperBangumiItem> subjectTextList = _parseAllHyperLinks(
        singleTimelineContent,
        BangumiContent.User,
        BangumiContent.Subject.webPageRouteName);

    if (subjectTextList.length != 1) {
      return _parseUnknownTimelineActivity(singleTimelineContent);
    }

    String subjectName = subjectTextList[0].name;

    String subjectId = subjectTextList[0].id;

    return ProgressUpdateEpisodeUntil((b) => b
      ..user.replace(userInfo)
      ..subjectName = subjectName
      ..subjectId = subjectId
      ..bangumiContent = BangumiContent.Subject);
  }

  TimelineFeed _parseGroupJoinActivity(
      Element singleTimelineContent, FeedMetaInfo userInfo) {
    Optional<String> maybeActionName =
        getMergedTextNodeContent(singleTimelineContent.nodes);
    String actionName = maybeActionName.isEmpty ? '' : maybeActionName.value;

    /// Action name contains '个小组' if and only if it's a multi-friend activity
    bool isGroupJoinMultiple = actionName.contains('个小组');

    if (!isGroupJoinMultiple) {
      actionName = '加入了1个小组';
    }
    userInfo = userInfo.rebuild((b) => b..actionName = actionName);

    if (!isGroupJoinMultiple) {
      return _parseGroupJoinSingle(singleTimelineContent, userInfo);
    }

    return _parseGroupJoinMultiple(singleTimelineContent, userInfo);
  }

  TimelineFeed _parseGroupJoinSingle(
      Element singleTimelineContent, FeedMetaInfo userInfo) {
    List<HyperBangumiItem> hyperLinkList = _parseAllHyperLinks(
        singleTimelineContent,
        BangumiContent.Group,
        BangumiContent.Group.webPageRouteName,
        filterIds: {userInfo.username});
    List<HyperImage> imageList = _parseAllHyperImages(singleTimelineContent,
        BangumiContent.Group, BangumiContent.Group.webPageRouteName,
        filterIds: {userInfo.username});

    /// group may not have an icon, and there must be exactly one text group link
    if (hyperLinkList.length != 1) {
      return _parseUnknownTimelineActivity(singleTimelineContent);
    }
    BangumiImage groupIcon = imageList.length == 0
        ? BangumiImage.useSameImageUrlForAll(bangumiTextOnlyGroupIcon)
        : imageList[0].image;
    String groupName = hyperLinkList[0].name;

    Element groupIntroElement = singleTimelineContent.querySelector('.tip_j');
    String groupDescription = groupIntroElement?.text;
    String groupId = hyperLinkList[0].id;

    return GroupJoinSingle((b) => b
      ..user.replace(userInfo)
      ..groupIcon.replace(groupIcon)
      ..groupName = groupName
      ..groupId = groupId
      ..groupDescription = groupDescription
      ..bangumiContent = BangumiContent.Group);
  }

  TimelineFeed _parseGroupJoinMultiple(
      Element singleTimelineContent, FeedMetaInfo userInfo) {
    return _parseStatusUpdateMultiple(
        singleTimelineContent, userInfo, BangumiContent.Group);
  }

  TimelineFeed _parseProgressUpdateEpisodeSingle(
      Element singleTimelineContent, FeedMetaInfo userInfo) {
    List<HyperBangumiItem> episodeLinks = _parseAllHyperLinks(
        singleTimelineContent,
        BangumiContent.Episode,
        BangumiContent.Episode.webPageRouteName);

    Element subjectLinkElement = singleTimelineContent.querySelector(
        '${aHrefContains(BangumiContent.Subject.webPageRouteName)}.tip');

    if (episodeLinks.length != 1 || subjectLinkElement == null) {
      return _parseUnknownTimelineActivity(singleTimelineContent);
    }

    String episodeName = episodeLinks[0].name;

    String episodeId = episodeLinks[0].id;

    String subjectName = subjectLinkElement.text;

    String subjectId = parseHrefId(subjectLinkElement, digitOnly: true);

    return ProgressUpdateEpisodeSingle((b) => b
      ..user.replace(userInfo)
      ..episodeName = episodeName
      ..episodeId = episodeId
      ..subjectName = subjectName
      ..subjectId = subjectId
      ..bangumiContent = BangumiContent.Episode);
  }

  TimelineFeed _parseSubjectOrEpOrBookVolAction(Element singleTimelineContent,
      FeedMetaInfo userInfo, String actionPrefix) {
    final episodeLinks =
        singleTimelineContent.querySelectorAll('a[href*="/subject/ep/"]');
    if (episodeLinks.length != 0) {
      userInfo = userInfo.rebuild((b) => b..actionName = actionPrefix);
      return _parseProgressUpdateEpisodeSingle(singleTimelineContent, userInfo);
    }

    final subjectLinks =
        singleTimelineContent.querySelectorAll('a[href*="/subject/"]');
    final subjectImageLinks =
        singleTimelineContent.querySelectorAll('a[href*="/subject/"]>img');

    if (subjectLinks.length == 0) {
      return _parseUnknownTimelineActivity(singleTimelineContent);
    } else if (subjectLinks.length <= 2) {
      if (subjectImageLinks.length == 0) {
        return _parseCollectionUpdateMultiple(singleTimelineContent, userInfo);
      } else {
        return _parseCollectionUpdate(
            singleTimelineContent, userInfo, actionPrefix);
      }
    } else if (subjectLinks.length > 2) {
      return _parseCollectionUpdateMultiple(singleTimelineContent, userInfo);
    }

    return _parseUnknownTimelineActivity(singleTimelineContent);
  }

  TimelineFeed _parseCollectionUpdateMultiple(
      Element singleTimelineContent, FeedMetaInfo userInfo) {
    userInfo = updateUserAction(singleTimelineContent, userInfo);

    return _parseStatusUpdateMultiple(
        singleTimelineContent, userInfo, BangumiContent.Subject);
  }

  TimelineFeed _parseCollectionUpdate(
      Element singleTimelineContent, FeedMetaInfo userInfo, String actionName) {
    List<HyperBangumiItem> hyperLinkList = _parseAllHyperLinks(
        singleTimelineContent,
        BangumiContent.Subject,
        BangumiContent.Subject.webPageRouteName,
        filterIds: {userInfo.username});
    List<HyperImage> imageList = _parseAllHyperImages(singleTimelineContent,
        BangumiContent.Subject, BangumiContent.Subject.webPageRouteName,
        filterIds: {userInfo.username});

    /// subject may not have an icon, and there must be exactly one text subject link
    if (hyperLinkList.length < 1) {
      return _parseUnknownTimelineActivity(singleTimelineContent);
    } else if (hyperLinkList.length == 1) {
      userInfo = userInfo.rebuild((b) => b..actionName = actionName);

      double subjectScore = parseSubjectScore(singleTimelineContent);
      BangumiImage subjectCover = imageList.length == 1
          ? imageList[0].image
          : BangumiImage.useSameImageUrlForAll(bangumiTextOnlySubjectCover);

      String subjectComment =
          singleTimelineContent.querySelector('.quote')?.text ?? null;

      return CollectionUpdateSingle((b) => b
        ..user.replace(userInfo)
        ..subjectId = hyperLinkList[0].id
        ..subjectScore = subjectScore
        ..subjectCover.replace(subjectCover)
        ..subjectComment = subjectComment
        ..subjectName = hyperLinkList[0].name ?? ''
        ..bangumiContent = BangumiContent.Subject);
    } else {
      return _parseStatusUpdateMultiple(
          singleTimelineContent, userInfo, BangumiContent.Subject,
          hyperLinkList: hyperLinkList,
          imageList: imageList,
          parseActionName: true);
    }
  }

  TimelineFeed _parseBlogCreationSingle(
      Element singleTimelineContent, FeedMetaInfo userInfo) {
    userInfo = userInfo.rebuild((b) => b..actionName = '发表了日志');

    List<HyperBangumiItem> hyperLinkList = _parseAllHyperLinks(
        singleTimelineContent,
        BangumiContent.Blog,
        BangumiContent.Blog.webPageRouteName);

    if (hyperLinkList.length != 1) {
      return _parseUnknownTimelineActivity(singleTimelineContent);
    }

    Element blogIntroElement = singleTimelineContent.querySelector('.tip_j');
    String blogDescription = blogIntroElement?.text;

    return BlogCreationSingle((b) => b
      ..user.replace(userInfo)
      ..id = hyperLinkList[0].id
      ..title = hyperLinkList[0].name
      ..summary = blogDescription
      ..bangumiContent = BangumiContent.Blog);
  }

  TimelineFeed _parseIndexFavoriteSingle(
      Element singleTimelineContent, FeedMetaInfo userInfo, String actionName) {
    userInfo = userInfo.rebuild((b) => b..actionName = actionName);

    List<HyperBangumiItem> hyperLinkList = _parseAllHyperLinks(
        singleTimelineContent,
        BangumiContent.Catalog,
        BangumiContent.Catalog.webPageRouteName);

    if (hyperLinkList.length != 1) {
      return _parseUnknownTimelineActivity(singleTimelineContent);
    }

    Element indexIntroElement = singleTimelineContent.querySelector('.tip_j');
    String indexDescription = indexIntroElement?.text;

    return IndexFavoriteSingle((b) => b
      ..user.replace(userInfo)
      ..id = hyperLinkList[0].id
      ..title = hyperLinkList[0].name
      ..summary = indexDescription
      ..bangumiContent = BangumiContent.Catalog);
  }

  TimelineFeed _parseWikiCreationSingle(
      Element singleTimelineContent, FeedMetaInfo userInfo, String actionName) {
    userInfo = updateUserAction(singleTimelineContent, userInfo);

    List<HyperBangumiItem> hyperLinkList = _parseAllHyperLinks(
        singleTimelineContent,
        BangumiContent.SubjectCreation,
        BangumiContent.SubjectCreation.webPageRouteName);

    if (hyperLinkList.length != 1) {
      return _parseUnknownTimelineActivity(singleTimelineContent);
    }

    return WikiCreationSingle((b) => b
      ..user.replace(userInfo)
      ..newItemId = hyperLinkList[0].id
      ..newItemName = hyperLinkList[0].name
      ..bangumiContent = BangumiContent.Subject);
  }

  TimelineFeed _parseDoujinActivity(
      Element singleTimelineContent, FeedMetaInfo userInfo) {
    userInfo = updateUserAction(singleTimelineContent, userInfo);
    return _parseStatusUpdateMultiple(
        singleTimelineContent, userInfo, BangumiContent.Doujin);
  }

  bool _isFromMutedUser(
    TimelineFeed timelineFeed,
  ) {
    if (timelineFeed is UnknownTimelineActivity ||
        timelineFeed?.user?.username == null) {
      return false;
    }

    return mutedUsers.containsKey(timelineFeed.user.username);
  }

  /// Parses timeline html
  /// Note: if feedLoadType is set, [upperFeedId]/[lowerFeedId] might also need to be set
  /// If [timelineSource] is set to [TimelineSource.UserProfile], [userInfo] must
  /// not be null
  GetTimelineParsedResponse processTimelineFeeds(
    String rawHtml, {
    @required TimelineSource timelineSource,
    @required BangumiUserSmall userInfo,
    feedLoadType = FeedLoadType.Initial,
    upperFeedId = IntegerHelper.MAX_VALUE,
    lowerFeedId = IntegerHelper.MIN_VALUE,
  }) {
    /// if feedLoadType is not initial, one of them(or both) must have been set
    if (feedLoadType != FeedLoadType.Initial) {
      assert(upperFeedId != IntegerHelper.MAX_VALUE ||
          lowerFeedId != IntegerHelper.MIN_VALUE);
    }
    assert(
        feedLoadType == FeedLoadType.Initial ||
            feedLoadType == FeedLoadType.Newer ||
            feedLoadType == FeedLoadType.Older,
        'feedLoadType $feedLoadType is not supported');

    assert(timelineSource != TimelineSource.UserProfile ||
        (timelineSource == TimelineSource.UserProfile && userInfo != null));

    DocumentFragment document = parseFragment(rawHtml);

    /// [TimelineSource.UserProfile] doesn't require authentication, hence
    /// `_verifyAuthentication` doesn't work
    if (timelineSource != TimelineSource.UserProfile) {
      _verifyAuthentication(document);
    }

    List<TimelineFeed> feeds = [];
    bool truncateFeedsInStore = false;

    /// userAvatarImageCache contains cache of user avatar image
    /// key is user id(string), value is avatar image url
    /// bangumi will omit some user avatars if a user publishes multiple feeds
    /// in a row, in that case only the first  user feed will contain an avatar,
    /// munin wants to show user avatar for every feed so this cache is needed
    Map<String, String> userAvatarImageCache = {};

    for (var item in document.querySelectorAll('.tml_item')) {
      final feedId = parseEndsWithDigitId(item);

      /// if we are trying to load a newer feed, and response feed id is equal to
      /// or lower than max feed id in store, we've loaded all new contents and can break
      if (feedLoadType == FeedLoadType.Newer && feedId <= upperFeedId) {
        break;
      }

      /// if we are trying to load a older feed, and response feed id is equal to
      /// or larger than min feed id in store, it's possible a overlap
      /// and we check the next one
      /// i.e. feeds in store: feed1, feed2, feed3, new feeds: feed2, feed3, feed4
      /// we want to skip feed2, feed3 but keep feed4
      /// Another possibility is there are lots of unloaded newer feeds
      /// i.e. new feeds: feed1, feed2, feed2, feeds in store: feed101, feed102, feed103
      /// We want to skip these new feeds so feed is still in order
      /// Typically the latter case shouldn't happen, however since bangumi doesn't
      /// have a official timeline API, we have to 'guess' pagination of older
      /// feeds to load, and this guess doesn't work if there are lots of unloaded new feeds
      if (feedLoadType == FeedLoadType.Older && feedId >= lowerFeedId) {
        continue;
      }

      var singleTimelineItem = _parseFeed(item, feedId,
          userAvatarImageCache: userAvatarImageCache,
          userBasicInfo: userInfo,
          timelineSource: timelineSource);
      if (singleTimelineItem != null) {
        singleTimelineItem = singleTimelineItem.rebuild(
            (b) => b.isFromMutedUser = _isFromMutedUser(singleTimelineItem));
        feeds.add(singleTimelineItem);
      }
    }

    /// If total response feeds equal to [feedsPerPage], there must exist a gap between
    /// feeds in store and response feeds, we currently don't support load
    /// gap feeds due to limitation of bangumi, so all current feeds need to be
    /// truncated
    if (feedLoadType == FeedLoadType.Newer && feeds.length == feedsPerPage) {
      truncateFeedsInStore = true;
    }

    /// If user deletes some feeds after munin loads feed, some feed might get lost.
    /// However even Web Page version loses these feeds
    return GetTimelineParsedResponse(
        feeds: feeds,
        truncateFeedsInStore: truncateFeedsInStore,
        feedLoadType: feedLoadType,

        /// `fetchedTime` needs to be in utc in order to be serialized
        fetchedTime: DateTime.now().toUtc());
  }
}
