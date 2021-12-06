import 'package:flutter/material.dart';

class GoldenGoblinThemes {
  static AppBarTheme get _customAppBarTheme => ThemeData().appBarTheme.copyWith(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        foregroundColor: Colors.black,
        backgroundColor: const Color(0xFFFFD344),
        elevation: 0.0,
      );

  static ThemeData get light => ThemeData.light().copyWith(
        appBarTheme: _customAppBarTheme,
        primaryColor: const Color(0xFFFFD344),
      );

  static ThemeData get dark => ThemeData.dark().copyWith(
        appBarTheme: _customAppBarTheme,
        primaryColor: const Color(0xFFFFD344),
      );
}
