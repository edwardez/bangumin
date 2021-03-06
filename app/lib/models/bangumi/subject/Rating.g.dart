// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Rating.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Rating> _$ratingSerializer = new _$RatingSerializer();

class _$RatingSerializer implements StructuredSerializer<Rating> {
  @override
  final Iterable<Type> types = const [Rating, _$Rating];
  @override
  final String wireName = 'Rating';

  @override
  Iterable<Object> serialize(Serializers serializers, Rating object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'total',
      serializers.serialize(object.totalScoreVotesCount,
          specifiedType: const FullType(int)),
      'count',
      serializers.serialize(object.count, specifiedType: const FullType(Count)),
      'score',
      serializers.serialize(object.score,
          specifiedType: const FullType(double)),
    ];
    if (object.friendScoreVotesCount != null) {
      result
        ..add('friendScoreVotesCount')
        ..add(serializers.serialize(object.friendScoreVotesCount,
            specifiedType: const FullType(int)));
    }
    if (object.friendScore != null) {
      result
        ..add('friendScore')
        ..add(serializers.serialize(object.friendScore,
            specifiedType: const FullType(double)));
    }
    return result;
  }

  @override
  Rating deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RatingBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'total':
          result.totalScoreVotesCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'count':
          result.count.replace(serializers.deserialize(value,
              specifiedType: const FullType(Count)) as Count);
          break;
        case 'score':
          result.score = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'friendScoreVotesCount':
          result.friendScoreVotesCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'friendScore':
          result.friendScore = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
      }
    }

    return result.build();
  }
}

class _$Rating extends Rating {
  @override
  final int totalScoreVotesCount;
  @override
  final Count count;
  @override
  final double score;
  @override
  final int friendScoreVotesCount;
  @override
  final double friendScore;

  factory _$Rating([void Function(RatingBuilder) updates]) =>
      (new RatingBuilder()..update(updates)).build();

  _$Rating._(
      {this.totalScoreVotesCount,
      this.count,
      this.score,
      this.friendScoreVotesCount,
      this.friendScore})
      : super._() {
    if (totalScoreVotesCount == null) {
      throw new BuiltValueNullFieldError('Rating', 'totalScoreVotesCount');
    }
    if (count == null) {
      throw new BuiltValueNullFieldError('Rating', 'count');
    }
    if (score == null) {
      throw new BuiltValueNullFieldError('Rating', 'score');
    }
  }

  @override
  Rating rebuild(void Function(RatingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RatingBuilder toBuilder() => new RatingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Rating &&
        totalScoreVotesCount == other.totalScoreVotesCount &&
        count == other.count &&
        score == other.score &&
        friendScoreVotesCount == other.friendScoreVotesCount &&
        friendScore == other.friendScore;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, totalScoreVotesCount.hashCode), count.hashCode),
                score.hashCode),
            friendScoreVotesCount.hashCode),
        friendScore.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Rating')
          ..add('totalScoreVotesCount', totalScoreVotesCount)
          ..add('count', count)
          ..add('score', score)
          ..add('friendScoreVotesCount', friendScoreVotesCount)
          ..add('friendScore', friendScore))
        .toString();
  }
}

class RatingBuilder implements Builder<Rating, RatingBuilder> {
  _$Rating _$v;

  int _totalScoreVotesCount;
  int get totalScoreVotesCount => _$this._totalScoreVotesCount;
  set totalScoreVotesCount(int totalScoreVotesCount) =>
      _$this._totalScoreVotesCount = totalScoreVotesCount;

  CountBuilder _count;
  CountBuilder get count => _$this._count ??= new CountBuilder();
  set count(CountBuilder count) => _$this._count = count;

  double _score;
  double get score => _$this._score;
  set score(double score) => _$this._score = score;

  int _friendScoreVotesCount;
  int get friendScoreVotesCount => _$this._friendScoreVotesCount;
  set friendScoreVotesCount(int friendScoreVotesCount) =>
      _$this._friendScoreVotesCount = friendScoreVotesCount;

  double _friendScore;
  double get friendScore => _$this._friendScore;
  set friendScore(double friendScore) => _$this._friendScore = friendScore;

  RatingBuilder();

  RatingBuilder get _$this {
    if (_$v != null) {
      _totalScoreVotesCount = _$v.totalScoreVotesCount;
      _count = _$v.count?.toBuilder();
      _score = _$v.score;
      _friendScoreVotesCount = _$v.friendScoreVotesCount;
      _friendScore = _$v.friendScore;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Rating other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Rating;
  }

  @override
  void update(void Function(RatingBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Rating build() {
    _$Rating _$result;
    try {
      _$result = _$v ??
          new _$Rating._(
              totalScoreVotesCount: totalScoreVotesCount,
              count: count.build(),
              score: score,
              friendScoreVotesCount: friendScoreVotesCount,
              friendScore: friendScore);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'count';
        count.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Rating', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
