import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {

  /// Loads the User's preferred ThemeMode from local or remote storage.

  Future<ThemeMode> themeMode() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final themeModeArr = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];
    // final modeInt = prefs.getInt("themeMode");
    // return themeModeArr[modeInt];
    return ThemeMode.system;
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {

    var themeModeToInt = {
      ThemeMode.system: 0,
      ThemeMode.light: 1,
      ThemeMode.dark: 2,
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("themeMode", themeModeToInt[theme]!);
    // http package to persist settings over the network.
  }

  Future<bool> assetHidden() async => false;

  Future<void> updateAssetHidden(bool assetHidden) async {}
}
