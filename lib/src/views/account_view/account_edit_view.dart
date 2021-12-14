import 'package:flutter/material.dart';

import '../../themes.dart';
class AccountEditView extends StatefulWidget {
  const AccountEditView({Key? key}) : super(key: key);

  static const routeName = '/account_edit_view';
  static List<IconData> icons = [
    Icons.equalizer_rounded,
    Icons.wifi_lock,
    Icons.mail,
  ];
  static List<Color> colors = [
    Colors.amberAccent,
    Colors.blueAccent,
    Colors.teal,
  ];
  static List<String> colorString = [
    "黃色","藍色","綠色"
  ];
  static List<String> accounts = ["錢包", "悠遊卡", "銀行"];
  static IconData icon = Icons.account_balance_wallet;
  static Color color = Colors.grey;
  static var accountName = "";

  @override
  State<AccountEditView> createState() => _AccountEditViewState();
}

class _AccountEditViewState extends State<AccountEditView> {
  @override
  Widget build(BuildContext context) {
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
                      initialValue: AccountEditView.accountName,
                      decoration: InputDecoration(
                        icon: Icon(AccountEditView.icon, color: AccountEditView.color),
                        labelText: "帳本名稱",
                      ),
                    ),
                    DropdownButtonFormField<int>(
                      value: 0,
                      decoration: const InputDecoration(
                        labelText: "帳本圖示",
                        border: OutlineInputBorder(),
                      ),
                        onChanged: (int? v) {
                          setState((){
                            AccountEditView.icon =  AccountEditView.icons[v!];
                          });

                        },
                        items: [for (var i = 0; i < AccountEditView.icons.length; i++) i].map((int val) {
                          return DropdownMenuItem<int>(
                            value: val,
                            child: Row(
                              children: [
                                Icon(AccountEditView.icons[val]),
                                const SizedBox(width: 30),
                                Text(AccountEditView.accounts[val]),
                              ],
                            ),
                          );
                        }).toList()
                    ),
                    DropdownButtonFormField<int>(
                      value: 0,
                      decoration: const InputDecoration(
                        labelText: "圖示顏色",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (int? v) {
                        setState((){
                          AccountEditView.color =  AccountEditView.colors[v!];
                        });

                      },
                      items: [for (var i = 0; i < AccountEditView.colorString.length; i++) i].map((int val) {
                        return DropdownMenuItem<int>(
                          value: val,
                          child: Text(AccountEditView.colorString[val]),
                        );
                      }).toList(),

                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text("刪除",
                              style: TextStyle(color: Color(0xFFFF0000))),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith(
                                    (states) => const StadiumBorder()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextButton(
                            onPressed: () {},
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
                  ].map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: e,
                  )).toList(),
                ),
              ),
            ],
          ),
        )
    );
  }
}



