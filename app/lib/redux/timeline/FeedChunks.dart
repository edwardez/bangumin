import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:munin/models/bangumi/timeline/common/TimelineFeed.dart';
import 'package:munin/providers/bangumi/timeline/parser/TimelineParser.dart';
import 'package:munin/shared/utils/serializers.dart';

part 'FeedChunks.g.dart';

abstract class FeedChunks implements Built<FeedChunks, FeedChunksBuilder> {
  static const Duration staleDataThreshold = Duration(minutes: 5);

  BuiltList<TimelineFeed> get filteredFeeds;

  /// A list of feeds that include feed has been muted by the user
  /// It's used to track actual count of feeds in order to send next fetch timeline
  /// request
  BuiltList<TimelineFeed> get unfilteredFeeds;

  /// The last time munin completes fetching feed response
  @nullable
  DateTime get lastFetchedTime;

  /// theoretically speaking, user cannot easily reach end of their timeline feeds
  /// and we should always allow user to load more, however due to limitation
  /// of Bangumi, we might need to prevent user from loading more feeds
  /// see [TimelineParser]
  /// there is also a [hasReachedEnd], this value will be set to true if user
  /// do have reached end of timeline feeds
  bool get hasReachedEnd;

  bool get disableLoadingMore;

  bool get isStale {
    return !hasReachedEnd &&
        lastFetchedTime != null &&
        DateTime.now().difference(lastFetchedTime) >= staleDataThreshold;
  }

  @memoized
  int get feedsCount {
    return filteredFeeds.length;
  }

  /// reserved, currently not in use
  ///  BuiltList<TimelineFeed> get second;
  ///  @memoized
  ///  int get secondChunkMaxIdOrNull {
  ///    return firstOrNullInBuiltList<TimelineFeed>(second)?.user?.feedId;
  ///  }
  ///
  ///  @memoized
  ///  int get secondChunkMinIdOrNull {
  ///    return lastOrNullInBuiltList<TimelineFeed>(second)?.user?.feedId;
  ///  }

  /// returns null if index is invalid or there is currently no feed
  TimelineFeed getFeedAt(int index) {
    if (index > feedsCount || feedsCount == 0) {
      return null;
    }

    return filteredFeeds[index];
  }

  FeedChunks._();

  factory FeedChunks([updates(FeedChunksBuilder b)]) => _$FeedChunks((b) => b
    ..filteredFeeds.replace(BuiltList<TimelineFeed>())
    ..unfilteredFeeds.replace(BuiltList<TimelineFeed>())
    ..hasReachedEnd = false
    ..disableLoadingMore = false
    ..update(updates));

  String toJson() {
    return json.encode(serializers.serializeWith(FeedChunks.serializer, this));
  }

  static FeedChunks fromJson(String jsonString) {
    return serializers.deserializeWith(
        FeedChunks.serializer, json.decode(jsonString));
  }

  static Serializer<FeedChunks> get serializer => _$feedChunksSerializer;
}
