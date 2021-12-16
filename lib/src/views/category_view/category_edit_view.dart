import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  static const List<IconData> iconOptions = [Icons.commute, Icons.restaurant];
  static const List<Color> colorOptions = [
    Colors.cyan,
    Colors.deepOrange,
    Color(0xFF99D6EA)
  ];

  static String getIconName(IconData icon) {
    if (icon == Icons.commute) return "交通";
    if (icon == Icons.restaurant) return "飲食";
    return "unknown";
  }

  static String getColorName(Color color) {
    if (color == Colors.cyan) return "青色";
    if (color == Colors.deepOrange) return "橘色";
    return "unknown";
  }

  String name = "";
  IconData icon = iconOptions[0];
  Color color = colorOptions[0];

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
              ))
          .then((value) => Navigator.pop(context));
    } else {
      CategoryProvider()
          .addCategory(Category(id: 0, type: args.type, name: name))
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
                    items: iconOptions
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text(getIconName(e)),
                            value: e,
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
                    items: colorOptions
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text(getColorName(e)),
                            value: e,
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
                        child: Text("刪除",
                            style: TextStyle(
                              color: args.category != null
                                  ? const Color(0xFFFF0000)
                                  : const Color(0x55000000),
                            )),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.resolveWith(
                              (states) => const StadiumBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextButton(
                          onPressed: handleSave,
                          child: const Text("完成",
                              style: TextStyle(color: Color(0xFFFFFFFF))),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) =>
                                    GoldenGoblinThemes.light.primaryColor),
                            shape: MaterialStateProperty.resolveWith(
                                (states) => const StadiumBorder()),
                          ),
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
