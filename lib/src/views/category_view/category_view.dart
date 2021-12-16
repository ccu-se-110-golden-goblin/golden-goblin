import 'package:flutter/material.dart';
import 'package:golden_goblin/src/models/category.dart';
import 'package:golden_goblin/src/models/category_provider.dart';
import 'package:golden_goblin/src/themes.dart';
import 'package:golden_goblin/src/views/category_view/category_edit_view.dart';
import 'package:golden_goblin/src/views/common/sidebar.dart';

class CategoryIcon extends StatelessWidget {
  const CategoryIcon({Key? key, required this.iconData, required this.color})
      : super(key: key);

  final IconData iconData;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Icon(
        iconData,
        color: const Color(0xFFFFFFFF),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  const CategoryItem(
      {Key? key,
      required this.iconData,
      required this.name,
      required this.iconColor,
      this.onTap})
      : super(key: key);

  final IconData iconData;
  final Color iconColor;
  final String name;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CategoryIcon(
              iconData: iconData,
              color: iconColor,
            ),
            Text(name),
          ],
        ),
      ),
      onTap: onTap ?? () {},
    );
  }
}

class CategoryView extends StatefulWidget {
  const CategoryView({Key? key}) : super(key: key);

  static const routeName = _CategoryViewState.routeName;

  @override
  State<StatefulWidget> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView>
    with SingleTickerProviderStateMixin {
  static const routeName = "/category";

  List<Category> categories = [];

  late TabController _tabController;

  void handleLoadData() {
    CategoryProvider().loadCategories().then((value) {
      setState(() {
        categories = CategoryProvider().getCategories;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    handleLoadData();

    _tabController = TabController(length: Type.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("類別"),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      drawer: const Sidebar(currentRouteName: routeName),
      floatingActionButton: FloatingActionButton(
        foregroundColor: const Color(0xFFFFD344),
        backgroundColor: const Color(0xFF000000),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/category_edit",
            arguments: CategoryEditArguments(
              type: Type.values[_tabController.index],
            ),
          ).then((value) {
            handleLoadData();
          });
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              indicatorColor: GoldenGoblinThemes.light.primaryColor,
              labelColor: GoldenGoblinThemes.light.primaryColor,
              unselectedLabelColor: const Color(0x99000000),
              tabs: Type.values.map((e) {
                if (e == Type.income) {
                  return const Tab(text: '收入');
                }
                return const Tab(text: '支出');
              }).toList(),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: Type.values
                    .map((type) => GridView(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            childAspectRatio: 0.7,
                          ),
                          children: categories
                              .where((value) => value.type == type)
                              .map(
                                (category) => CategoryItem(
                                  name: category.name,
                                  iconData: category.iconData,
                                  iconColor: category.iconColor,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      "/category_edit",
                                      arguments: CategoryEditArguments(
                                        category: category,
                                        type: category.type,
                                      ),
                                    ).then((value) {
                                      handleLoadData();
                                    });
                                  },
                                ),
                              )
                              .toList(),
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
