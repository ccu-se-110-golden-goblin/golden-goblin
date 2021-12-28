import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:golden_goblin/src/views/ledger_view/ledger_transfer_view.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../view_models/ledger_view_model.dart';

import '../common/sidebar.dart';
import 'ledger_edit_view.dart';

class LedgerView extends StatefulWidget {
  const LedgerView({Key? key}) : super(key: key);

  static const routeName = '/ledger';

  @override
  State<LedgerView> createState() => _LedgerViewState();
}

class _LedgerViewState extends State<LedgerView> {
  LedgerViewModel viewModelProvider = LedgerViewModel(now: DateTime.now());
  DateTime _month = DateTime.now();

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    viewModelProvider.setDate(DateTime(now.year, now.month));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModelProvider.initProviders(context);
  }

  void setMonth(DateTime month) {
    DateTime newMonth = DateTime(month.year, month.month);
    viewModelProvider.setDate(newMonth);
    setState(() {
      _month = newMonth;
    });
  }

  List<Widget> getDailyListWidget(List<DailyListData> dailyLists) {
    List<Widget> list = [];
    for (var i = 0; i < dailyLists.length; i++) {
      list.add(_DailyList(
          date: dailyLists[i].date,
          itemTitles: dailyLists[i].itemTitleList,
          dailyIncoming: dailyLists[i].totalIncoming,
          dailyExpense: dailyLists[i].totalExpense));
    }
    if (list.isEmpty == true) {
      list.add(const Text("No Data Found!"));
    }
    return list;
  }

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
              viewModelProvider
                  .addMock()
                  .then((value) => setMonth(DateTime.now()));
            },
          )
        ],
      ),
      drawer: const Sidebar(currentRouteName: LedgerView.routeName),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, LedgerEditView.routeName,
                  arguments: LedgerEditViewArgs())
              .then((value) => setState(() {})); // force rebuild
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            color: Colors.grey[300],
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
              child: Center(
                child: Row(
                  children: [
                    SizedBox(
                      width: 120.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${_month.year}年${_month.month}月"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                setMonth(
                                    DateTime(_month.year, _month.month - 1));
                              });
                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(0)),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0x00000000)),
                              foregroundColor: MaterialStateProperty.all(
                                  const Color(0xFF000000)),
                            ),
                            child: const Icon(Icons.navigate_before),
                          ),
                          TextButton(
                            onPressed: () {
                              setMonth(DateTime(_month.year, _month.month + 1));
                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(0)),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0x00000000)),
                              foregroundColor: MaterialStateProperty.all(
                                  const Color(0xFF000000)),
                            ),
                            child: const Icon(Icons.navigate_next),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // FixMe: Temporary hide budget tile
          // const SizedBox(
          //   height: 85,
          //   child: BudgetTile(),
          // ),
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 8.0),
          //   child: Divider(
          //     height: 2.0,
          //     thickness: 2.0,
          //   ),
          // ),
          Expanded(
            child: FutureBuilder(
                future: viewModelProvider.getDailyLists(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<DailyListData>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.connectionState == ConnectionState.active) {
                    return const Center(
                      child: Text("載入中.."),
                    );
                  }

                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return _DailyList(
                              date: snapshot.data![index].date,
                              itemTitles: snapshot.data![index].itemTitleList,
                              dailyExpense: snapshot.data![index].totalExpense,
                              dailyIncoming:
                                  snapshot.data![index].totalIncoming);
                        });
                  } else {
                    return const Center(
                      child: Text("沒有記帳紀錄"),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}

class BudgetTile extends StatelessWidget {
  const BudgetTile({Key? key}) : super(key: key);

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
  const _DailyList(
      {Key? key,
      required this.date,
      required this.itemTitles,
      required this.dailyIncoming,
      required this.dailyExpense})
      : super(key: key);

  final DateTime date;
  final List<ItemTitleData> itemTitles;
  final int dailyIncoming;
  final int dailyExpense;

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

  List<Widget> getItemLists(List<ItemTitleData> dailyLists) {
    List<Widget> list = [];
    for (var i = 0; i < dailyLists.length; i++) {
      list.add(_ItemTile(
          id: itemTitles[i].id,
          icon: itemTitles[i].icon,
          title: itemTitles[i].title,
          amount: itemTitles[i].amount,
          color: itemTitles[i].color,
          title2: itemTitles[i].title2,
          remark: itemTitles[i].remark));
    }
    if (list.isEmpty == true) {
      list.add(const Text("No Data Found!"));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> itemTitlesWidget = getItemLists(itemTitles);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
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
                  const SizedBox(width: 8),
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
                          children: [
                            const TextSpan(
                              text: "\$NTD ",
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            TextSpan(
                              text: dailyIncoming.toString(),
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
                          children: [
                            const TextSpan(
                              text: "\$NTD ",
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            TextSpan(
                              text: "$dailyExpense",
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
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 77),
            child: Column(children: itemTitlesWidget),
          ),
        ],
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    Key? key,
    required this.id,
    required this.icon,
    required this.title,
    required this.amount,
    required this.color,
    this.title2,
    this.remark,
  }) : super(key: key);

  final int id;
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
          onTap: () {
            bool isTransfer = (title2 != null) ? true : false;

            if (isTransfer) {
              LedgerTransferViewArgs.getFromId(id).then((value) =>
                  Navigator.pushNamed(context, LedgerTransferView.routeName,
                      arguments: value));
            } else {
              LedgerEditViewArgs.getFromId(id).then((value) =>
                  Navigator.pushNamed(context, LedgerEditView.routeName,
                      arguments: value));
            }
          },
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
