import 'package:flutter/material.dart';

class GoldenGoblinThemes {
  static AppBarTheme get _customAppBarTheme => ThemeData().appBarTheme.copyWith(
        foregroundColor: Colors.black,
        backgroundColor: const Color(0xFFFFD344),
        elevation: 0.0,
      );

  static ThemeData get light => ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFF4F4F4),
        appBarTheme: _customAppBarTheme,
        primaryColor: const Color(0xFFFFD344),
      );

  static ThemeData get dark => ThemeData.dark().copyWith(
        appBarTheme: _customAppBarTheme,
        primaryColor: const Color(0xFFFFD344),
      );
}
