import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:munin/models/bangumi/BangumiUserSmall.dart';
import 'package:munin/redux/discussion/DiscussionState.dart';
import 'package:munin/redux/oauth/OauthState.dart';
import 'package:munin/redux/progress/ProgressState.dart';
import 'package:munin/redux/search/SearchState.dart';
import 'package:munin/redux/setting/SettingState.dart';
import 'package:munin/redux/subject/SubjectState.dart';
import 'package:munin/redux/timeline/TimelineState.dart';
import 'package:munin/redux/user/UserState.dart';
import 'package:munin/shared/utils/serializers.dart';

part 'AppState.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  @nullable
  BangumiUserSmall get currentAuthenticatedUserBasicInfo;

  bool get isAuthenticated;

  OauthState get oauthState;

  TimelineState get timelineState;

  SubjectState get subjectState;

  SearchState get searchState;

  DiscussionState get discussionState;

  UserState get userState;

  ProgressState get progressState;

  SettingState get settingState;

  factory AppState([updates(AppStateBuilder b)]) => _$AppState((b) => b
    ..isAuthenticated = false
    ..oauthState.replace(OauthState())
    ..timelineState.replace(TimelineState())
    ..subjectState.replace(SubjectState())
    ..searchState.replace(SearchState())
    ..discussionState.replace(DiscussionState())
    ..userState.replace(UserState())
    ..progressState.replace(ProgressState())
    ..settingState.replace(SettingState())
    ..update(updates));

  AppState._();

  String toJson() {
    return json.encode(serializers.serializeWith(AppState.serializer, this));
  }

  static AppState fromJson(String jsonString) {
    return serializers.deserializeWith(
        AppState.serializer, json.decode(jsonString));
  }

  static Serializer<AppState> get serializer => _$appStateSerializer;
}
