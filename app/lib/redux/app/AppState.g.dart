// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppState.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AppState> _$appStateSerializer = new _$AppStateSerializer();

class _$AppStateSerializer implements StructuredSerializer<AppState> {
  @override
  final Iterable<Type> types = const [AppState, _$AppState];
  @override
  final String wireName = 'AppState';

  @override
  Iterable<Object> serialize(Serializers serializers, AppState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'isAuthenticated',
      serializers.serialize(object.isAuthenticated,
          specifiedType: const FullType(bool)),
      'oauthState',
      serializers.serialize(object.oauthState,
          specifiedType: const FullType(OauthState)),
      'timelineState',
      serializers.serialize(object.timelineState,
          specifiedType: const FullType(TimelineState)),
      'subjectState',
      serializers.serialize(object.subjectState,
          specifiedType: const FullType(SubjectState)),
      'searchState',
      serializers.serialize(object.searchState,
          specifiedType: const FullType(SearchState)),
      'discussionState',
      serializers.serialize(object.discussionState,
          specifiedType: const FullType(DiscussionState)),
      'userState',
      serializers.serialize(object.userState,
          specifiedType: const FullType(UserState)),
      'progressState',
      serializers.serialize(object.progressState,
          specifiedType: const FullType(ProgressState)),
      'settingState',
      serializers.serialize(object.settingState,
          specifiedType: const FullType(SettingState)),
    ];
    if (object.currentAuthenticatedUserBasicInfo != null) {
      result
        ..add('currentAuthenticatedUserBasicInfo')
        ..add(serializers.serialize(object.currentAuthenticatedUserBasicInfo,
            specifiedType: const FullType(BangumiUserSmall)));
    }
    return result;
  }

  @override
  AppState deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AppStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'currentAuthenticatedUserBasicInfo':
          result.currentAuthenticatedUserBasicInfo.replace(
              serializers.deserialize(value,
                      specifiedType: const FullType(BangumiUserSmall))
                  as BangumiUserSmall);
          break;
        case 'isAuthenticated':
          result.isAuthenticated = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'oauthState':
          result.oauthState.replace(serializers.deserialize(value,
              specifiedType: const FullType(OauthState)) as OauthState);
          break;
        case 'timelineState':
          result.timelineState.replace(serializers.deserialize(value,
              specifiedType: const FullType(TimelineState)) as TimelineState);
          break;
        case 'subjectState':
          result.subjectState.replace(serializers.deserialize(value,
              specifiedType: const FullType(SubjectState)) as SubjectState);
          break;
        case 'searchState':
          result.searchState.replace(serializers.deserialize(value,
              specifiedType: const FullType(SearchState)) as SearchState);
          break;
        case 'discussionState':
          result.discussionState.replace(serializers.deserialize(value,
                  specifiedType: const FullType(DiscussionState))
              as DiscussionState);
          break;
        case 'userState':
          result.userState.replace(serializers.deserialize(value,
              specifiedType: const FullType(UserState)) as UserState);
          break;
        case 'progressState':
          result.progressState.replace(serializers.deserialize(value,
              specifiedType: const FullType(ProgressState)) as ProgressState);
          break;
        case 'settingState':
          result.settingState.replace(serializers.deserialize(value,
              specifiedType: const FullType(SettingState)) as SettingState);
          break;
      }
    }

    return result.build();
  }
}

class _$AppState extends AppState {
  @override
  final BangumiUserSmall currentAuthenticatedUserBasicInfo;
  @override
  final bool isAuthenticated;
  @override
  final OauthState oauthState;
  @override
  final TimelineState timelineState;
  @override
  final SubjectState subjectState;
  @override
  final SearchState searchState;
  @override
  final DiscussionState discussionState;
  @override
  final UserState userState;
  @override
  final ProgressState progressState;
  @override
  final SettingState settingState;

  factory _$AppState([void Function(AppStateBuilder) updates]) =>
      (new AppStateBuilder()..update(updates)).build();

  _$AppState._(
      {this.currentAuthenticatedUserBasicInfo,
      this.isAuthenticated,
      this.oauthState,
      this.timelineState,
      this.subjectState,
      this.searchState,
      this.discussionState,
      this.userState,
      this.progressState,
      this.settingState})
      : super._() {
    if (isAuthenticated == null) {
      throw new BuiltValueNullFieldError('AppState', 'isAuthenticated');
    }
    if (oauthState == null) {
      throw new BuiltValueNullFieldError('AppState', 'oauthState');
    }
    if (timelineState == null) {
      throw new BuiltValueNullFieldError('AppState', 'timelineState');
    }
    if (subjectState == null) {
      throw new BuiltValueNullFieldError('AppState', 'subjectState');
    }
    if (searchState == null) {
      throw new BuiltValueNullFieldError('AppState', 'searchState');
    }
    if (discussionState == null) {
      throw new BuiltValueNullFieldError('AppState', 'discussionState');
    }
    if (userState == null) {
      throw new BuiltValueNullFieldError('AppState', 'userState');
    }
    if (progressState == null) {
      throw new BuiltValueNullFieldError('AppState', 'progressState');
    }
    if (settingState == null) {
      throw new BuiltValueNullFieldError('AppState', 'settingState');
    }
  }

