import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:golden_goblin/src/themes.dart';
import 'package:golden_goblin/src/views/category_view/category_view.dart';

class CategoryEditView extends StatelessWidget {
  const CategoryEditView({Key? key}) : super(key: key);

  static const routeName = "/category_edit";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("編輯類別"),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        }),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
            child: Column(
              children: [
                TextFormField(
                  initialValue: "飲食",
                  decoration: InputDecoration(
                    icon: CategoryIcon(
                      iconData: Icons.restaurant,
                      color: const Color(0xFF99D6EA),
                    ),
                    labelText: "類別名稱",
                  ),
                ),
                DropdownButtonFormField(
                  value: 2,
                  decoration: const InputDecoration(
                    labelText: "類別圖示",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {},
                  items: const [
                    DropdownMenuItem(
                      child: Text("刀叉"),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text("交通"),
                      value: 2,
                    ),
                  ],
                ),
                DropdownButtonFormField(
                  value: 1,
                  decoration: const InputDecoration(
                    labelText: "圖示顏色",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {},
                  items: const [
                    DropdownMenuItem(
                      child: Text("藍色"),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text("黃色"),
                      value: 2,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text("刪除"),
                      style: GoldenGoblinThemes.dangerButtonLightStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextButton(
                        onPressed: () {},
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
    );
  }
}
