import 'package:flutter/material.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.

class AssetHiddenSwitch extends StatefulWidget {
  const AssetHiddenSwitch({Key? key, required this.controller})
      : super(key: key);

  final SettingsController controller;

  @override
  State<AssetHiddenSwitch> createState() => _AssetHiddenSwitchState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _AssetHiddenSwitchState extends State<AssetHiddenSwitch> {
  bool _hidden = false;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('隱藏總資產'),
      value: _hidden,
      onChanged: (bool value) {
        setState(() {
          _hidden = value;
        });
      },
    );
  }
}

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({Key? key, required this.controller}) : super(key: key);

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('主題設定'),
      subtitle: DropdownButton<ThemeMode>(

          // Read the selected themeMode from the controller
          value: controller.themeMode,
          // Call the updateThemeMode method any time the user selects a theme.
          onChanged: controller.updateThemeMode,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Color(0xFFA1A1A1),
          ),
          iconSize: 20,
          underline: const SizedBox(),
          items: const [
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text('系統預設'),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text('明亮主題'),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text('黑暗主題'),
            )
          ],
          style: const TextStyle(color: Color(0xFFA1A1A1))),
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
      body: Padding(
          padding: const EdgeInsets.all(16),
          // Glue the SettingsController to the theme selection DropdownButton.
          //
          // When a user selects a theme from the dropdown list, the
          // SettingsController is updated, which rebuilds the MaterialApp.
          child: ListView(
            children: [
              ThemeSelector(controller: controller),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(thickness: 2),
              ),
              AssetHiddenSwitch(controller: controller)
            ],
          )),
    );
  }
}
