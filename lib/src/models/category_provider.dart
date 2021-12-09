import 'catagory.dart';

class CategoryProvider {
  List<Category> _categories = [];

  Future<void> loadCategories() async {
    //TODO: Fetch from DB
    //mock data
    _categories = [
      Category(id: 0, name: "Cat 1", type: Type.income),
      Category(id: 1, name: "Cat 2", type: Type.income),
      Category(id: 2, name: "Cat 3", type: Type.income),
      Category(id: 3, name: "Cat 4", type: Type.expenses),
    ];

    await Future.delayed(const Duration(seconds: 3));
  }

  List<Category> get getCategories => _categories;

  Category getCategory(int categoryId) {
    assert(categoryId >= 0, "categoryId must >= 0");

    return _categories.firstWhere((category) => category.id == categoryId);
  }

  // When insert into database, id will be ignore and replaced, use getAccounts to get new list with new id
  Future<void> addCategory(Category category) async {
    //TODO: Add and reload from DB
    //mock operation
    _categories.add(Category(
      id: _categories.last.id + 1,
      name: category.name,
      type: category.type,
    ));

    await Future.delayed(const Duration(seconds: 3));
  }

  Future<void> deleteCategory(int categoryId) async {
    //TODO: delete and reload from DB
    //mock operation
    _categories.removeWhere((category) => category.id == categoryId);

    await Future.delayed(const Duration(seconds: 3));
  }

  Future<void> updateCategory(int categoryId, Category newCategory) async {
    //TODO: update and reload from DB
    //mock operation
    _categories.removeWhere((category) => category.id == categoryId);
    _categories.add(Category(
      id: categoryId,
      name: newCategory.name,
      type: newCategory.type,
    ));

    await Future.delayed(const Duration(seconds: 3));
  }
}
