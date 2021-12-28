import 'package:flutter/material.dart';
import 'package:golden_goblin/src/views/account_view/account_view.dart';
import 'package:golden_goblin/src/views/category_view/category_view.dart';

import '../../widgets/sidebar_tile.dart';

import '../../settings/settings_view.dart';
import '../ledger_view/ledger_view.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    Key? key,
    required this.currentRouteName,
  }) : super(key: key);

  final String currentRouteName;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: Drawer(
          child: Column(
            children: [
              const _Header(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SidebarTile(
                        leading: const Icon(Icons.receipt_long, size: 16),
                        title: const Text("收支紀錄"),
                        isSelected: currentRouteName == LedgerView.routeName,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 30.0),
                        onTap: () {
                          print("收支紀錄 tapped");
                          Navigator.pop(context);
                          if (currentRouteName != LedgerView.routeName) {
                            Navigator.restorablePushReplacementNamed(
                                context, LedgerView.routeName);
                          }
                        },
                      ),
                      // SidebarTile(
                      //   leading: const Icon(Icons.insights, size: 16),
                      //   title: const Text("分析圖表"),
                      //   isSelected: false,
                      //   padding: const EdgeInsets.symmetric(
                      //       vertical: 12.0, horizontal: 30.0),
                      //   onTap: () {
                      //     print("分析圖表 tapped");
                      //     Navigator.pop(context);
                      //   },
                      // ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(thickness: 1),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 14.0),
                        child: Text("設定",
                            // Todo: use theme data instead of hard coded
                            style: TextStyle(color: Color(0xFFA1A1A1))),
                      ),
                      SidebarTile(
                        leading: const Icon(Icons.construction, size: 16),
                        title: const Text("一般"),
                        isSelected: currentRouteName == SettingsView.routeName,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 30.0),
                        onTap: () {
                          print("一般 tapped");
                          Navigator.pop(context);
                          if (currentRouteName != SettingsView.routeName) {
                            Navigator.restorablePushReplacementNamed(
                                context, SettingsView.routeName);
                          }
                        },
                      ),
                      SidebarTile(
                        leading: const Icon(Icons.import_contacts, size: 16),
                        title: const Text("帳本管理"),
                        isSelected: currentRouteName == AccountView.routeName,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 30.0),
                        onTap: () {
                          print("帳本管理 tapped");
                          Navigator.pop(context);
                          if (currentRouteName != AccountView.routeName) {Navigator.restorablePushNamed(
                              context, AccountView.routeName);}
                        },
                      ),
                      SidebarTile(
                        leading: const Icon(Icons.flag_outlined, size: 16),
                        title: const Text("類別管理"),
                        isSelected: currentRouteName == CategoryView.routeName,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 30.0),
                        onTap: () {
                          print("類別管理 tapped");
                          Navigator.pop(context);
                          if (currentRouteName != CategoryView.routeName) {
                            Navigator.pushReplacementNamed(
                                context, CategoryView.routeName);
                          }
                        },
                      ),
                      // TODO
                      // SidebarTile(
                      //   leading: const Icon(Icons.savings_outlined, size: 16),
                      //   title: const Text("預算控制"),
                      //   padding: const EdgeInsets.symmetric(
                      //       vertical: 12.0, horizontal: 30.0),
                      //   onTap: () {
                      //     print("預算控制 tapped");
                      //     Navigator.pop(context);
                      //   },
                      // ),
                      // TODO
                      // SidebarTile(
                      //   leading: const Icon(Icons.view_headline, size: 16),
                      //   title: const Text("載具設定"),
                      //   padding: const EdgeInsets.symmetric(
                      //       vertical: 12.0, horizontal: 30.0),
                      //   onTap: () {
                      //     print("載具設定 tapped");
                      //     Navigator.pop(context);
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
              const _Footer(),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Image(image: AssetImage('assets/images/logo.png')),
          ),
          Text(
            "Golden Goblin",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SidebarTile(
          leading: const Icon(
            Icons.info_outline,
            size: 16,
            // Todo: use theme data instead of hard coded
            color: Color(0xFFA1A1A1),
          ),
          title: const Text("使用說明",
              // Todo: use theme data instead of hard coded
              style: TextStyle(color: Color(0xFFA1A1A1))),
          isSelected: false,
          centered: false,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          onTap: () {
            print("使用說明 tapped");
            Navigator.pop(context);
          },
        ),
        SidebarTile(
          leading: const Icon(
            Icons.person_outline, size: 16,
            // Todo: use theme data instead of hard coded
            color: Color(0xFFA1A1A1),
          ),
          title: const Text("關於我們",
              // Todo: use theme data instead of hard coded
              style: TextStyle(color: Color(0xFFA1A1A1))),
          isSelected: false,
          centered: false,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          onTap: () {
            print("關於我們 tapped");
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
