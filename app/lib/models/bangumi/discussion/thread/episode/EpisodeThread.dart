import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:munin/models/bangumi/discussion/thread/common/BangumiThread.dart';
import 'package:munin/models/bangumi/discussion/thread/common/Post.dart';
import 'package:munin/models/bangumi/discussion/thread/common/utils.dart';
import 'package:munin/models/bangumi/discussion/thread/episode/ThreadRelatedEpisode.dart';
import 'package:munin/models/bangumi/discussion/thread/post/MainPostReply.dart';
import 'package:munin/models/bangumi/subject/common/ParentSubject.dart';
import 'package:munin/shared/utils/serializers.dart';

part 'EpisodeThread.g.dart';

abstract class EpisodeThread
    implements BangumiThread, Built<EpisodeThread, EpisodeThreadBuilder> {
  @override

  /// Title of the thread, it's typically the episode title.
  String get title;

  /// Description of the episode in html.
  String get descriptionHtml;

  BuiltList<ThreadRelatedEpisode> get relatedEpisodes;

  /// The parent subject that current [EpisodeThread] is under.
  /// While theoretically it's not supposed to be null, since this data is obtained
  /// from parsing html and itself is considered less important, setting it to
  /// null helps handling some unknown changes in html.
  @nullable
  ParentSubject get parentSubject;

  /// A flattened list of all posts.
  @memoized
  List<Post> get normalModePosts {
    return mergePostsWithMainPostReplies([], mainPostReplies);
  }

  @override
  @memoized
  List<Post> get hasNewestReplyFirstNestedPosts {
    return mergePostsWithHasNewestReplyFirstNestedPosts([], mainPostReplies,);
  }

  @override
  @memoized
  List<Post> get newestFirstFlattenedPosts {
    return flattenedReverseOrderMainPostReplies([], mainPostReplies);
  }

  EpisodeThread._();

  factory EpisodeThread([void Function(EpisodeThreadBuilder) updates]) =
      _$EpisodeThread;

  String toJson() {
    return json
        .encode(serializers.serializeWith(EpisodeThread.serializer, this));
  }

  static EpisodeThread fromJson(String jsonString) {
    return serializers.deserializeWith(
        EpisodeThread.serializer, json.decode(jsonString));
  }

  static Serializer<EpisodeThread> get serializer => _$episodeThreadSerializer;
}
