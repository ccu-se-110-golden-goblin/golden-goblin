import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:golden_goblin/src/views/account_view/account_edit_view.dart';
import 'package:golden_goblin/src/views/account_view/account_view.dart';
import 'package:golden_goblin/src/views/category_view/category_edit_view.dart';
import 'package:golden_goblin/src/views/category_view/category_view.dart';
import 'package:golden_goblin/src/views/ledger_view/ledger_edit_view.dart';
import 'package:golden_goblin/src/views/ledger_view/ledger_transfer_view.dart';

import 'themes.dart';
import 'views/ledger_view/ledger_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          //restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: GoldenGoblinThemes.light,
          darkTheme: GoldenGoblinThemes.dark,
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            FirebaseAnalytics.instance.logScreenView(
              screenName: routeSettings.name,
            );

            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case LedgerView.routeName:
                    return const LedgerView();
                  case LedgerEditView.routeName:
                    return LedgerEditView(
                        args: routeSettings.arguments! as LedgerEditViewArgs,
                    );
                  case LedgerTransferView.routeName:
                    return LedgerTransferView(
                      args: routeSettings.arguments! as LedgerTransferViewArgs,
                    );
                  case AccountView.routeName:
                    return const AccountView();
                  case AccountEditView.routeName:
                    return AccountEditView(
                      args: (routeSettings.arguments! as AccountEditArguments),
                    );
                  case CategoryView.routeName:
                    return const CategoryView();
                  case CategoryEditView.routeName:
                    return CategoryEditView(
                      args: (routeSettings.arguments! as CategoryEditArguments),
                    );

                  default:
                    return const LedgerView();
                }
              },
            );
          },
        );
      },
    );
  }
}
