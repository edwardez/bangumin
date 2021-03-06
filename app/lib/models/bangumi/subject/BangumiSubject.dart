import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:munin/config/application.dart';
import 'package:munin/models/bangumi/common/BangumiImage.dart';
import 'package:munin/models/bangumi/mono/Character.dart';
import 'package:munin/models/bangumi/subject/CollectionStatusDistribution.dart';
import 'package:munin/models/bangumi/subject/Rating.dart';
import 'package:munin/models/bangumi/subject/RelatedSubject.dart';
import 'package:munin/models/bangumi/subject/SubjectCollectionInfoPreview.dart';
import 'package:munin/models/bangumi/subject/common/SubjectStatus.dart';
import 'package:munin/models/bangumi/subject/common/SubjectType.dart';
import 'package:munin/models/bangumi/subject/common/SujectBase.dart';
import 'package:munin/models/bangumi/subject/info/InfoBoxItem.dart';
import 'package:munin/models/bangumi/subject/info/InfoBoxRow.dart';
import 'package:munin/models/bangumi/subject/progress/SubjectProgressPreview.dart';
import 'package:munin/models/bangumi/subject/review/SubjectReview.dart';
import 'package:munin/shared/utils/serializers.dart';

part 'BangumiSubject.g.dart';

abstract class BangumiSubject
    implements SubjectBase, Built<BangumiSubject, BangumiSubjectBuilder> {
  SubjectType get type;

  SubjectStatus get subjectStatus;

  /// for anime, is it a TV series or a movie
  /// for book, is it a comic or novel?..etc
  /// this info is not always available and it's currently a string instead of
  /// a enum since we are parsing html and there are too many types
  /// Also note this subType might be slightly different from [RelatedSubject.subjectSubTypeName]
  /// i.e. if [BangumiSubject.subTypeName] is 小说系列, then
  /// [RelatedSubject.subjectSubTypeName] is 系列 for some subjects
  @nullable
  String get subTypeName;

  @BuiltValueField(wireName: 'summary')
  String get summary;

  @BuiltValueField(wireName: 'rating')
  Rating get rating;

  @nullable
  @BuiltValueField(wireName: 'rank')
  int get rank;

  @BuiltValueField(wireName: 'images')
  BangumiImage get cover;

  @nullable
  @BuiltValueField(wireName: 'crt')
  BuiltList<Character> get characters;

  /// key is [RelatedSubject.subjectSubType], value is list of related subjects
  @nullable
  BuiltListMultimap<String, RelatedSubject> get relatedSubjects;

  /// Tankobon of a book.
  /// Null for subject that is not a book, or a book that doesn't have a
  /// tankobon.
  @nullable
  BuiltList<RelatedSubject> get tankobonSubjects;

  @nullable

  /// a short preview list of comments that are on subject main page
  BuiltList<SubjectReview> get commentsPreview;

  /// Collection info preview of current user
  /// Note: this info is parsed from html to ensure subject info can be fetched in one call
  /// thus should only be used for preview purpose.To get the accurate info
  /// Bangumi API should be used
  SubjectCollectionInfoPreview get userSubjectCollectionInfoPreview;

  /// key is row name, value is InfoBoxRow
  /// we need to use this data structure because Bangumi might use multiple rows
  /// to display info that's under the same rowName, and these need to be
  /// merged into one row, like:
  /// <li><span class="tip">平台: </span>PS4、PS3</li>
  /// <li><span class="tip" style="visibility:hidden;">平台: </span>PC</li>
  /// The default behaviour of ListMultimap is keys are retrieved in the same
  /// order as they stored, so key sequence are guaranteed(which is important to us)
  /// value has to be [InfoBoxRow] (which contains a list of [InfoBoxItem]) instead of
  /// a flatten list of [InfoBoxItem], reason is in each InfoBoxRow, Bangumi separates
  /// items using a `、`, so we need to add a a `、` between each [InfoBoxRow] as well
  /// i.e. in the above example, there is a `、` between PS4 and PS3, we want to
  /// add a `、` between PS3 and PC as well
  @nullable
  BuiltListMultimap<String, InfoBoxItem> get infoBoxRows;

  /// A list of tags that are suggested by bangumi
  BuiltList<String> get bangumiSuggestedTags;

  /// A list of tags that have been selected by user for this subject
  BuiltList<String> get userSelectedTags;

  @BuiltValueField(wireName: 'collection')
  CollectionStatusDistribution get collectionStatusDistribution;

  /// Progress information of a subject.
  SubjectProgressPreview get subjectProgressPreview;

  @memoized
  String get infoBoxRowsPlainText {
    String plainText = '';

    infoBoxRows.forEachKey((a, b) {
      plainText += '$a: ';

      b.forEach((InfoBoxItem infoBoxItem) {
        plainText += infoBoxItem.name;
      });
      plainText += '\n';
    });

    return plainText;
  }

  /// A list of curated info box rows
  /// These rows will present to user on subject main page
  /// while rows in [infoBoxRows] will only be shown if user taps 'lean more'
  /// [curatedInfoBoxRows] should be a subset of [infoBoxRows] that only contains
  /// most important info of a subject
  @nullable
  BuiltListMultimap<String, InfoBoxItem> get curatedInfoBoxRows;

  /// a runtime generated subject url
  /// see also [pageUrl]
  @memoized
  String get pageUrlFromCalculation {
    return 'https://$bangumiMainHost/subject/$id';
  }

  BangumiSubject._();

  factory BangumiSubject([updates(BangumiSubjectBuilder b)]) = _$BangumiSubject;

  String toJson() {
    return json
        .encode(serializers.serializeWith(BangumiSubject.serializer, this));
  }

  static BangumiSubject fromJson(String jsonString) {
    return serializers.deserializeWith(
        BangumiSubject.serializer, json.decode(jsonString));
  }

  static Serializer<BangumiSubject> get serializer =>
      _$bangumiSubjectSerializer;

  /// below fields are in bangumi rest api but currently not in use by Munin
  ///   @BuiltValueField(wireName: 'air_date')
  ///  String get airDate;
  ///  @BuiltValueField(wireName: 'air_weekday')
  ///  int get airWeekday;
  ///    @BuiltValueField(wireName: 'type')
  ///  SubjectType get type;
  ///    @BuiltValueField(wireName: 'topic')
  ///  BuiltList<Topic> get topic;
  ///  @BuiltValueField(wireName: 'blog')
  ///  BuiltList<Blog> get blog;
  ///    @nullable
  ///  @BuiltValueField(wireName: 'eps')
  ///  BuiltList<Episode> get episodes;
  ///
  ///  @nullable
  ///  @BuiltValueField(wireName: 'eps_count')
  ///  int get episodesCount;
  ///
}
