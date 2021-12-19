import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:golden_goblin/src/color.dart';
import 'package:golden_goblin/src/icon_set.dart';
import 'package:golden_goblin/src/models/category.dart';
import 'package:golden_goblin/src/models/category_provider.dart';
import 'package:golden_goblin/src/themes.dart';
import 'package:golden_goblin/src/views/category_view/category_view.dart';

class CategoryEditArguments {
  CategoryEditArguments({
    this.category,
    required this.type,
  });

  final Category? category;
  final Type type;
}

class CategoryEditView extends StatefulWidget {
  const CategoryEditView({Key? key, required this.args}) : super(key: key);

  final CategoryEditArguments args;

  static const routeName = "/category_edit";

  @override
  State<StatefulWidget> createState() => _CategoryEditState(args: args);
}

class _CategoryEditState extends State<CategoryEditView> {
  _CategoryEditState({required this.args});

  final CategoryEditArguments args;

  String name = "";
  IconData icon = MyIcons.icons[0].icon;
  Color color = IconColors.allColors[0].color;

  @override
  void initState() {
    super.initState();
    var category = args.category;
    if (category != null) {
      setState(() {
        name = category.name;
        icon = category.iconData;
        color = category.iconColor;
      });
    }
  }

  void handleSave() {
    var category = args.category;
    if (category != null) {
      CategoryProvider()
          .updateCategory(
              category.id,
              Category(
                id: category.id,
                type: category.type,
                name: name,
                iconData: icon,
                iconColor: color,
              ))
          .then((value) => Navigator.pop(context));
    } else {
      CategoryProvider()
          .addCategory(Category(
              id: 0,
              type: args.type,
              name: name,
              iconData: icon,
              iconColor: color))
          .then((value) => Navigator.pop(context));
    }
  }

  void handleDelete() {
    var category = args.category;
    if (category != null) {
      CategoryProvider()
          .deleteCategory(category.id)
          .then((value) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    var title = (args.category == null)
        ? "新增${args.type == Type.income ? "收入" : "支出"}類別"
        : "編輯類別";

    var icons = MyIcons.icons;
    var colors = IconColors.allColors;

    if (icons.where((element) => element.icon == icon).isEmpty) {
      icons = List.from(icons);
      icons.add(MyIcon(icon: icon, name: "unknown"));
    }

    if (colors.where((element) => element.color == color).isEmpty) {
      colors = List.from(colors);
      colors.add(IconColor(color: color, name: "unknown"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: name,
                    decoration: InputDecoration(
                      icon: CategoryIcon(
                        iconData: icon,
                        color: color,
                      ),
                      labelText: "類別名稱",
                    ),
                    onChanged: (v) {
                      setState(() {
                        name = v;
                      });
                    },
                  ),
                  DropdownButtonFormField(
                    value: icon,
                    decoration: const InputDecoration(
                      labelText: "類別圖示",
                      border: OutlineInputBorder(),
                    ),
                    items: icons
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text(e.name),
                            value: e.icon,
                          ),
                        )
                        .toList(),
                    onChanged: (IconData? v) {
                      if (v != null) {
                        setState(() {
                          icon = v;
                        });
                      }
                    },
                  ),
                  DropdownButtonFormField(
                    value: color,
                    decoration: const InputDecoration(
                      labelText: "圖示顏色",
                      border: OutlineInputBorder(),
                    ),
                    items: colors
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text(e.name),
                            value: e.color,
                          ),
                        )
                        .toList(),
                    onChanged: (Color? v) {
                      if (v != null) {
                        setState(() {
                          color = v;
                        });
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed:
                            (args.category != null) ? handleDelete : null,
                        child: const Text("刪除"),
                        style: GoldenGoblinThemes.dangerButtonLightStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextButton(
                          onPressed: handleSave,
                          child: const Text("完成"),
                        ),
                      ),
                    ],
                  ),
                ]
                    .map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: e,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
