// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HyperImage.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<HyperImage> _$hyperImageSerializer = new _$HyperImageSerializer();

class _$HyperImageSerializer implements StructuredSerializer<HyperImage> {
  @override
  final Iterable<Type> types = const [HyperImage, _$HyperImage];
  @override
  final String wireName = 'HyperImage';

  @override
  Iterable<Object> serialize(Serializers serializers, HyperImage object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'contentType',
      serializers.serialize(object.contentType,
          specifiedType: const FullType(BangumiContent)),
      'image',
      serializers.serialize(object.image,
          specifiedType: const FullType(BangumiImage)),
    ];
    if (object.pageUrl != null) {
      result
        ..add('pageUrl')
        ..add(serializers.serialize(object.pageUrl,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  HyperImage deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new HyperImageBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'contentType':
          result.contentType = serializers.deserialize(value,
              specifiedType: const FullType(BangumiContent)) as BangumiContent;
          break;
        case 'image':
          result.image.replace(serializers.deserialize(value,
              specifiedType: const FullType(BangumiImage)) as BangumiImage);
          break;
        case 'pageUrl':
          result.pageUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$HyperImage extends HyperImage {
  @override
  final String id;
  @override
  final BangumiContent contentType;
  @override
  final BangumiImage image;
  @override
  final String pageUrl;

  factory _$HyperImage([void Function(HyperImageBuilder) updates]) =>
      (new HyperImageBuilder()..update(updates)).build();

  _$HyperImage._({this.id, this.contentType, this.image, this.pageUrl})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('HyperImage', 'id');
    }
    if (contentType == null) {
      throw new BuiltValueNullFieldError('HyperImage', 'contentType');
    }
    if (image == null) {
      throw new BuiltValueNullFieldError('HyperImage', 'image');
    }
  }

  @override
  HyperImage rebuild(void Function(HyperImageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HyperImageBuilder toBuilder() => new HyperImageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HyperImage &&
        id == other.id &&
        contentType == other.contentType &&
        image == other.image &&
        pageUrl == other.pageUrl;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, id.hashCode), contentType.hashCode), image.hashCode),
        pageUrl.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('HyperImage')
          ..add('id', id)
          ..add('contentType', contentType)
          ..add('image', image)
          ..add('pageUrl', pageUrl))
        .toString();
  }
}

class HyperImageBuilder implements Builder<HyperImage, HyperImageBuilder> {
  _$HyperImage _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  BangumiContent _contentType;
  BangumiContent get contentType => _$this._contentType;
  set contentType(BangumiContent contentType) =>
      _$this._contentType = contentType;

  BangumiImageBuilder _image;
  BangumiImageBuilder get image => _$this._image ??= new BangumiImageBuilder();
  set image(BangumiImageBuilder image) => _$this._image = image;

  String _pageUrl;
  String get pageUrl => _$this._pageUrl;
  set pageUrl(String pageUrl) => _$this._pageUrl = pageUrl;

  HyperImageBuilder();

  HyperImageBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _contentType = _$v.contentType;
      _image = _$v.image?.toBuilder();
      _pageUrl = _$v.pageUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HyperImage other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$HyperImage;
  }

  @override
  void update(void Function(HyperImageBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$HyperImage build() {
    _$HyperImage _$result;
    try {
      _$result = _$v ??
          new _$HyperImage._(
              id: id,
              contentType: contentType,
              image: image.build(),
              pageUrl: pageUrl);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'image';
        image.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'HyperImage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
