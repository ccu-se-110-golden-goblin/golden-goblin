import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../models/transaction_provider.dart';

import '../common/sidebar.dart';
import 'ledger_edit_view.dart';

class LedgerView extends StatelessWidget {
  const LedgerView({Key? key}) : super(key: key);

  static const routeName = '/ledger';

  // TODO: connect to viewModel to get data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Golden Goblin"),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              TransactionProvider.getTransactions()
                  .then((result) => print(result));
            },
          )
        ],
      ),
      drawer: const Sidebar(currentRouteName: routeName),
      floatingActionButton: FloatingActionButton(
        foregroundColor: const Color(0xFFFFD344),
        backgroundColor: const Color(0xFF000000),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, LedgerEditView.routeName, arguments: -1);
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 85,
            child: BudgetTile(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Divider(
              height: 2.0,
              thickness: 2.0,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _DailyList(
                    date: DateTime(2021, 8, 7),
                  ),
                  _DailyList(
                    date: DateTime(2021, 8, 22),
                  ),
                  _DailyList(
                    date: DateTime(2021, 11, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BudgetTile extends StatelessWidget {
  const BudgetTile({Key? key}) : super(key: key);

  // TODO: connect to viewModel to get current month data

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Center(
        child: Row(
          children: [
            SizedBox(
              width: 130.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "8月的支出",
                    style: TextStyle(
                      fontSize: 11.0,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 14),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: const [
                        TextSpan(
                          text: "\$NTD ",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        TextSpan(
                          text: "700",
                          style: TextStyle(
                            fontSize: 28.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      "預算 \$NTD 1000",
                      style: TextStyle(
                        fontSize: 11.0,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  LinearPercentIndicator(
                    percent: 0.5,
                    lineHeight: 14,
                    progressColor: const Color(0xFFFEC81A),
                    backgroundColor: Colors.grey[400],
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 5.0),
                      child: Text(
                        "編輯預算",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyList extends StatelessWidget {
  const _DailyList({
    Key? key,
    required this.date,
  }) : super(key: key);

  final DateTime date;

  static const List<String> _weekdayText = [
    "I should not be showed!!!",
    "MON",
    "TUE",
    "WED",
    "THU",
    "FRI",
    "SAT",
    "SUN",
  ];

  // TODO: connect to viewModel to get daily data

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 0.0, top: 12.0, right: 20.0, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 32.0,
                    child: Text(
                      date.day.toString(),
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 45.0,
                    child: Text(
                      "${date.year}.${date.month.toString().padLeft(2, '0')}\n${_weekdayText[date.weekday]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.0,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "總收入:",
                      style: TextStyle(
                        fontSize: 11.0,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style.copyWith(
                                color: const Color(0xFFBCC3A6),
                              ),
                          children: const [
                            TextSpan(
                              text: "\$NTD ",
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            TextSpan(
                              text: "3000",
                              style: TextStyle(
                                fontSize: 22.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "總支出:",
                      style: TextStyle(
                        fontSize: 11.0,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style.copyWith(
                                color: const Color(0xFFE19990),
                              ),
                          children: const [
                            TextSpan(
                              text: "\$NTD ",
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            TextSpan(
                              text: "100",
                              style: TextStyle(
                                fontSize: 22.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 77),
            child: Column(
              children: const [
                _ItemTile(
                  icon: Icons.restaurant,
                  title: "飲食",
                  remark: "早餐",
                  amount: 100,
                  color: Color(0x4DFEC81A),
                ),
                _ItemTile(
                  icon: Icons.wifi_protected_setup,
                  title: "銀行",
                  title2: "錢包",
                  remark: "我愛轉帳",
                  amount: 100,
                  color: Color(0x8099D6EA),
                ),
                _ItemTile(
                  icon: Icons.apartment,
                  title: "薪水",
                  amount: 3000,
                  color: Color(0x80CBD7A4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.amount,
    required this.color,
    this.title2,
    this.remark,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String? title2;
  final int amount;
  final String? remark;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {},
          child: SizedBox(
            height: 50.0,
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Icon(
                    icon,
                    size: 22,
                  ),
                ),
                Expanded(
                  child: RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        /* title */
                        TextSpan(
                          text: title,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        /* has title2 */
                        if (title2 != null)
                          const TextSpan(
                            text: "  >  ",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        if (title2 != null)
                          TextSpan(
                            text: title2,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        /* has remark */
                        if (remark != null)
                          TextSpan(
                            text: "\n$remark",
                            style: const TextStyle(
                              fontSize: 11.0,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        const TextSpan(
                          text: "\$NTD ",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        TextSpan(
                          text: "$amount",
                          style: const TextStyle(
                            fontSize: 22.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
