// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TimelineState.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<TimelineState> _$timelineStateSerializer =
    new _$TimelineStateSerializer();

class _$TimelineStateSerializer implements StructuredSerializer<TimelineState> {
  @override
  final Iterable<Type> types = const [TimelineState, _$TimelineState];
  @override
  final String wireName = 'TimelineState';

  @override
  Iterable<Object> serialize(Serializers serializers, TimelineState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'timeline',
      serializers.serialize(object.timeline,
          specifiedType: const FullType(BuiltMap, const [
            const FullType(GetTimelineRequest),
            const FullType(FeedChunks)
          ])),
      'fullPublicMessages',
      serializers.serialize(object.fullPublicMessages,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(int), const FullType(FullPublicMessage)])),
    ];

    return result;
  }

  @override
  TimelineState deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TimelineStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'timeline':
          result.timeline.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(GetTimelineRequest),
                const FullType(FeedChunks)
              ])) as BuiltMap<dynamic, dynamic>);
          break;
        case 'fullPublicMessages':
          result.fullPublicMessages.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(int),
                const FullType(FullPublicMessage)
              ])) as BuiltMap<dynamic, dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$TimelineState extends TimelineState {
  @override
  final BuiltMap<GetTimelineRequest, FeedChunks> timeline;
  @override
  final BuiltMap<int, FullPublicMessage> fullPublicMessages;

  factory _$TimelineState([void Function(TimelineStateBuilder) updates]) =>
      (new TimelineStateBuilder()..update(updates)).build();

  _$TimelineState._({this.timeline, this.fullPublicMessages}) : super._() {
    if (timeline == null) {
      throw new BuiltValueNullFieldError('TimelineState', 'timeline');
    }
    if (fullPublicMessages == null) {
      throw new BuiltValueNullFieldError('TimelineState', 'fullPublicMessages');
    }
  }

  @override
  TimelineState rebuild(void Function(TimelineStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TimelineStateBuilder toBuilder() => new TimelineStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TimelineState &&
        timeline == other.timeline &&
        fullPublicMessages == other.fullPublicMessages;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, timeline.hashCode), fullPublicMessages.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TimelineState')
          ..add('timeline', timeline)
          ..add('fullPublicMessages', fullPublicMessages))
        .toString();
  }
}

class TimelineStateBuilder
    implements Builder<TimelineState, TimelineStateBuilder> {
  _$TimelineState _$v;

  MapBuilder<GetTimelineRequest, FeedChunks> _timeline;
  MapBuilder<GetTimelineRequest, FeedChunks> get timeline =>
      _$this._timeline ??= new MapBuilder<GetTimelineRequest, FeedChunks>();
  set timeline(MapBuilder<GetTimelineRequest, FeedChunks> timeline) =>
      _$this._timeline = timeline;

  MapBuilder<int, FullPublicMessage> _fullPublicMessages;
  MapBuilder<int, FullPublicMessage> get fullPublicMessages =>
      _$this._fullPublicMessages ??= new MapBuilder<int, FullPublicMessage>();
  set fullPublicMessages(
          MapBuilder<int, FullPublicMessage> fullPublicMessages) =>
      _$this._fullPublicMessages = fullPublicMessages;

  TimelineStateBuilder();

  TimelineStateBuilder get _$this {
    if (_$v != null) {
      _timeline = _$v.timeline?.toBuilder();
      _fullPublicMessages = _$v.fullPublicMessages?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TimelineState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$TimelineState;
  }

  @override
  void update(void Function(TimelineStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$TimelineState build() {
    _$TimelineState _$result;
    try {
      _$result = _$v ??
          new _$TimelineState._(
              timeline: timeline.build(),
              fullPublicMessages: fullPublicMessages.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'timeline';
        timeline.build();
        _$failedField = 'fullPublicMessages';
        fullPublicMessages.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'TimelineState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
