import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'src/app.dart';
import 'firebase_options.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'src/models/account_provider.dart';
import 'src/models/category_provider.dart';
import 'src/models/transaction_provider.dart';
import 'src/models/transfer_provider.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(kReleaseMode);
    await FirebasePerformance.instance
        .setPerformanceCollectionEnabled(kReleaseMode);

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    final settingsController = SettingsController(SettingsService());

    // Load the user's preferred theme while the splash screen is displayed.
    // This prevents a sudden theme change when the app is first displayed.

    await settingsController.loadSettings();

    final accountProvider = DBAccountProvider();

    await accountProvider.loadAccounts();

    final categoryProvider = DBCategoryProvider();

    await categoryProvider
        .loadCategories(); // Run the app and pass in the SettingsController. The app listens to the
    // SettingsController for changes, then passes it further down to the
    // SettingsView.
    runApp(MultiProvider(
      providers: [
        Provider<AccountProvider>.value(value: accountProvider),
        Provider<CategoryProvider>.value(value: categoryProvider),
        Provider<TransactionProvider>(
          create: (_) => DBTransactionProvider(),
          lazy: false,
        ),
        Provider<TransferProvider>(
          create: (_) => DBTransferProvider(),
          lazy: false,
        ),
      ],
      child: MyApp(settingsController: settingsController),
    ));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}
