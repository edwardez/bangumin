// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StatusUpdateMultiple.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<StatusUpdateMultiple> _$statusUpdateMultipleSerializer =
    new _$StatusUpdateMultipleSerializer();

class _$StatusUpdateMultipleSerializer
    implements StructuredSerializer<StatusUpdateMultiple> {
  @override
  final Iterable<Type> types = const [
    StatusUpdateMultiple,
    _$StatusUpdateMultiple
  ];
  @override
  final String wireName = 'StatusUpdateMultiple';

  @override
  Iterable<Object> serialize(
      Serializers serializers, StatusUpdateMultiple object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'user',
      serializers.serialize(object.user,
          specifiedType: const FullType(FeedMetaInfo)),
      'hyperImages',
      serializers.serialize(object.hyperImages,
          specifiedType:
              const FullType(BuiltList, const [const FullType(HyperImage)])),
      'hyperBangumiItems',
      serializers.serialize(object.hyperBangumiItems,
          specifiedType: const FullType(
              BuiltList, const [const FullType(HyperBangumiItem)])),
      'bangumiContent',
      serializers.serialize(object.bangumiContent,
          specifiedType: const FullType(BangumiContent)),
    ];
    if (object.isFromMutedUser != null) {
      result
        ..add('isFromMutedUser')
        ..add(serializers.serialize(object.isFromMutedUser,
            specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  StatusUpdateMultiple deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new StatusUpdateMultipleBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'user':
          result.user.replace(serializers.deserialize(value,
              specifiedType: const FullType(FeedMetaInfo)) as FeedMetaInfo);
          break;
        case 'hyperImages':
          result.hyperImages.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(HyperImage)]))
              as BuiltList<dynamic>);
          break;
        case 'hyperBangumiItems':
          result.hyperBangumiItems.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(HyperBangumiItem)]))
              as BuiltList<dynamic>);
          break;
        case 'bangumiContent':
          result.bangumiContent = serializers.deserialize(value,
              specifiedType: const FullType(BangumiContent)) as BangumiContent;
          break;
        case 'isFromMutedUser':
          result.isFromMutedUser = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$StatusUpdateMultiple extends StatusUpdateMultiple {
  @override
  final FeedMetaInfo user;
  @override
  final BuiltList<HyperImage> hyperImages;
  @override
  final BuiltList<HyperBangumiItem> hyperBangumiItems;
  @override
  final BangumiContent bangumiContent;
  @override
  final bool isFromMutedUser;

  factory _$StatusUpdateMultiple(
          [void Function(StatusUpdateMultipleBuilder) updates]) =>
      (new StatusUpdateMultipleBuilder()..update(updates)).build();

  _$StatusUpdateMultiple._(
      {this.user,
      this.hyperImages,
      this.hyperBangumiItems,
      this.bangumiContent,
      this.isFromMutedUser})
      : super._() {
    if (user == null) {
      throw new BuiltValueNullFieldError('StatusUpdateMultiple', 'user');
    }
    if (hyperImages == null) {
      throw new BuiltValueNullFieldError('StatusUpdateMultiple', 'hyperImages');
    }
    if (hyperBangumiItems == null) {
      throw new BuiltValueNullFieldError(
          'StatusUpdateMultiple', 'hyperBangumiItems');
    }
    if (bangumiContent == null) {
      throw new BuiltValueNullFieldError(
          'StatusUpdateMultiple', 'bangumiContent');
    }
  }

  @override
  StatusUpdateMultiple rebuild(
          void Function(StatusUpdateMultipleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StatusUpdateMultipleBuilder toBuilder() =>
      new StatusUpdateMultipleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatusUpdateMultiple &&
        user == other.user &&
        hyperImages == other.hyperImages &&
        hyperBangumiItems == other.hyperBangumiItems &&
        bangumiContent == other.bangumiContent &&
        isFromMutedUser == other.isFromMutedUser;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, user.hashCode), hyperImages.hashCode),
                hyperBangumiItems.hashCode),
            bangumiContent.hashCode),
        isFromMutedUser.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('StatusUpdateMultiple')
          ..add('user', user)
          ..add('hyperImages', hyperImages)
          ..add('hyperBangumiItems', hyperBangumiItems)
          ..add('bangumiContent', bangumiContent)
          ..add('isFromMutedUser', isFromMutedUser))
        .toString();
  }
}

class StatusUpdateMultipleBuilder
    implements
        Builder<StatusUpdateMultiple, StatusUpdateMultipleBuilder>,
        TimelineFeedBuilder {
  _$StatusUpdateMultiple _$v;

  FeedMetaInfoBuilder _user;
  FeedMetaInfoBuilder get user => _$this._user ??= new FeedMetaInfoBuilder();
  set user(FeedMetaInfoBuilder user) => _$this._user = user;

  ListBuilder<HyperImage> _hyperImages;
  ListBuilder<HyperImage> get hyperImages =>
      _$this._hyperImages ??= new ListBuilder<HyperImage>();
  set hyperImages(ListBuilder<HyperImage> hyperImages) =>
      _$this._hyperImages = hyperImages;

  ListBuilder<HyperBangumiItem> _hyperBangumiItems;
  ListBuilder<HyperBangumiItem> get hyperBangumiItems =>
      _$this._hyperBangumiItems ??= new ListBuilder<HyperBangumiItem>();
  set hyperBangumiItems(ListBuilder<HyperBangumiItem> hyperBangumiItems) =>
      _$this._hyperBangumiItems = hyperBangumiItems;

  BangumiContent _bangumiContent;
  BangumiContent get bangumiContent => _$this._bangumiContent;
  set bangumiContent(BangumiContent bangumiContent) =>
      _$this._bangumiContent = bangumiContent;

  bool _isFromMutedUser;
  bool get isFromMutedUser => _$this._isFromMutedUser;
  set isFromMutedUser(bool isFromMutedUser) =>
      _$this._isFromMutedUser = isFromMutedUser;

  StatusUpdateMultipleBuilder();

  StatusUpdateMultipleBuilder get _$this {
    if (_$v != null) {
      _user = _$v.user?.toBuilder();
      _hyperImages = _$v.hyperImages?.toBuilder();
      _hyperBangumiItems = _$v.hyperBangumiItems?.toBuilder();
      _bangumiContent = _$v.bangumiContent;
      _isFromMutedUser = _$v.isFromMutedUser;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant StatusUpdateMultiple other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$StatusUpdateMultiple;
  }

  @override
  void update(void Function(StatusUpdateMultipleBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$StatusUpdateMultiple build() {
    _$StatusUpdateMultiple _$result;
    try {
      _$result = _$v ??
          new _$StatusUpdateMultiple._(
              user: user.build(),
              hyperImages: hyperImages.build(),
              hyperBangumiItems: hyperBangumiItems.build(),
              bangumiContent: bangumiContent,
              isFromMutedUser: isFromMutedUser);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
        _$failedField = 'hyperImages';
        hyperImages.build();
        _$failedField = 'hyperBangumiItems';
        hyperBangumiItems.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'StatusUpdateMultiple', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
