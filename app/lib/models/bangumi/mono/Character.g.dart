// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Character.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Character> _$characterSerializer = new _$CharacterSerializer();

class _$CharacterSerializer implements StructuredSerializer<Character> {
  @override
  final Iterable<Type> types = const [Character, _$Character];
  @override
  final String wireName = 'Character';

  @override
  Iterable<Object> serialize(Serializers serializers, Character object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'role_name',
      serializers.serialize(object.roleName,
          specifiedType: const FullType(String)),
      'avatar',
      serializers.serialize(object.avatar,
          specifiedType: const FullType(BangumiImage)),
      'actors',
      serializers.serialize(object.actors,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Actor)])),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];
    if (object.chineseName != null) {
      result
        ..add('name_cn')
        ..add(serializers.serialize(object.chineseName,
            specifiedType: const FullType(String)));
    }
    if (object.commentCount != null) {
      result
        ..add('comment')
        ..add(serializers.serialize(object.commentCount,
            specifiedType: const FullType(int)));
    }
    if (object.collectionCounts != null) {
      result
        ..add('collects')
        ..add(serializers.serialize(object.collectionCounts,
            specifiedType: const FullType(int)));
    }
    if (object.pageUrl != null) {
      result
        ..add('url')
        ..add(serializers.serialize(object.pageUrl,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Character deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CharacterBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'name_cn':
          result.chineseName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'role_name':
          result.roleName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'avatar':
          result.avatar.replace(serializers.deserialize(value,
              specifiedType: const FullType(BangumiImage)) as BangumiImage);
          break;
        case 'comment':
          result.commentCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'collects':
          result.collectionCounts = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'actors':
          result.actors.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(Actor)]))
              as BuiltList<dynamic>);
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'url':
          result.pageUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Character extends Character {
  @override
  final String chineseName;
  @override
  final String roleName;
  @override
  final BangumiImage avatar;
  @override
  final int commentCount;
  @override
  final int collectionCounts;
  @override
  final BuiltList<Actor> actors;
  @override
  final int id;
  @override
  final String pageUrl;
  @override
  final String name;

  factory _$Character([void Function(CharacterBuilder) updates]) =>
      (new CharacterBuilder()..update(updates)).build();

  _$Character._(
      {this.chineseName,
      this.roleName,
      this.avatar,
      this.commentCount,
      this.collectionCounts,
      this.actors,
      this.id,
      this.pageUrl,
      this.name})
      : super._() {
    if (roleName == null) {
      throw new BuiltValueNullFieldError('Character', 'roleName');
    }
    if (avatar == null) {
      throw new BuiltValueNullFieldError('Character', 'avatar');
    }
    if (actors == null) {
      throw new BuiltValueNullFieldError('Character', 'actors');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('Character', 'id');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('Character', 'name');
    }
  }

  @override
  Character rebuild(void Function(CharacterBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CharacterBuilder toBuilder() => new CharacterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Character &&
        chineseName == other.chineseName &&
        roleName == other.roleName &&
        avatar == other.avatar &&
        commentCount == other.commentCount &&
        collectionCounts == other.collectionCounts &&
        actors == other.actors &&
        id == other.id &&
        pageUrl == other.pageUrl &&
        name == other.name;
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
                                $jc($jc(0, chineseName.hashCode),
                                    roleName.hashCode),
                                avatar.hashCode),
                            commentCount.hashCode),
                        collectionCounts.hashCode),
                    actors.hashCode),
                id.hashCode),
            pageUrl.hashCode),
        name.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Character')
          ..add('chineseName', chineseName)
          ..add('roleName', roleName)
          ..add('avatar', avatar)
          ..add('commentCount', commentCount)
          ..add('collectionCounts', collectionCounts)
          ..add('actors', actors)
          ..add('id', id)
          ..add('pageUrl', pageUrl)
          ..add('name', name))
        .toString();
  }
}

class CharacterBuilder
    implements Builder<Character, CharacterBuilder>, MonoBaseBuilder {
  _$Character _$v;

  String _chineseName;
  String get chineseName => _$this._chineseName;
  set chineseName(String chineseName) => _$this._chineseName = chineseName;

  String _roleName;
  String get roleName => _$this._roleName;
  set roleName(String roleName) => _$this._roleName = roleName;

  BangumiImageBuilder _avatar;
  BangumiImageBuilder get avatar =>
      _$this._avatar ??= new BangumiImageBuilder();
  set avatar(BangumiImageBuilder avatar) => _$this._avatar = avatar;

  int _commentCount;
  int get commentCount => _$this._commentCount;
  set commentCount(int commentCount) => _$this._commentCount = commentCount;

  int _collectionCounts;
  int get collectionCounts => _$this._collectionCounts;
  set collectionCounts(int collectionCounts) =>
      _$this._collectionCounts = collectionCounts;

  ListBuilder<Actor> _actors;
  ListBuilder<Actor> get actors => _$this._actors ??= new ListBuilder<Actor>();
  set actors(ListBuilder<Actor> actors) => _$this._actors = actors;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _pageUrl;
  String get pageUrl => _$this._pageUrl;
  set pageUrl(String pageUrl) => _$this._pageUrl = pageUrl;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  CharacterBuilder();

  CharacterBuilder get _$this {
    if (_$v != null) {
      _chineseName = _$v.chineseName;
      _roleName = _$v.roleName;
      _avatar = _$v.avatar?.toBuilder();
      _commentCount = _$v.commentCount;
      _collectionCounts = _$v.collectionCounts;
      _actors = _$v.actors?.toBuilder();
      _id = _$v.id;
      _pageUrl = _$v.pageUrl;
      _name = _$v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Character other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Character;
  }

  @override
  void update(void Function(CharacterBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Character build() {
    _$Character _$result;
    try {
      _$result = _$v ??
          new _$Character._(
              chineseName: chineseName,
              roleName: roleName,
              avatar: avatar.build(),
              commentCount: commentCount,
              collectionCounts: collectionCounts,
              actors: actors.build(),
              id: id,
              pageUrl: pageUrl,
              name: name);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'avatar';
        avatar.build();

        _$failedField = 'actors';
        actors.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Character', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
