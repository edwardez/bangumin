// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BangumiSubject.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<BangumiSubject> _$bangumiSubjectSerializer =
    new _$BangumiSubjectSerializer();

class _$BangumiSubjectSerializer
    implements StructuredSerializer<BangumiSubject> {
  @override
  final Iterable<Type> types = const [BangumiSubject, _$BangumiSubject];
  @override
  final String wireName = 'BangumiSubject';

  @override
  Iterable serialize(Serializers serializers, BangumiSubject object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'type',
      serializers.serialize(object.type,
          specifiedType: const FullType(SubjectType)),
      'summary',
      serializers.serialize(object.summary,
          specifiedType: const FullType(String)),
      'rating',
      serializers.serialize(object.rating,
          specifiedType: const FullType(Rating)),
      'images',
      serializers.serialize(object.images,
          specifiedType: const FullType(Images)),
      'bangumiSuggestedTags',
      serializers.serialize(object.bangumiSuggestedTags,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'userSelectedTags',
      serializers.serialize(object.userSelectedTags,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];
    if (object.subTypeName != null) {
      result
        ..add('subTypeName')
        ..add(serializers.serialize(object.subTypeName,
            specifiedType: const FullType(String)));
    }
    if (object.rank != null) {
      result
        ..add('rank')
        ..add(serializers.serialize(object.rank,
            specifiedType: const FullType(int)));
    }
    if (object.characters != null) {
      result
        ..add('crt')
        ..add(serializers.serialize(object.characters,
            specifiedType:
                const FullType(BuiltList, const [const FullType(Character)])));
    }
    if (object.relatedSubjects != null) {
      result
        ..add('relatedSubjects')
        ..add(serializers.serialize(object.relatedSubjects,
            specifiedType: const FullType(BuiltListMultimap, const [
              const FullType(String),
              const FullType(RelatedSubject)
            ])));
    }
    if (object.commentsPreview != null) {
      result
        ..add('commentsPreview')
        ..add(serializers.serialize(object.commentsPreview,
            specifiedType: const FullType(
                BuiltList, const [const FullType(SubjectComment)])));
    }
    if (object.infoBoxRows != null) {
      result
        ..add('infoBoxRows')
        ..add(serializers.serialize(object.infoBoxRows,
            specifiedType: const FullType(BuiltListMultimap,
                const [const FullType(String), const FullType(InfoBoxItem)])));
    }
    if (object.user != null) {
      result
        ..add('user')
        ..add(serializers.serialize(object.user,
            specifiedType: const FullType(BuiltListMultimap,
                const [const FullType(String), const FullType(InfoBoxItem)])));
    }
    if (object.curatedInfoBoxRows != null) {
      result
        ..add('curatedInfoBoxRows')
        ..add(serializers.serialize(object.curatedInfoBoxRows,
            specifiedType: const FullType(BuiltListMultimap,
                const [const FullType(String), const FullType(InfoBoxItem)])));
    }
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(int)));
    }
    if (object.pageUrlFromApi != null) {
      result
        ..add('url')
        ..add(serializers.serialize(object.pageUrlFromApi,
            specifiedType: const FullType(String)));
    }
    if (object.nameCn != null) {
      result
        ..add('name_cn')
        ..add(serializers.serialize(object.nameCn,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  BangumiSubject deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BangumiSubjectBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(SubjectType)) as SubjectType;
          break;
        case 'subTypeName':
          result.subTypeName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'summary':
          result.summary = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'rating':
          result.rating.replace(serializers.deserialize(value,
              specifiedType: const FullType(Rating)) as Rating);
          break;
        case 'rank':
          result.rank = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'images':
          result.images.replace(serializers.deserialize(value,
              specifiedType: const FullType(Images)) as Images);
          break;
        case 'crt':
          result.characters.replace(serializers.deserialize(value,
              specifiedType: const FullType(
                  BuiltList, const [const FullType(Character)])) as BuiltList);
          break;
        case 'relatedSubjects':
          result.relatedSubjects.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltListMultimap, const [
                const FullType(String),
                const FullType(RelatedSubject)
              ])) as BuiltListMultimap);
          break;
        case 'commentsPreview':
          result.commentsPreview.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(SubjectComment)]))
              as BuiltList);
          break;
        case 'infoBoxRows':
          result.infoBoxRows.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltListMultimap, const [
                const FullType(String),
                const FullType(InfoBoxItem)
              ])) as BuiltListMultimap);
          break;
        case 'bangumiSuggestedTags':
          result.bangumiSuggestedTags.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList);
          break;
        case 'userSelectedTags':
          result.userSelectedTags.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList);
          break;
        case 'user':
          result.user.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltListMultimap, const [
                const FullType(String),
                const FullType(InfoBoxItem)
              ])) as BuiltListMultimap);
          break;
        case 'curatedInfoBoxRows':
          result.curatedInfoBoxRows.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltListMultimap, const [
                const FullType(String),
                const FullType(InfoBoxItem)
              ])) as BuiltListMultimap);
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'url':
          result.pageUrlFromApi = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name_cn':
          result.nameCn = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BangumiSubject extends BangumiSubject {
  @override
  final SubjectType type;
  @override
  final String subTypeName;
  @override
  final String summary;
  @override
  final Rating rating;
  @override
  final int rank;
  @override
  final Images images;
  @override
  final BuiltList<Character> characters;
  @override
  final BuiltListMultimap<String, RelatedSubject> relatedSubjects;
  @override
  final BuiltList<SubjectComment> commentsPreview;
  @override
  final BuiltListMultimap<String, InfoBoxItem> infoBoxRows;
  @override
  final BuiltList<String> bangumiSuggestedTags;
  @override
  final BuiltList<String> userSelectedTags;
  @override
  final BuiltListMultimap<String, InfoBoxItem> user;
  @override
  final BuiltListMultimap<String, InfoBoxItem> curatedInfoBoxRows;
  @override
  final int id;
  @override
  final String pageUrlFromApi;
  @override
  final String name;
  @override
  final String nameCn;
  String __infoBoxRowsPlainText;
  String __pageUrlFromCalculation;

  factory _$BangumiSubject([void updates(BangumiSubjectBuilder b)]) =>
      (new BangumiSubjectBuilder()..update(updates)).build();

  _$BangumiSubject._(
      {this.type,
      this.subTypeName,
      this.summary,
      this.rating,
      this.rank,
      this.images,
      this.characters,
      this.relatedSubjects,
      this.commentsPreview,
      this.infoBoxRows,
      this.bangumiSuggestedTags,
      this.userSelectedTags,
      this.user,
      this.curatedInfoBoxRows,
      this.id,
      this.pageUrlFromApi,
      this.name,
      this.nameCn})
      : super._() {
    if (type == null) {
      throw new BuiltValueNullFieldError('BangumiSubject', 'type');
    }
    if (summary == null) {
      throw new BuiltValueNullFieldError('BangumiSubject', 'summary');
    }
    if (rating == null) {
      throw new BuiltValueNullFieldError('BangumiSubject', 'rating');
    }
    if (images == null) {
      throw new BuiltValueNullFieldError('BangumiSubject', 'images');
    }
    if (bangumiSuggestedTags == null) {
      throw new BuiltValueNullFieldError(
          'BangumiSubject', 'bangumiSuggestedTags');
    }
    if (userSelectedTags == null) {
      throw new BuiltValueNullFieldError('BangumiSubject', 'userSelectedTags');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('BangumiSubject', 'name');
    }
  }

  @override
  String get infoBoxRowsPlainText =>
      __infoBoxRowsPlainText ??= super.infoBoxRowsPlainText;

  @override
  String get pageUrlFromCalculation =>
      __pageUrlFromCalculation ??= super.pageUrlFromCalculation;

  @override
  BangumiSubject rebuild(void updates(BangumiSubjectBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  BangumiSubjectBuilder toBuilder() =>
      new BangumiSubjectBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BangumiSubject &&
        type == other.type &&
        subTypeName == other.subTypeName &&
        summary == other.summary &&
        rating == other.rating &&
        rank == other.rank &&
        images == other.images &&
        characters == other.characters &&
        relatedSubjects == other.relatedSubjects &&
        commentsPreview == other.commentsPreview &&
        infoBoxRows == other.infoBoxRows &&
        bangumiSuggestedTags == other.bangumiSuggestedTags &&
        userSelectedTags == other.userSelectedTags &&
        user == other.user &&
        curatedInfoBoxRows == other.curatedInfoBoxRows &&
        id == other.id &&
        pageUrlFromApi == other.pageUrlFromApi &&
        name == other.name &&
        nameCn == other.nameCn;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc(
                                                                    $jc(
                                                                        $jc(
                                                                            0,
                                                                            type
                                                                                .hashCode),
                                                                        subTypeName
                                                                            .hashCode),
                                                                    summary
                                                                        .hashCode),
                                                                rating
                                                                    .hashCode),
                                                            rank.hashCode),
                                                        images.hashCode),
                                                    characters.hashCode),
                                                relatedSubjects.hashCode),
                                            commentsPreview.hashCode),
                                        infoBoxRows.hashCode),
                                    bangumiSuggestedTags.hashCode),
                                userSelectedTags.hashCode),
                            user.hashCode),
                        curatedInfoBoxRows.hashCode),
                    id.hashCode),
                pageUrlFromApi.hashCode),
            name.hashCode),
        nameCn.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BangumiSubject')
          ..add('type', type)
          ..add('subTypeName', subTypeName)
          ..add('summary', summary)
          ..add('rating', rating)
          ..add('rank', rank)
          ..add('images', images)
          ..add('characters', characters)
          ..add('relatedSubjects', relatedSubjects)
          ..add('commentsPreview', commentsPreview)
          ..add('infoBoxRows', infoBoxRows)
          ..add('bangumiSuggestedTags', bangumiSuggestedTags)
          ..add('userSelectedTags', userSelectedTags)
          ..add('user', user)
          ..add('curatedInfoBoxRows', curatedInfoBoxRows)
          ..add('id', id)
          ..add('pageUrlFromApi', pageUrlFromApi)
          ..add('name', name)
          ..add('nameCn', nameCn))
        .toString();
  }
}

