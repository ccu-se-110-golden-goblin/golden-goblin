import 'package:flutter/material.dart';
import 'package:golden_goblin/src/models/transaction.dart';
import 'package:golden_goblin/src/models/transaction_provider.dart';
import 'package:golden_goblin/src/views/account_view/account_edit_view.dart';
import 'package:golden_goblin/src/views/common/sidebar.dart';
import 'package:golden_goblin/src/models/account.dart';
import 'package:golden_goblin/src/models/account_provider.dart';

class AccountItem extends StatelessWidget {
  const AccountItem(
      {Key? key,
      required this.iconData,
      required this.name,
      required this.iconColor,
      this.accountAsset,
      this.onTap})
      : super(key: key);

  final IconData iconData;
  final Color iconColor;
  final String name;
  final GestureTapCallback? onTap;
  final int? accountAsset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: ListTile(
          title: Row(
            children: [
              Expanded(child: Text(name)),
              SizedBox(width: 100, child: Text("\$NTD ${accountAsset ?? 0}"))
            ],
          ),
          leading: Icon(
            iconData,
            color: iconColor,
          ),
          onTap: onTap ?? () {},
        ),
      ),
    );
  }
}

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  static const routeName = _AccountViewState.routeName;

  @override
  State<StatefulWidget> createState() => _AccountViewState();
}

class _TransactionCalcResult {
  var totalAsset = 0;
  Map<int, int> accountCount = {};
}

class _AccountViewState extends State<AccountView> {
  static const routeName = '/account';
  var calcResult = _TransactionCalcResult();

  List<Account> accounts = [];

  void handleTransactionData(List<Transaction> transactions) {
    setState(() {
      calcResult = transactions.fold(_TransactionCalcResult(),
          (_TransactionCalcResult previousValue, element) {
        previousValue.totalAsset += element.amount;
        previousValue.accountCount[element.account] =
            (previousValue.accountCount[element.account] ?? 0) + element.amount;
        return previousValue;
      });
    });
  }

  void handleLoadData() {
    AccountProvider().loadAccounts().then((value) {
      setState(() {
        accounts = AccountProvider().getAccounts;
      });
    });

    TransactionProvider.getTransactions()
        .then((transactions) => handleTransactionData(transactions));
  }

  @override
  void initState() {
    super.initState();

    handleLoadData();
  }

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
            })),
        drawer: const Sidebar(currentRouteName: routeName),
        floatingActionButton: FloatingActionButton(
          foregroundColor: const Color(0xFF000000),
          backgroundColor: const Color(0xFFFFD344),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(
              context,
              "/account_edit",
              arguments: AccountEditArguments(),
            ).then((value) {
              handleLoadData();
            });
          },
        ),
        body: Column(
          children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("總資產", style: TextStyle(fontSize: 15)),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Text("\$NTD ${calcResult.totalAsset}",
                            style: const TextStyle(fontSize: 30))),
                    const Divider(thickness: 0.5, height: 0),
                  ],
                )),
            ListView.builder(
              shrinkWrap: true,
              itemCount: accounts.length,
              itemBuilder: (BuildContext context, int index) {
                var account = accounts[index];
                return AccountItem(
                  iconData: account.icon,
                  name: account.name,
                  iconColor: account.iconColor,
                  accountAsset: calcResult.accountCount[account.id],
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/account_edit",
                      arguments: AccountEditArguments(
                        account: account,
                      ),
                    ).then((value) {
                      handleLoadData();
                    });
                  },
                );
              },
            ),
          ],
        ));
  }
}
