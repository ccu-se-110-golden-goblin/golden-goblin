import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_goblin/src/models/category.dart';
import 'package:golden_goblin/src/models/category_provider.dart';
import 'package:golden_goblin/src/views/category_view/category_view.dart';
import 'package:provider/provider.dart';

class MockCategoryProvider implements CategoryProvider {
  MockCategoryProvider({List<Category>? list}) {
    if (list != null) _list.addAll(list);
  }

  final List<Category> _list = [];
  int _nextId = 0;

  @override
  Future<int> addCategory(Category category) {
    var newId = _nextId++;
    _list.add(Category(id: newId, name: category.name, type: category.type));
    return Future.value(newId);
  }

  @override
  Future<void> deleteCategory(int categoryId) {
    _list.removeWhere((element) => element.id == categoryId);
    return Future.value();
  }

  @override
  List<Category> get getCategories => _list;

  @override
  Category getCategory(int categoryId) {
    return _list.firstWhere((element) => element.id == categoryId);
  }

  @override
  Future<void> updateCategory(int categoryId, Category newCategory) {
    if (categoryId != newCategory.id) {
      throw Exception('categoryId must match with newCategory.id');
    }
    var idx = _list.indexWhere((element) => element.id == categoryId);
    _list[idx] = newCategory;
    return Future.value();
  }

  @override
  Future<void> loadCategories() {
    return Future.value();
  }
}

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(
      data: const MediaQueryData(), child: MaterialApp(home: widget));
}

void main() {
  late MockCategoryProvider mockCategoryProvider;

  group('CategoryView', () {
    var categoryList = [
      Category(id: 0, name: "income_category_1", type: Type.income),
      Category(id: 1, name: "expenses_category_1", type: Type.expenses),
    ];

    setUp(() async {
      mockCategoryProvider = MockCategoryProvider(list: categoryList);
    });

    testWidgets('should be able to show list of categories',
        (WidgetTester tester) async {
      var categoryViewWidget = MultiProvider(
        providers: [
          Provider<CategoryProvider>.value(value: mockCategoryProvider),
        ],
        child: const CategoryView(),
      );

      await tester.pumpWidget(buildTestableWidget(categoryViewWidget));

      expect(find.text(categoryList[0].name), findsOneWidget);
      expect(find.text(categoryList[1].name), findsNothing);

      await tester.tap(find.text('支出'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text(categoryList[1].name), findsOneWidget);
      expect(find.text(categoryList[0].name), findsNothing);
    });
  });
}
