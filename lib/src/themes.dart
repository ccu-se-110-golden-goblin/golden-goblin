import 'dart:ui';

import 'package:flutter/material.dart';

class GoldenGoblinThemes {
  static ThemeData get _baseBrightThemeData => ThemeData(
        primarySwatch: _goldengoblin,
      );

  static ThemeData get _baseDarkThemeData => ThemeData(
        brightness: Brightness.dark,
        primarySwatch: _goldengoblin,
        // ;;Note by Firecodev
        // Belows are required since set "brightness" to dark will make many colors ignored from primarySwatch.
        // See source code to get more info.
        // Is this a bug or a feature? I don't know, this issue is still opened https://github.com/flutter/flutter/issues/19089
        primaryColor: const Color(_goldengoblinPrimaryValue),
        // I know it's deprecated, but just ignore the warning to make your life easier :)
        accentColor: _goldengoblin[200],
        toggleableActiveColor: _goldengoblin[200],
      );

  static AppBarTheme get _customAppBarTheme => ThemeData().appBarTheme.copyWith(
        elevation: 0.0,
      );

  static final ButtonStyle normalButtonLightStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith((states) =>
        states.contains(MaterialState.disabled)
            ? Colors.grey[300]
            : _goldengoblin.shade500),
    shape: MaterialStateProperty.all(const StadiumBorder()),
    foregroundColor: MaterialStateProperty.resolveWith((states) =>
        states.contains(MaterialState.disabled)
            ? Colors.black54
            : const Color(0xFFFFFFFF)),
  );

  static final ButtonStyle dangerButtonLightStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith((states) =>
        states.contains(MaterialState.disabled)
            ? Colors.grey[300]
            : Colors.red[500]),
    shape: MaterialStateProperty.all(const StadiumBorder()),
    foregroundColor: MaterialStateProperty.resolveWith((states) =>
        states.contains(MaterialState.disabled)
            ? Colors.black54
            : const Color(0xFFFFFFFF)),
  );

  static ThemeData get light => _baseBrightThemeData.copyWith(
        scaffoldBackgroundColor: const Color(0xFFF4F4F4),
        appBarTheme: _customAppBarTheme,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: const Color(0xFFFFFFFF),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: normalButtonLightStyle,
        ),
      );

  static ThemeData get dark => _baseDarkThemeData.copyWith(
        appBarTheme: _customAppBarTheme,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        tabBarTheme: ThemeData.dark().tabBarTheme.copyWith(
              labelColor: _goldengoblin.shade200,
              unselectedLabelColor: const Color(0xFFFFFFFF),
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: const Color(0xFFFFFFFF),
          ),
        ),
      );

  // Generate from http://mcg.mbitson.com
  static const MaterialColor _goldengoblin =
      MaterialColor(_goldengoblinPrimaryValue, <int, Color>{
    50: Color(0xFFFFFAE9),
    100: Color(0xFFFFF2C7),
    200: Color(0xFFFFE9A2),
    300: Color(0xFFFFE07C),
    400: Color(0xFFFFDA60),
    500: Color(_goldengoblinPrimaryValue),
    600: Color(0xFFFFCE3E),
    700: Color(0xFFFFC835),
    800: Color(0xFFFFC22D),
    900: Color(0xFFFFB71F),
  });
  static const int _goldengoblinPrimaryValue = 0xFFFFD344;
}