class BangumiSubjectBuilder
    implements
        Builder<BangumiSubject, BangumiSubjectBuilder>,
        SubjectBaseBuilder {
  _$BangumiSubject _$v;

  SubjectType _type;
  SubjectType get type => _$this._type;
  set type(SubjectType type) => _$this._type = type;

  String _subTypeName;
  String get subTypeName => _$this._subTypeName;
  set subTypeName(String subTypeName) => _$this._subTypeName = subTypeName;

  String _summary;
  String get summary => _$this._summary;
  set summary(String summary) => _$this._summary = summary;

  RatingBuilder _rating;
  RatingBuilder get rating => _$this._rating ??= new RatingBuilder();
  set rating(RatingBuilder rating) => _$this._rating = rating;

  int _rank;
  int get rank => _$this._rank;
  set rank(int rank) => _$this._rank = rank;

  ImagesBuilder _images;
  ImagesBuilder get images => _$this._images ??= new ImagesBuilder();
  set images(ImagesBuilder images) => _$this._images = images;

  ListBuilder<Character> _characters;
  ListBuilder<Character> get characters =>
      _$this._characters ??= new ListBuilder<Character>();
  set characters(ListBuilder<Character> characters) =>
      _$this._characters = characters;

  ListMultimapBuilder<String, RelatedSubject> _relatedSubjects;
  ListMultimapBuilder<String, RelatedSubject> get relatedSubjects =>
      _$this._relatedSubjects ??=
          new ListMultimapBuilder<String, RelatedSubject>();
  set relatedSubjects(
          ListMultimapBuilder<String, RelatedSubject> relatedSubjects) =>
      _$this._relatedSubjects = relatedSubjects;

  ListBuilder<SubjectComment> _commentsPreview;
  ListBuilder<SubjectComment> get commentsPreview =>
      _$this._commentsPreview ??= new ListBuilder<SubjectComment>();
  set commentsPreview(ListBuilder<SubjectComment> commentsPreview) =>
      _$this._commentsPreview = commentsPreview;

  ListMultimapBuilder<String, InfoBoxItem> _infoBoxRows;
  ListMultimapBuilder<String, InfoBoxItem> get infoBoxRows =>
      _$this._infoBoxRows ??= new ListMultimapBuilder<String, InfoBoxItem>();
  set infoBoxRows(ListMultimapBuilder<String, InfoBoxItem> infoBoxRows) =>
      _$this._infoBoxRows = infoBoxRows;

  ListBuilder<String> _bangumiSuggestedTags;
  ListBuilder<String> get bangumiSuggestedTags =>
      _$this._bangumiSuggestedTags ??= new ListBuilder<String>();
  set bangumiSuggestedTags(ListBuilder<String> bangumiSuggestedTags) =>
      _$this._bangumiSuggestedTags = bangumiSuggestedTags;

  ListBuilder<String> _userSelectedTags;
  ListBuilder<String> get userSelectedTags =>
      _$this._userSelectedTags ??= new ListBuilder<String>();
  set userSelectedTags(ListBuilder<String> userSelectedTags) =>
      _$this._userSelectedTags = userSelectedTags;

  ListMultimapBuilder<String, InfoBoxItem> _user;
  ListMultimapBuilder<String, InfoBoxItem> get user =>
      _$this._user ??= new ListMultimapBuilder<String, InfoBoxItem>();
  set user(ListMultimapBuilder<String, InfoBoxItem> user) =>
      _$this._user = user;

  ListMultimapBuilder<String, InfoBoxItem> _curatedInfoBoxRows;
  ListMultimapBuilder<String, InfoBoxItem> get curatedInfoBoxRows =>
      _$this._curatedInfoBoxRows ??=
          new ListMultimapBuilder<String, InfoBoxItem>();
  set curatedInfoBoxRows(
          ListMultimapBuilder<String, InfoBoxItem> curatedInfoBoxRows) =>
      _$this._curatedInfoBoxRows = curatedInfoBoxRows;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _pageUrlFromApi;
  String get pageUrlFromApi => _$this._pageUrlFromApi;
  set pageUrlFromApi(String pageUrlFromApi) =>
      _$this._pageUrlFromApi = pageUrlFromApi;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _nameCn;
  String get nameCn => _$this._nameCn;
  set nameCn(String nameCn) => _$this._nameCn = nameCn;

  BangumiSubjectBuilder();

  BangumiSubjectBuilder get _$this {
    if (_$v != null) {
      _type = _$v.type;
      _subTypeName = _$v.subTypeName;
      _summary = _$v.summary;
      _rating = _$v.rating?.toBuilder();
      _rank = _$v.rank;
      _images = _$v.images?.toBuilder();
      _characters = _$v.characters?.toBuilder();
      _relatedSubjects = _$v.relatedSubjects?.toBuilder();
      _commentsPreview = _$v.commentsPreview?.toBuilder();
      _infoBoxRows = _$v.infoBoxRows?.toBuilder();
      _bangumiSuggestedTags = _$v.bangumiSuggestedTags?.toBuilder();
      _userSelectedTags = _$v.userSelectedTags?.toBuilder();
      _user = _$v.user?.toBuilder();
      _curatedInfoBoxRows = _$v.curatedInfoBoxRows?.toBuilder();
      _id = _$v.id;
      _pageUrlFromApi = _$v.pageUrlFromApi;
      _name = _$v.name;
      _nameCn = _$v.nameCn;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant BangumiSubject other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BangumiSubject;
  }

  @override
  void update(void updates(BangumiSubjectBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$BangumiSubject build() {
    _$BangumiSubject _$result;
    try {
      _$result = _$v ??
          new _$BangumiSubject._(
              type: type,
              subTypeName: subTypeName,
              summary: summary,
              rating: rating.build(),
              rank: rank,
              images: images.build(),
              characters: _characters?.build(),
              relatedSubjects: _relatedSubjects?.build(),
              commentsPreview: _commentsPreview?.build(),
              infoBoxRows: _infoBoxRows?.build(),
              bangumiSuggestedTags: bangumiSuggestedTags.build(),
              userSelectedTags: userSelectedTags.build(),
              user: _user?.build(),
              curatedInfoBoxRows: _curatedInfoBoxRows?.build(),
              id: id,
              pageUrlFromApi: pageUrlFromApi,
              name: name,
              nameCn: nameCn);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'rating';
        rating.build();

        _$failedField = 'images';
        images.build();
        _$failedField = 'characters';
        _characters?.build();
        _$failedField = 'relatedSubjects';
        _relatedSubjects?.build();
        _$failedField = 'commentsPreview';
        _commentsPreview?.build();
        _$failedField = 'infoBoxRows';
        _infoBoxRows?.build();
        _$failedField = 'bangumiSuggestedTags';
        bangumiSuggestedTags.build();
        _$failedField = 'userSelectedTags';
        userSelectedTags.build();
        _$failedField = 'user';
        _user?.build();
        _$failedField = 'curatedInfoBoxRows';
        _curatedInfoBoxRows?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BangumiSubject', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new