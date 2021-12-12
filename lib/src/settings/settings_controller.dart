import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService;

  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Dot not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new theme mode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateThemeMode(newThemeMode);
  }

  late bool _assetHidden;

  bool get assetHidden => _assetHidden;

  Future<void> updateAssetHidden(bool? newAssetHidden) async {
    if (newAssetHidden == null) return;

    if (newAssetHidden == _assetHidden) return;

    _assetHidden = newAssetHidden;

    notifyListeners();

    await _settingsService.updateAssetHidden(newAssetHidden);
  }

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _assetHidden = await _settingsService.assetHidden();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

}
