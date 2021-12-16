import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'src/models/account_provider.dart';
import 'src/models/category_provider.dart';
import 'src/models/transaction_provider.dart';
import 'src/models/transfer_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  WidgetsFlutterBinding.ensureInitialized();

  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.

  await settingsController.loadSettings();

  final accountProvider = AccountProvider();

  await accountProvider.loadAccounts();

  final categoryProvider = DBCategoryProvider();

  await categoryProvider.loadCategories();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MultiProvider(
    providers: [
      Provider.value(value: accountProvider),
      Provider<CategoryProvider>.value(value: categoryProvider),
      Provider<TransactionProvider>(
        create: (_) => TransactionProvider(),
        lazy: false,
      ),
      Provider<TransferProvider>(
        create: (_) => TransferProvider(),
        lazy: false,
      ),
    ],
    child: MyApp(settingsController: settingsController),
  ));
}
