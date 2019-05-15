import 'package:flutter/foundation.dart';
import 'package:munin/models/bangumi/setting/ThemeSetting.dart';
import 'package:munin/models/bangumi/setting/ThemeSwitchMode.dart';
import 'package:munin/redux/app/AppActions.dart';
import 'package:munin/redux/app/AppState.dart';
import 'package:munin/redux/setting/Common.dart';
import 'package:munin/redux/setting/SettingActions.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:screen/screen.dart';

const Duration listenToBrightnessChangeInterval = const Duration(seconds: 2);

List<Epic<AppState>> createSettingEpics() {
  final changeThemeByScreenBrightnessEpic =
      _createChangeThemeByScreenBrightnessEpic();

  final updateThemeSettingEpic = _createUpdateThemeSettingEpic();

  return [changeThemeByScreenBrightnessEpic, updateThemeSettingEpic];
}

/// Note: [Screen.brightness] returns value between 0 and 1 so we need to manually
/// convert it to 0~100 scale
Stream<dynamic> _changeThemeByScreenBrightness(
  UpdateThemeSettingAction action,
) async* {
  ThemeSetting themeSetting = action.themeSetting;

  bool shouldChangeToDarkTheme(int roundedDeviceBrightness) {
    return roundedDeviceBrightness <=
            themeSetting.preferredFollowBrightnessSwitchThreshold &&
        themeSetting.currentTheme !=
            action.themeSetting.preferredFollowBrightnessDarkTheme;
  }

  bool shouldChangeToLightTheme(int currentDeviceBrightness) {
    return currentDeviceBrightness >
            themeSetting.preferredFollowBrightnessSwitchThreshold &&
        themeSetting.currentTheme !=
            action.themeSetting.preferredFollowBrightnessLightTheme;
  }

  try {
    if (themeSetting.themeSwitchMode ==
        ThemeSwitchMode.FollowScreenBrightness) {
      int roundedDeviceBrightness =
          roundDeviceBrightnessToPercentage(await Screen.brightness);
      if (shouldChangeToDarkTheme(roundedDeviceBrightness)) {
        yield UpdateThemeSettingAction(
            themeSetting: themeSetting.rebuild(
                (b) => b..currentTheme = b.preferredFollowBrightnessDarkTheme));
      } else if (shouldChangeToLightTheme(roundedDeviceBrightness)) {
        yield UpdateThemeSettingAction(
            themeSetting: themeSetting.rebuild((b) =>
                b..currentTheme = b.preferredFollowBrightnessLightTheme));
      }
    }
  } catch (error, stack) {
    debugPrint(
        'Error occurred during listening to theme change ${error.toString()}');
    debugPrint(stack.toString());
  }
}

/// Starts or aborts listening to screen brightness depends on user settings
/// We don't need to manually unsubscribe to stream here since `switchMap` handles
/// it
Epic<AppState> _createChangeThemeByScreenBrightnessEpic() {
  return (Stream<dynamic> actions, EpicStore<AppState> store) {
    return Observable(actions)
        .ofType(TypeToken<UpdateThemeSettingAction>())
        .switchMap<UpdateThemeSettingAction>((action) {
      if (action.themeSetting.themeSwitchMode ==
          ThemeSwitchMode.FollowScreenBrightness) {
        /// If theme mode has changed to [ThemeSwitchMode.FollowScreenBrightness]
        /// Start endlessly listening to screen brightness
        /// A special `Observable.just` with same action is attached to the stream
        /// since `Observable.periodic` starts emitting values only after first
        /// `listenToBrightnessChangeInterval` is ended and user expects to see
        /// changes immediately after they modified relevant `themeSetting` values
        return Observable.concat([
          Observable.just(action),
          Observable.periodic(listenToBrightnessChangeInterval, (i) => action)
        ]);
      } else {
        /// Otherwise, just emit a empty value to abort the stream
        return Observable.empty();
      }
    }).switchMap((action) => _changeThemeByScreenBrightness(action));
  };
}

Stream<dynamic> _updateThemeSetting(
  UpdateThemeSettingAction action,
) async* {
  try {
    /// New theme must be either light or dark theme
    assert(action.themeSetting.currentTheme.isLightTheme ||
        action.themeSetting.currentTheme.isDarkTheme);
    if (action.persistToDisk) {
      yield PersistAppStateAction();
    }
  } catch (error, stack) {
    print(error.toString());
    print(stack);
  }
}

Epic<AppState> _createUpdateThemeSettingEpic() {
  return (Stream<dynamic> actions, EpicStore<AppState> store) {
    return Observable(actions)
        .ofType(TypeToken<UpdateThemeSettingAction>())
        .switchMap((action) => _updateThemeSetting(action));
  };
}