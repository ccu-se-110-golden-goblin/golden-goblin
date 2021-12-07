import 'package:flutter/material.dart';

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
  ThemeSelector({Key? key, required this.controller}) : super(key: key);

  final SettingsController controller;

  final Dialog themeSelectDialog = Dialog(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Text(
            '主題設定',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Divider(height: 0),
        Text(
          '系統預設',
          style: TextStyle(fontSize: 20),
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    AlertDialog dialog = AlertDialog(
      title: const Text('主題設定'),
      contentPadding: EdgeInsets.zero,
      content: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                controller.updateThemeMode(ThemeMode.system);
                Navigator.of(context).pop();
              },
              title: const Text('預設主題'),
              contentPadding: const EdgeInsets.only(left: 40),
              visualDensity: VisualDensity.compact,
            ),
            ListTile(
              onTap: () {
                controller.updateThemeMode(ThemeMode.light);
                Navigator.of(context).pop();
              },
              title: const Text('亮色主題'),
              contentPadding: const EdgeInsets.only(left: 40),
              visualDensity: VisualDensity.compact,
            ),
            ListTile(
              onTap: () {
                controller.updateThemeMode(ThemeMode.dark);
                Navigator.of(context).pop();
              },
              title: const Text('黑暗主題'),
              contentPadding: const EdgeInsets.only(left: 40),
              visualDensity: VisualDensity.compact,
            )
          ],
        ),
      ),
    );

    return ListTile(
      title: const Text('主題設定'),
      subtitle: Text(controller.themeMode.toString()),
      onTap: () {
        showDialog(context: context, builder: (context) => dialog);
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
      ),
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
