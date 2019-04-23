import 'package:flutter/material.dart';
import 'package:munin/models/bangumi/timeline/common/FeedLoadType.dart';
import 'package:munin/providers/bangumi/timeline/BangumiTimelineService.dart';
import 'package:munin/providers/bangumi/timeline/parser/TimelineParser.dart';
import 'package:munin/redux/app/AppState.dart';
import 'package:munin/redux/timeline/FeedChunks.dart';
import 'package:munin/redux/timeline/TimelineActions.dart';
import 'package:munin/shared/utils/common.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

List<Epic<AppState>> createTimelineEpics(
    BangumiTimelineService bangumiTimelineService) {
  final loadTimelineFeedEpic = _createLoadTimelineEpics(bangumiTimelineService);

  return [
    loadTimelineFeedEpic,
  ];
}

Stream<dynamic> _loadTimeline(BangumiTimelineService bangumiTimelineService,
    LoadTimelineRequest action, EpicStore<AppState> store) async* {
  try {
    assert(action.feedLoadType == FeedLoadType.Initial ||
        action.feedLoadType == FeedLoadType.Newer ||
        action.feedLoadType == FeedLoadType.Older);

    int upperFeedId = IntegerHelper.MAX_VALUE;
    int lowerFeedId = IntegerHelper.MIN_VALUE;
    int nextPageNum;

    FeedChunks feedChunks =
        store.state.timelineState.timeline[action.fetchTimelineRequest] ??
            FeedChunks();

    /// For newer feeds, we don't need to set [nextPageNum]
    if (action.feedLoadType == FeedLoadType.Newer) {
      ///if firstChunkMaxIdOrNull is null, most likely it's a [UnknownTimelineActivity]
      /// so feedId cannot be filled in we just load all new feeds
      /// TODO: clean up all older feeds in this case?
      upperFeedId = feedChunks.firstChunkMaxIdOrNull ?? IntegerHelper.MIN_VALUE;
    }

    if (action.feedLoadType == FeedLoadType.Older) {
      /// if firstChunkMinIdOrNull is null, most likely it's a
      /// [UnknownTimelineActivity] so feedId cannot be filled in
      /// we just load all new feeds
      /// TODO: clean up all newer feeds in this case?
      lowerFeedId = feedChunks.firstChunkMaxIdOrNull ?? IntegerHelper.MAX_VALUE;

      int tentativeNextPageNum = 1 + feedChunks.first.length ~/ feedsPerPage;

      /// To ensure all feeds are delivered, we need to consider all scenarios
      /// (assume every time we fetch 10 feeds)
      /// 1. if current feed length can be divided by [feedsPerPage], just get the next
      /// page
      /// 2. if current feed length cannot be divided by [feedsPerPage]:
      /// we always fetch feed on
      /// 2.1 There are no un-fetched new feeds. i.e. user has
      /// feed 1 - feed 11. This can happen if user fetches 10 feeds at first,
      /// then tries to request new feeds which returns 1 feed
      /// If this is true, next fetch for page 2 should return 9 valid feeds
      /// We just return these 9 valid feeds
      /// 2.2 There are some un-fetched new feeds, and it's < 10. i.e.
      /// [un-fetched feed1-feed5], feed 6 - feed 20,
      /// This can happen if user fetches 10 feeds(feed6-feed17) at first, then doesn't fetch for a
      /// long time.
      /// If user then tries to request older feeds on page 2, only 2 feeds will be
      /// returned(feed18-19). Now user has 14 feeds
      /// If this is true, next fetch for page 2 should return 0 valid feeds
      /// Then we set nextPageNum to page 3
      /// 2.3 un-fetched new feeds are >10, very tricky to handle this scenario
      /// due to limitation of Bangumi. We just repeat logic in 2.1/2.2 for now.
      /// One more thing to consider is in 2.1, if current feeds are near next ~10
      /// like 19. We will only receive 1 valid feeds every time. But this situation
      /// is very rare(we might improve this logic if it happens frequently).
      /// tl;dr: if current feed length cannot be divided by [feedsPerPage], fetch
      /// the next possible page num first, if that returns 0 feed, then fetch
      /// the page after next possible page num
      if (feedChunks.first.length % feedsPerPage == 0) {
        nextPageNum = tentativeNextPageNum;
      } else {
        FetchFeedsResult fetchFeedsResult =
            await bangumiTimelineService.getTimeline(
                fetchTimelineRequest: action.fetchTimelineRequest,
                nextPageNum: tentativeNextPageNum,
                feedLoadType: action.feedLoadType,
                lowerFeedId: lowerFeedId,
                upperFeedId: upperFeedId);
        if (fetchFeedsResult.feeds.length == 0) {
          nextPageNum = tentativeNextPageNum + 1;
        } else {
          yield LoadTimelineSuccess(
              fetchTimelineRequest: action.fetchTimelineRequest,
              fetchFeedsResult: fetchFeedsResult);
          return;
        }
      }

      /// For older feeds, [nextPageNum] must be present
      assert(nextPageNum != null);
    }

    if (action.feedLoadType == FeedLoadType.Gap) {
      throw UnimplementedError(
          '${action.feedLoadType} is currently not implemented');
    }

    FetchFeedsResult fetchFeedsResult =
        await bangumiTimelineService.getTimeline(
            fetchTimelineRequest: action.fetchTimelineRequest,
            nextPageNum: nextPageNum,
            feedLoadType: action.feedLoadType,
            lowerFeedId: lowerFeedId,
            upperFeedId: upperFeedId);

    debugPrint('Feeds number before loading: ${feedChunks.first.length}.'
        ' Recevied ${fetchFeedsResult.feeds.length} new feeds.');

    yield LoadTimelineSuccess(
        fetchTimelineRequest: action.fetchTimelineRequest,
        fetchFeedsResult: fetchFeedsResult);
    action.completer.complete();
  } catch (error, stack) {
    action.completer.completeError(error, stack);

    /// For loading older feeds, error messages are directly shown on item list
    if (action.feedLoadType == FeedLoadType.Initial ||
        action.feedLoadType == FeedLoadType.Newer) {
      Scaffold.of(action.context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }

    print(error.toString());
    print(stack);
  }
}

Epic<AppState> _createLoadTimelineEpics(
    BangumiTimelineService bangumiTimelineService) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) {
    return Observable(actions)
        .ofType(TypeToken<LoadTimelineRequest>())
        .switchMap(
            (action) => _loadTimeline(bangumiTimelineService, action, store));
  };
}