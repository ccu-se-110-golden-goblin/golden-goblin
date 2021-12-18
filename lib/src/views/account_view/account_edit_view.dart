import 'package:flutter/material.dart';
import 'package:golden_goblin/src/color.dart';
import 'package:golden_goblin/src/icon_set.dart';
import 'package:golden_goblin/src/models/account.dart';
import 'package:golden_goblin/src/models/account_provider.dart';
import 'package:golden_goblin/src/themes.dart';
import 'package:provider/provider.dart';

class AccountEditArguments {
  AccountEditArguments({
    this.account,
  });

  final Account? account;
}

class AccountEditView extends StatefulWidget {
  const AccountEditView({Key? key, required this.args}) : super(key: key);

  static const routeName = '/account_edit';

  final AccountEditArguments args;
  static List<MyColor> colors = IconColors.allColors;

  @override
  State<AccountEditView> createState() => _AccountEditState(args: args);
}

class _AccountEditState extends State<AccountEditView> {
  _AccountEditState({required this.args});

  final AccountEditArguments args;

  String name = "";
  IconData icon = MyIcons.icons[0].icon;
  Color color = IconColors.allColors[0].color;

  @override
  void initState() {
    super.initState();
    var account = args.account;
    if (account != null) {
      setState(() {
        name = account.name;
        icon = account.icon;
        color = account.iconColor;
      });
    }
  }

  void handleDelete(AccountProvider accountProvider) {
    var account = args.account;
    if (account != null) {
      accountProvider
          .deleteAccount(account.id)
          .then((value) => Navigator.pop(context));
    }
  }

  void handleSave(AccountProvider accountProvider) {
    var account = args.account;
    if (account != null) {
      accountProvider
          .updateAccount(account.id,
              Account(id: account.id, name: name, icon: icon, iconColor: color))
          .then((value) => Navigator.pop(context));
    } else {
      accountProvider
          .addAccount(Account(id: 0, name: name, icon: icon, iconColor: color))
          .then((value) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    AccountProvider accountProvider = Provider.of<AccountProvider>(context);

    var icons = MyIcons.icons;
    var colors = IconColors.allColors;

    if (icons.where((element) => element.icon == icon).isEmpty) {
      icons = List.from(icons);
      icons.add(MyIcon(icon: icon, name: "unknown"));
    }

    if (colors.where((element) => element.color == color).isEmpty) {
      colors = List.from(colors);
      colors.add(MyColor(color: color, name: "unknown"));
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("編輯帳本"),
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            );

          }),

        ),


        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: name,
                      decoration: InputDecoration(
                        icon: Icon(icon, color: color),
                        labelText: "帳本名稱",
                      ),
                      onChanged: (v) {
                        setState(() {
                          name = v;
                        });
                      },
                    ),
                    DropdownButtonFormField<IconData>(
                      value: icon,
                      decoration: const InputDecoration(
                        labelText: "帳本圖示",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (IconData? v) {
                        if (v != null) {
                          setState(() {
                            icon = v;
                          });
                        }
                      },
                      items: icons
                          .map((e) => DropdownMenuItem(
                                value: e.icon,
                                child: Row(
                                  children: [
                                    Icon(e.icon),
                                    const SizedBox(width: 30),
                                    Text(e.name),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                    DropdownButtonFormField<Color>(
                      value: color,
                      decoration: const InputDecoration(
                        labelText: "圖示顏色",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (Color? v) {
                        if (v != null) {
                          setState(() {
                            color = v;
                          });
                        }
                      },
                      items: colors
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.color,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: (args.account != null)
                                ? () => handleDelete(accountProvider)
                                : null,
                            child: const Text("刪除"),
                            style: GoldenGoblinThemes.dangerButtonLightStyle),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextButton(
                              onPressed: () => handleSave(accountProvider),
                              child: const Text("完成")),
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
        ));
  }
}



