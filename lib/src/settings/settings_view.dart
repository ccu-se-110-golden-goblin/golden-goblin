import 'package:flutter/material.dart';
import 'package:golden_goblin/src/views/common/sidebar.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.

class AssetHiddenSwitch extends StatelessWidget {
  const AssetHiddenSwitch({Key? key, required this.controller})
      : super(key: key);

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('隱藏總資產'),
      value: controller.assetHidden,
      onChanged: controller.updateAssetHidden,
    );
  }
}

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({Key? key, required this.controller}) : super(key: key);

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    var themeModeToStr = {
      ThemeMode.system: '預設主題',
      ThemeMode.light: '亮色主題',
      ThemeMode.dark: '黑暗主題',
    };

    AlertDialog themeSelectDialog = AlertDialog(
      title: const Text('主題設定'),
      contentPadding: const EdgeInsets.only(bottom: 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: ThemeMode.values
            .map(
              (e) => ListTile(
                onTap: () {
                  controller.updateThemeMode(e);
                  Navigator.of(context).pop();
                },
                title: Text(themeModeToStr[e] ?? e.toString()),
                contentPadding: const EdgeInsets.only(left: 40),
                visualDensity: VisualDensity.compact,
              ),
            )
            .toList(),
      ),
    );

    return ListTile(
      title: const Text('主題設定'),
      subtitle: Text(themeModeToStr[controller.themeMode] ??
          controller.themeMode.toString()),
      onTap: () {
        showDialog(context: context, builder: (context) => themeSelectDialog);
      },
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key, required this.controller}) : super(key: key);

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('一般設定'),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      drawer: const Sidebar(currentRouteName: routeName),
      body: ListView(
        // padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          ThemeSelector(controller: controller),
          const Divider(thickness: 0.5, height: 0),
          AssetHiddenSwitch(controller: controller)
        ],
      ),
    );
  }
}
