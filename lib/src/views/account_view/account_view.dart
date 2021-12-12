import 'package:flutter/material.dart';
import 'package:golden_goblin/src/views/account_view/account_edit_view.dart';
import '../common/sidebar.dart';
class AccountView extends StatelessWidget {
  AccountView({Key? key}) : super(key: key);

  static const routeName = '/account_view';
  final total_asset = 15550;
  final List<String> accounts = ["錢包", "悠遊卡", "銀行"];
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("帳本管理"),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );

        })
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: const Color(0xFF000000),
        backgroundColor: const Color(0xFFFFD344),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, AccountEditView.routeName);
        },
      ),

      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("總資產", style: TextStyle(fontSize: 15)),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text("\$NTD $total_asset", style: TextStyle(fontSize: 30, color: Color(
                      0xFF78785D)))
                ),

                const Divider(
                  height: 2.0,
                  thickness: 2.0,
                  color: Colors.black,
                )
              ],
            )
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: accounts.length,
            
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  title: Text(accounts[index]),
                  leading: Icon(AccountView.icons[index], color: colors[index],),
                  onTap: () {
                    Navigator.pushNamed(context, AccountEditView.routeName);

                  },
                ),
              );
            },
          ),
        ],
      )
    );
  }
}
