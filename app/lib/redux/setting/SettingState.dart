import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:munin/models/bangumi/setting/ThemeSetting.dart';
import 'package:munin/shared/utils/serializers.dart';

part 'SettingState.g.dart';

abstract class SettingState
    implements Built<SettingState, SettingStateBuilder> {
  ThemeSetting get themeSetting;

  factory SettingState([updates(SettingStateBuilder b)]) =>
      _$SettingState((b) => b
        ..themeSetting.replace(ThemeSetting())
        ..update(updates));

  SettingState._();

  String toJson() {
    return json
        .encode(serializers.serializeWith(SettingState.serializer, this));
  }

  static SettingState fromJson(String jsonString) {
    return serializers.deserializeWith(
        SettingState.serializer, json.decode(jsonString));
  }

  static Serializer<SettingState> get serializer => _$settingStateSerializer;
}