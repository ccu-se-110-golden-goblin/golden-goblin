import 'package:flutter/material.dart';

class MyColor {
  const MyColor({required this.color, required this.name});

  final Color color;
  final String name;
}

class IconColors {
  static const MyColor myRed = MyColor(color: Color(0xfff84747), name: '紅色');
  static const MyColor myOrange = MyColor(color: Color(0xffE47A59), name: '橘色');
  static const MyColor myYellow = MyColor(color: Color(0xffE4D659), name: '黃色');
  static const MyColor myGreen = MyColor(color: Color(0xff6CE459), name: '綠色');
  static const MyColor myBlue = MyColor(color: Color(0xff5988E4), name: '藍色');
  static const MyColor myPurple = MyColor(color: Color(0xff7D59E4), name: '紫色');
  static const MyColor myPink = MyColor(color: Color(0xffE459AC), name: '粉色');
  static const MyColor myGray = MyColor(color: Color(0xffA1A1A1), name: '灰色');
  static const MyColor myBlack = MyColor(color: Color(0xff000000), name: '黑色');
  static const MyColor expenses = MyColor(color: Color(0x18fec81a), name: '支出');
  static const MyColor income = MyColor(color: Color(0x32cbd7a4), name: '收入');
  static const MyColor transfer = MyColor(color: Color(0x3299d6ea), name: '轉帳');

  static const List<MyColor> allColors = [
    myRed,
    myOrange,
    myYellow,
    myGreen,
    myBlue,
    myPurple,
    myPink,
    myGray,
    myBlack
  ];

  static const List<MyColor> typeColors = [expenses, income, transfer];
}
