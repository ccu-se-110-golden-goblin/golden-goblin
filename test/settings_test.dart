import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_goblin/src/settings/settings_controller.dart';
import 'package:golden_goblin/src/settings/settings_service.dart';

void main() {
  group('Settings Controller', () {
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
}
