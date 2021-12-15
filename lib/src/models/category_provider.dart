import 'category.dart';

import '../helpers/db_helper.dart';

class CategoryProvider {
  List<Category> _categories = [];

  Future<void> loadCategories() async {
    var db = await DBHelper.opendb();

    List<Map> rawCategories = await db.query('categories');

    _categories = rawCategories
        .map((mapobj) => Category(
              id: mapobj['id'],
              name: mapobj['name'],
              type: Type.values[mapobj['type']],
            ))
        .toList();
  }

  List<Category> get getCategories => _categories;

  Category getCategory(int categoryId) {
    assert(categoryId >= 0, "categoryId must >= 0");

    return _categories.firstWhere((category) => category.id == categoryId);
  }

  // When insert into database, id will be ignore and replaced, use getAccounts to get new list with new id
  Future<int> addCategory(Category category) async {
    var db = await DBHelper.opendb();

    var categoryMap = category.toMap();

    categoryMap.remove('id');
    categoryMap['type'] = (categoryMap['type'] as Type).index;

    var recordid = await db.insert('categories', categoryMap);

    await loadCategories();

    return recordid;
  }

  Future<void> deleteCategory(int categoryId) async {
    var db = await DBHelper.opendb();

    await db.delete('categories', where: 'id = ?', whereArgs: [categoryId]);

    await loadCategories();
  }

  Future<void> updateCategory(int categoryId, Category newCategory) async {
    var db = await DBHelper.opendb();

    var categoryMap = newCategory.toMap();

    categoryMap.remove('id');
    categoryMap['type'] = (categoryMap['type'] as Type).index;

    await db.update('categories', categoryMap,
        where: 'id = ?', whereArgs: [categoryId]);

    await loadCategories();
  }
}