  @override
  AppState rebuild(void Function(AppStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppStateBuilder toBuilder() => new AppStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppState &&
        currentAuthenticatedUserBasicInfo ==
            other.currentAuthenticatedUserBasicInfo &&
        isAuthenticated == other.isAuthenticated &&
        oauthState == other.oauthState &&
        timelineState == other.timelineState &&
        subjectState == other.subjectState &&
        searchState == other.searchState &&
        discussionState == other.discussionState &&
        userState == other.userState &&
        progressState == other.progressState &&
        settingState == other.settingState;
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
                                            0,
                                            currentAuthenticatedUserBasicInfo
                                                .hashCode),
                                        isAuthenticated.hashCode),
                                    oauthState.hashCode),
                                timelineState.hashCode),
                            subjectState.hashCode),
                        searchState.hashCode),
                    discussionState.hashCode),
                userState.hashCode),
            progressState.hashCode),
        settingState.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AppState')
          ..add('currentAuthenticatedUserBasicInfo',
              currentAuthenticatedUserBasicInfo)
          ..add('isAuthenticated', isAuthenticated)
          ..add('oauthState', oauthState)
          ..add('timelineState', timelineState)
          ..add('subjectState', subjectState)
          ..add('searchState', searchState)
          ..add('discussionState', discussionState)
          ..add('userState', userState)
          ..add('progressState', progressState)
          ..add('settingState', settingState))
        .toString();
  }
}

class AppStateBuilder implements Builder<AppState, AppStateBuilder> {
  _$AppState _$v;

  BangumiUserSmallBuilder _currentAuthenticatedUserBasicInfo;
  BangumiUserSmallBuilder get currentAuthenticatedUserBasicInfo =>
      _$this._currentAuthenticatedUserBasicInfo ??=
          new BangumiUserSmallBuilder();
  set currentAuthenticatedUserBasicInfo(
          BangumiUserSmallBuilder currentAuthenticatedUserBasicInfo) =>
      _$this._currentAuthenticatedUserBasicInfo =
          currentAuthenticatedUserBasicInfo;

  bool _isAuthenticated;
  bool get isAuthenticated => _$this._isAuthenticated;
  set isAuthenticated(bool isAuthenticated) =>
      _$this._isAuthenticated = isAuthenticated;

  OauthStateBuilder _oauthState;
  OauthStateBuilder get oauthState =>
      _$this._oauthState ??= new OauthStateBuilder();
  set oauthState(OauthStateBuilder oauthState) =>
      _$this._oauthState = oauthState;

  TimelineStateBuilder _timelineState;
  TimelineStateBuilder get timelineState =>
      _$this._timelineState ??= new TimelineStateBuilder();
  set timelineState(TimelineStateBuilder timelineState) =>
      _$this._timelineState = timelineState;

  SubjectStateBuilder _subjectState;
  SubjectStateBuilder get subjectState =>
      _$this._subjectState ??= new SubjectStateBuilder();
  set subjectState(SubjectStateBuilder subjectState) =>
      _$this._subjectState = subjectState;

  SearchStateBuilder _searchState;
  SearchStateBuilder get searchState =>
      _$this._searchState ??= new SearchStateBuilder();
  set searchState(SearchStateBuilder searchState) =>
      _$this._searchState = searchState;

  DiscussionStateBuilder _discussionState;
  DiscussionStateBuilder get discussionState =>
      _$this._discussionState ??= new DiscussionStateBuilder();
  set discussionState(DiscussionStateBuilder discussionState) =>
      _$this._discussionState = discussionState;

  UserStateBuilder _userState;
  UserStateBuilder get userState =>
      _$this._userState ??= new UserStateBuilder();
  set userState(UserStateBuilder userState) => _$this._userState = userState;

  ProgressStateBuilder _progressState;
  ProgressStateBuilder get progressState =>
      _$this._progressState ??= new ProgressStateBuilder();
  set progressState(ProgressStateBuilder progressState) =>
      _$this._progressState = progressState;

  SettingStateBuilder _settingState;
  SettingStateBuilder get settingState =>
      _$this._settingState ??= new SettingStateBuilder();
  set settingState(SettingStateBuilder settingState) =>
      _$this._settingState = settingState;

  AppStateBuilder();

  AppStateBuilder get _$this {
    if (_$v != null) {
      _currentAuthenticatedUserBasicInfo =
          _$v.currentAuthenticatedUserBasicInfo?.toBuilder();
      _isAuthenticated = _$v.isAuthenticated;
      _oauthState = _$v.oauthState?.toBuilder();
      _timelineState = _$v.timelineState?.toBuilder();
      _subjectState = _$v.subjectState?.toBuilder();
      _searchState = _$v.searchState?.toBuilder();
      _discussionState = _$v.discussionState?.toBuilder();
      _userState = _$v.userState?.toBuilder();
      _progressState = _$v.progressState?.toBuilder();
      _settingState = _$v.settingState?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AppState;
  }

  @override
  void update(void Function(AppStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AppState build() {
    _$AppState _$result;
    try {
      _$result = _$v ??
          new _$AppState._(
              currentAuthenticatedUserBasicInfo:
                  _currentAuthenticatedUserBasicInfo?.build(),
              isAuthenticated: isAuthenticated,
              oauthState: oauthState.build(),
              timelineState: timelineState.build(),
              subjectState: subjectState.build(),
              searchState: searchState.build(),
              discussionState: discussionState.build(),
              userState: userState.build(),
              progressState: progressState.build(),
              settingState: settingState.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'currentAuthenticatedUserBasicInfo';
        _currentAuthenticatedUserBasicInfo?.build();

        _$failedField = 'oauthState';
        oauthState.build();
        _$failedField = 'timelineState';
        timelineState.build();
        _$failedField = 'subjectState';
        subjectState.build();
        _$failedField = 'searchState';
        searchState.build();
        _$failedField = 'discussionState';
        discussionState.build();
        _$failedField = 'userState';
        userState.build();
        _$failedField = 'progressState';
        progressState.build();
        _$failedField = 'settingState';
        settingState.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'AppState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
