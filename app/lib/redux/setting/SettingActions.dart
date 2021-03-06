import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:munin/models/bangumi/setting/general/GeneralSetting.dart';
import 'package:munin/models/bangumi/setting/mute/MuteSetting.dart';
import 'package:munin/models/bangumi/setting/mute/MutedGroup.dart';
import 'package:munin/models/bangumi/setting/mute/MutedUser.dart';
import 'package:munin/models/bangumi/setting/privacy/PrivacySetting.dart';
import 'package:munin/models/bangumi/setting/theme/ThemeSetting.dart';
import 'package:munin/models/bangumi/setting/version/MuninVersionInfo.dart';

/// Updates general settings.
class UpdateGeneralSettingAction {
  final GeneralSetting generalSetting;

  UpdateGeneralSettingAction({@required this.generalSetting});
}

/// Updates theme settings.
class UpdateThemeSettingAction {
  final ThemeSetting themeSetting;

  /// Whether theme setting should be persisted to disk after updating
  /// default to false
  final bool persistToDisk;

  UpdateThemeSettingAction(
      {@required this.themeSetting, this.persistToDisk = false});
}

/// Updates mute settings.
class UpdateMuteSettingAction {
  final MuteSetting muteSetting;

  UpdateMuteSettingAction({@required this.muteSetting});
}

class MuteUserAction {
  final MutedUser mutedUser;

  MuteUserAction({@required this.mutedUser});
}

class UnmuteUserAction {
  final MutedUser mutedUser;

  UnmuteUserAction({@required this.mutedUser});
}

class MuteGroupAction {
  final MutedGroup mutedGroup;

  MuteGroupAction({@required this.mutedGroup});
}

class UnmuteGroupAction {
  final String groupId;

  UnmuteGroupAction({@required this.groupId});
}

class ImportBlockedBangumiUsersRequestAction {}

/// Successfully fetched list of blocked users on bangumi
class ImportBlockedBangumiUsersResponseSuccessAction {
  final BuiltMap<String, MutedUser> users;

  ImportBlockedBangumiUsersResponseSuccessAction({@required this.users});
}

class ImportBlockedBangumiUsersConfirmAction {}

class ImportBlockedBangumiUsersCleanupAction {}

/// Update privacy settings.
class UpdatePrivacySettingAction {
  final PrivacySetting privacySetting;

  UpdatePrivacySettingAction({@required this.privacySetting});
}

class GetLatestMuninVersionRequestAction {
  final BuildContext context;
  final Completer completer;

  GetLatestMuninVersionRequestAction({
    @required this.context,
    Completer completer,
  }) : this.completer = completer ?? Completer();
}

/// Successfully fetched list of blocked users on bangumi
class GetLatestMuninVersionSuccessAction {
  final MuninVersionInfo muninVersionInfo;

  GetLatestMuninVersionSuccessAction({@required this.muninVersionInfo});
}
