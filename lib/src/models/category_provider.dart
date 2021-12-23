import 'package:flutter/material.dart';

import 'category.dart';

import '../helpers/db_helper.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

abstract class CategoryProvider {
  Future<void> loadCategories();

  List<Category> get getCategories;

  Category getCategory(int categoryId);

  Future<int> addCategory(Category category);

  Future<void> deleteCategory(int categoryId);

  Future<void> updateCategory(int categoryId, Category newCategory);
}

class DBCategoryProvider implements CategoryProvider {
  List<Category> _categories = [];

  @override
  Future<void> loadCategories() async {
    var db = await DBHelper.opendb();

    List<Map> rawCategories = await db.query('categories');

    _categories = rawCategories
        .map((mapobj) => Category(
              id: mapobj['id'],
              name: mapobj['name'],
              type: Type.values[mapobj['type']],
              iconData:
                  IconData(mapobj['iconData'], fontFamily: 'MaterialIcons'),
              iconColor: Color(mapobj['iconColor']),
            ))
        .toList();
  }

  @override
  List<Category> get getCategories => _categories;

  @override
  Category getCategory(int categoryId) {
    assert(categoryId >= 0, "categoryId must >= 0");

    return _categories.firstWhere((category) => category.id == categoryId);
  }

  // When insert into database, id will be ignore and replaced, use getAccounts to get new list with new id
  @override
  Future<int> addCategory(Category category) async {
    FirebaseAnalytics.instance.logEvent(name: 'add_category', parameters: {});
    var db = await DBHelper.opendb();

    var categoryMap = category.toMap();

    categoryMap.remove('id');
    categoryMap['type'] = (categoryMap['type'] as Type).index;
    categoryMap['iconData'] = (categoryMap['iconData'] as IconData).codePoint;
    categoryMap['iconColor'] = (categoryMap['iconColor'] as Color).value;

    var recordid = await db.insert('categories', categoryMap);

    await loadCategories();

    return recordid;
  }

  @override
  Future<void> deleteCategory(int categoryId) async {
    FirebaseAnalytics.instance
        .logEvent(name: 'delete_category', parameters: {});
    var db = await DBHelper.opendb();

    await db.delete('categories', where: 'id = ?', whereArgs: [categoryId]);

    await loadCategories();
  }

  @override
  Future<void> updateCategory(int categoryId, Category newCategory) async {
    FirebaseAnalytics.instance
        .logEvent(name: 'update_category', parameters: {});
    var db = await DBHelper.opendb();

    var categoryMap = newCategory.toMap();

    categoryMap.remove('id');
    categoryMap['type'] = (categoryMap['type'] as Type).index;
    categoryMap['iconData'] = (categoryMap['iconData'] as IconData).codePoint;
    categoryMap['iconColor'] = (categoryMap['iconColor'] as Color).value;

    await db.update('categories', categoryMap,
        where: 'id = ?', whereArgs: [categoryId]);

    await loadCategories();
  }
}
