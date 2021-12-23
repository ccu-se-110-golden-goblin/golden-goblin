import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../icon_set.dart';
import '../color.dart';
import '../models/category.dart';

class DBHelper {
  static Future<Database> opendb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'godengoblin.db');

    // await deleteDatabase(path);

    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );

    return database;
  }
}

// Foreign key not set, for compatibility consideration
Future<void> _onCreate(Database db, int version) async {
  try {
    await db.execute("CREATE TABLE accounts ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT NOT NULL, icon INTERGER NOT NULL, iconColor INTEGER NOT NULL)");
    await db.execute("CREATE TABLE categories ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT NOT NULL, type INTERGER NOT NULL, iconData INTERGER NOT NULL, iconColor INTEGER NOT NULL)");
    await db.execute("CREATE TABLE transactions ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, amount INTEGER NOT NULL, account INTEGER NOT NULL, category INTEGER NOT NULL, date INTEGER NOT NULL, remark TEXT, invoice TEXT)");
    await db.execute("CREATE TABLE transfers ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, amount INTEGER NOT NULL, src INTEGER NOT NULL, dst INTEGER NOT NULL, date INTEGER NOT NULL, remark TEXT)");
    await db.insert('accounts', {
      'name': '錢包',
      'icon': MyIcons.wallet.icon.codePoint,
      'iconColor': IconColors.myBlack.color.value,
    });
    await db.insert('accounts', {
      'name': '銀行',
      'icon': MyIcons.bank.icon.codePoint,
      'iconColor': IconColors.myBlack.color.value,
    });
    await db.insert('categories', {
      'name': '飲食',
      'type': Type.expenses.index,
      'iconData': MyIcons.dining.icon.codePoint,
      'iconColor': IconColors.myOrange.color.value,
    });
    await db.insert('categories', {
      'name': '服裝',
      'type': Type.expenses.index,
      'iconData': MyIcons.cloth.icon.codePoint,
      'iconColor': IconColors.myOrange.color.value,
    });
    await db.insert('categories', {
      'name': '居家',
      'type': Type.expenses.index,
      'iconData': MyIcons.home.icon.codePoint,
      'iconColor': IconColors.myOrange.color.value,
    });
    await db.insert('categories', {
      'name': '交通',
      'type': Type.expenses.index,
      'iconData': MyIcons.train.icon.codePoint,
      'iconColor': IconColors.myOrange.color.value,
    });
    await db.insert('categories', {
      'name': '教育',
      'type': Type.expenses.index,
      'iconData': MyIcons.school.icon.codePoint,
      'iconColor': IconColors.myOrange.color.value,
    });
    await db.insert('categories', {
      'name': '娛樂',
      'type': Type.expenses.index,
      'iconData': MyIcons.game.icon.codePoint,
      'iconColor': IconColors.myOrange.color.value,
    });
    await db.insert('categories', {
      'name': '醫療',
      'type': Type.expenses.index,
      'iconData': MyIcons.health.icon.codePoint,
      'iconColor': IconColors.myOrange.color.value,
    });
    await db.insert('categories', {
      'name': '薪水',
      'type': Type.income.index,
      'iconData': MyIcons.cash.icon.codePoint,
      'iconColor': IconColors.myOrange.color.value,
    });
    await db.insert('categories', {
      'name': '利息',
      'type': Type.income.index,
      'iconData': MyIcons.savings.icon.codePoint,
      'iconColor': IconColors.myOrange.color.value,
    });
    await db.insert('categories', {
      'name': '投資',
      'type': Type.income.index,
      'iconData': MyIcons.invest.icon.codePoint,
      'iconColor': IconColors.myOrange.color.value,
    });
  } catch (err) {
    if (!kReleaseMode) {
      print("create database error: $err");
    }
    rethrow;
  }
}
