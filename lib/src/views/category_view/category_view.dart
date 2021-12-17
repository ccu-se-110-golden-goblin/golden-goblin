import 'package:flutter/material.dart';
import 'package:golden_goblin/src/models/category.dart';
import 'package:golden_goblin/src/themes.dart';
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
  const CategoryItem({Key? key, required this.iconData, required this.name})
      : super(key: key);

  final IconData iconData;
  final String name;

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
              color: const Color(0xFF99D6EA),
            ),
            Text(name),
          ],
        ),
      ),
      onTap: () {},
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView({Key? key}) : super(key: key);

  static const routeName = "/category";

  final Map<Type, List<CategoryItem>> categories = const {
    Type.expenses: [
      CategoryItem(iconData: Icons.restaurant, name: "飲食"),
      CategoryItem(iconData: Icons.commute, name: "交通"),
      CategoryItem(iconData: Icons.local_grocery_store, name: "日常用品"),
      CategoryItem(iconData: Icons.checkroom, name: "穿著"),
      CategoryItem(iconData: Icons.card_giftcard, name: "禮物"),
    ],
    Type.income: [
      CategoryItem(iconData: Icons.money, name: "薪水"),
      CategoryItem(iconData: Icons.attach_money, name: "投資"),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, "/category_edit");
          },
        ),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: '支出'),
                Tab(text: '收入'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [Type.expenses, Type.income]
                    .map((e) => GridView(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            childAspectRatio: 0.7,
                          ),
                          children: categories[e] ?? [],
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
