import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT NOT NULL, icon INTERGER NOT NULL, iconcolor INTEGER NOT NULL)");
    await db.execute("CREATE TABLE categories ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT NOT NULL, type INTERGER NOT NULL)");
    await db.execute("CREATE TABLE transactions ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, amount INTEGER NOT NULL, account INTEGER NOT NULL, category INTEGER NOT NULL, date INTEGER NOT NULL, remark TEXT, invoice TEXT)");
    await db.execute("CREATE TABLE transfers ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, amount INTEGER NOT NULL, src INTEGER NOT NULL, dst INTEGER NOT NULL, amount INTEGER NOT NULL, remark TEXT)");
  } catch (err) {
    if (!kReleaseMode) {
      print("create database error: $err");
    }
    rethrow;
  }
}
