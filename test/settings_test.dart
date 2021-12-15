import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_goblin/src/settings/settings_controller.dart';
import 'package:golden_goblin/src/settings/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Settings Controller', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    group('themeMode', () {
      test('should be able to get themeMode', () async {
        var controller = SettingsController(SettingsService());
        await controller.loadSettings();

        expect(controller.themeMode, isA());
      });

      test('should be able to update themeMode', () async {
        var controller = SettingsController(SettingsService());
        await controller.loadSettings();

        await controller.updateThemeMode(ThemeMode.dark);
        expect(controller.themeMode, ThemeMode.dark);

        await controller.updateThemeMode(ThemeMode.light);
        expect(controller.themeMode, ThemeMode.light);
      });
    });

    group('assetHidden', () {
      test('should be able to get assetHidden', () async {
        var controller = SettingsController(SettingsService());
        await controller.loadSettings();

        expect(controller.assetHidden, isFalse);
      });

      test('should be able to update assetHidden', () async {
        var controller = SettingsController(SettingsService());
        await controller.loadSettings();

        controller.updateAssetHidden(true);

        expect(controller.assetHidden, isTrue);
      });
    });
  });
}
