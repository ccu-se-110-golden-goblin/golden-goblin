import 'package:flutter/material.dart';

class IconColor {
  const IconColor({required this.color, required this.name});

  final Color color;
  final String name;
}

class IconColors {
  static const IconColor myRed =
      IconColor(color: Color(0xfff84747), name: '紅色');
  static const IconColor myOrange =
      IconColor(color: Color(0xffE47A59), name: '橘色');
  static const IconColor myYellow =
      IconColor(color: Color(0xffE4D659), name: '黃色');
  static const IconColor myGreen =
      IconColor(color: Color(0xff6CE459), name: '綠色');
  static const IconColor myBlue =
      IconColor(color: Color(0xff5988E4), name: '藍色');
  static const IconColor myPurple =
      IconColor(color: Color(0xff7D59E4), name: '紫色');
  static const IconColor myPink =
      IconColor(color: Color(0xffE459AC), name: '粉色');
  static const IconColor myGray =
      IconColor(color: Color(0xffA1A1A1), name: '灰色');
  static const IconColor myBlack =
      IconColor(color: Color(0xff000000), name: '黑色');

  static const List<IconColor> allColors = [
    myRed,
    myOrange,
    myYellow,
    myGreen,
    myBlack,
    myPurple,
    myPink,
    myGray,
    myBlack
  ];
}
