import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:munin/models/bangumi/collection/CollectionStatus.dart';
import 'package:munin/models/bangumi/discussion/thread/common/GetThreadRequest.dart';
import 'package:munin/models/bangumi/discussion/thread/common/ThreadType.dart';
import 'package:munin/models/bangumi/setting/general/GeneralSetting.dart';
import 'package:munin/models/bangumi/subject/common/SubjectType.dart';
import 'package:munin/models/bangumi/subject/review/enum/SubjectReviewMainFilter.dart';
import 'package:munin/models/bangumi/user/collection/full/ListUserCollectionsRequest.dart';
import 'package:munin/models/bangumi/user/collection/full/OrderCollectionBy.dart';
import 'package:munin/router/routes.dart';
import 'package:munin/shared/utils/common.dart';
import 'package:munin/widgets/discussion/thread/shared/GenericThreadWidget.dart';
import 'package:munin/widgets/home/MuninHomePage.dart';
import 'package:munin/widgets/initial/MuninLoginPage.dart';
import 'package:munin/widgets/setting/Setting.dart';
import 'package:munin/widgets/setting/general/GeneralSettingWidget.dart';
import 'package:munin/widgets/setting/mute/ImportBlockedBangumiUsersWidget.dart';
import 'package:munin/widgets/setting/mute/MuteSettingWidget.dart';
import 'package:munin/widgets/setting/privacy/PrivacySettingWidget.dart';
import 'package:munin/widgets/setting/theme/ThemeSettingWidget.dart';
import 'package:munin/widgets/subject/SubjectWidget.dart';
import 'package:munin/widgets/subject/episodes/SubjectEpisodesWidget.dart';
import 'package:munin/widgets/subject/info/SubjectDetailInfoWidget.dart';
import 'package:munin/widgets/subject/management/SubjectCollectionManagementWidget.dart';
import 'package:munin/widgets/subject/reviews/SubjectReviewsWidget.dart';
import 'package:munin/widgets/timeline/compose/ComposeTimelineMessage.dart';
import 'package:munin/widgets/user/UserProfileWidget.dart';
import 'package:munin/widgets/user/collections/UserCollectionsListWidget.dart';

final loginRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MuninLoginPage();
});

final homeRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MuninHomePage(
    generalSetting: GeneralSetting(),
  );
});

final subjectMainPageRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String subjectIdStr = params[RoutesComponents.subjectId]?.first;
  int subjectId = tryParseInt(subjectIdStr, defaultValue: null);
  return Scaffold(
    body: SubjectWidget(
      subjectId: subjectId,
    ),
  );
});

final subjectDetailInfoRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String subjectIdStr = params[RoutesComponents.subjectId]?.first;
  int subjectId = tryParseInt(subjectIdStr, defaultValue: null);
  return Scaffold(
    body: SubjectDetailInfoWidget(
      subjectId: subjectId,
    ),
  );
});

final subjectCollectionManagementRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String subjectIdStr = params[RoutesComponents.subjectId]?.first;
  int subjectId = tryParseInt(subjectIdStr, defaultValue: null);
  return SubjectCollectionManagementWidget(
    subjectId: subjectId,
  );
});

final subjectEpisodesRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String subjectIdStr = params[RoutesComponents.subjectId]?.first;
  int subjectId = tryParseInt(subjectIdStr, defaultValue: null);
  return Scaffold(
    body: SubjectEpisodesWidget(
      subjectId: subjectId,
    ),
  );
});

final subjectReviewsRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  bool showOnlyFriends = tryParseBool(
      params[RoutesQueryParameter.subjectReviewsFriendOnly]?.first);

  SubjectReviewMainFilter mainFilter;
  String mainFilterStr =
      params[RoutesQueryParameter.subjectReviewsMainFilter]?.first;
  if (mainFilterStr != null) {
    mainFilter = SubjectReviewMainFilter.fromWiredName(mainFilterStr);
  }

  String subjectIdStr = params[RoutesComponents.subjectId]?.first;
  int subjectId = tryParseInt(subjectIdStr, defaultValue: null);

  return Scaffold(
    body: SubjectReviewsWidget(
      subjectId: subjectId,
      showOnlyFriends: showOnlyFriends,
      mainFilter: mainFilter,
    ),
  );
});

/// User
final userProfileRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String username = params[RoutesComponents.username]?.first;

  return Scaffold(
    body: UserProfileWidget(
      username: username,
    ),
  );
});

final composeTimelineMessageRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ComposeTimelineMessage();
});

final userCollectionsListRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  final username = params[RoutesComponents.username].first;

  final subjectType = SubjectType.getTypeByHttpWiredName(
      params[RoutesComponents.subjectType].first);

  final collectionStatus = CollectionStatus.fromWiredName(
      params[RoutesComponents.collectionStatus].first);

  return Scaffold(
    body: UserCollectionsListWidget(
      request: ListUserCollectionsRequest(
        (b) => b
          ..subjectType = subjectType
          ..username = username
          ..orderCollectionBy = OrderCollectionBy.CollectedTime
          ..collectionStatus = collectionStatus,
      ),
    ),
  );
});

Scaffold _threadHandler(BuildContext context, Map<String, List<String>> params,
    ThreadType threadType) {
  String threadIdStr = params[RoutesComponents.threadId]?.first;
  int threadId = tryParseInt(threadIdStr, defaultValue: null);
  assert(threadId != null);
  GetThreadRequest request = GetThreadRequest((b) => b
    ..threadType = threadType
    ..id = threadId);

  String postIdStr = params[RoutesComponents.postId]?.first;
  int postId = tryParseInt(postIdStr, defaultValue: null);
  return Scaffold(
    body: GenericThreadWidget(
      request: request,
      postId: postId,
    ),
  );
}

/// Discussion
final groupThreadRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return _threadHandler(context, params, ThreadType.Group);
});

final episodeThreadRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return _threadHandler(context, params, ThreadType.Episode);
});

final subjectTopicThreadRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return _threadHandler(context, params, ThreadType.SubjectTopic);
});

final blogThreadRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return _threadHandler(context, params, ThreadType.Blog);
});

/// Setting
final settingRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Scaffold(
    body: SettingHome(),
  );
});

final generalSettingRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Scaffold(
    body: GeneralSettingWidget(),
  );
});

final themeSettingRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Scaffold(
    body: ThemeSettingWidget(),
  );
});

final privacySettingRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Scaffold(
    body: PrivacySettingWidget(),
  );
});

final muteSettingRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Scaffold(
    body: MuteSettingWidget(),
  );
});

final muteSettingBatchImportUsersRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ImportBlockedBangumiUsersWidget();
});
