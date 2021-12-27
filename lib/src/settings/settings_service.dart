import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  static const themeModeKey = "themeMode";
  static const themeModeArr = [
    ThemeMode.system,
    ThemeMode.light,
    ThemeMode.dark
  ];

  Future<ThemeMode> themeMode() async {
    var prefs = await SharedPreferences.getInstance();
    var modeInt = prefs.getInt(themeModeKey) ?? 0;
    return themeModeArr[modeInt];
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    var themeModeToInt = {
      ThemeMode.system: 0,
      ThemeMode.light: 1,
      ThemeMode.dark: 2,
    };

    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeModeKey, themeModeToInt[theme]!);
  }

  static const assetHiddenKey = "assetHidden";

  Future<bool> assetHidden() async {
    var prefs = await SharedPreferences.getInstance();
    var assetHidden = prefs.getBool(assetHiddenKey) ?? false;

    return assetHidden;
  }

  Future<void> updateAssetHidden(bool assetHidden) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(assetHiddenKey, assetHidden);
  }

  static const budgetAmountKey = "budgetAmount";

  Future<int> budgetAmount() async {
    var prefs = await SharedPreferences.getInstance();
    var budgetAmountNum = prefs.getInt(budgetAmountKey) ?? 0;
    return budgetAmountNum;
  }

  Future<void> updateBudgetAmount(int budgetAmount) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(budgetAmountKey, budgetAmount);
  }

  static const budgetHiddenKey = "budgetHidden";

  Future<bool> budgetHidden() async {
    var prefs = await SharedPreferences.getInstance();
    var budgetHidden = prefs.getBool(budgetHiddenKey) ?? false;

    return budgetHidden;
  }

  Future<void> updateBudgetHidden(bool budgetHidden) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(budgetHiddenKey, budgetHidden);
  }
}
