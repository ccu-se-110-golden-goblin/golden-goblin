import 'package:flutter/material.dart';
import 'package:golden_goblin/src/views/ledger_view/ledger_transfer.dart';
import 'package:intl/intl.dart';

class LedgerEditView extends StatefulWidget {
  const LedgerEditView({Key? key}) : super(key: key);

  static const routeName = '/ledger_edit';
  static DateTime date = DateTime.now();
  static List<String> accounts = ["錢包", "悠遊卡", "銀行"];
  static List<IconData> icons = [
    Icons.equalizer_rounded,
    Icons.wifi_lock,
    Icons.mail,
  ];
  static var account;
  static var icon;

  @override
  State<LedgerEditView> createState() => _LedgerEditViewState();
}

class _LedgerEditViewState extends State<LedgerEditView> {
  var dollar = "";

  var comment = "";

  @override
  Widget build(BuildContext context) {
    print(ModalRoute.of(context)?.settings.name);
    return Scaffold(
        appBar: AppBar(
          title: const Text("新增交易"),
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          }),
          actions: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.transform),
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 0, left: 10, right: 10),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, LedgerTransferView.routeName);
                      }),
                  const Text("轉帳", style: TextStyle(fontSize: 8)),
                ]),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 20.0),
                child: Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "0",
                          icon: Icon(Icons.attach_money, color: Colors.black),
                        ),
                      ),
                    ),
                    const Text("NTD"),
                  ],
                ),
              ),
              Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("日期:", style: TextStyle(fontSize: 15)),
                  DatePicker()
                ],
              )),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("帳戶:", style: TextStyle(fontSize: 15)),
                      AccountPicker()
                    ],
                  )),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("類別:", style: TextStyle(fontSize: 15)),
                    ],
                  )),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("註解:", style: TextStyle(fontSize: 15)),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "無",
                        ),
                      ),
                    ],
                  )),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("完成"),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(color: Color(0x00ffd344))))))
            ],
          ),
        ));
  }
}

class DatePicker extends StatefulWidget {
  const DatePicker({Key? key}) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () async {
          final newDate = await showDatePicker(
              context: context,
              initialDate: LedgerEditView.date,
              firstDate: DateTime(DateTime.now().year - 5),
              lastDate: DateTime(DateTime.now().year + 1),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(),
                    ),
                  ),
                  child: child!,
                );
              });

          if (newDate == null) return;

          setState(() => LedgerEditView.date = newDate);
        },
        child: Container(
          width: 260,
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          color: Color(0x1FF0D821),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.event),
              Text(
                  DateFormat('MM / dd / yyyy')
                      .format(LedgerEditView.date)
                      .toString(),
                  style: const TextStyle(fontSize: 20)),
              const Icon(Icons.expand_more),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountPicker extends StatefulWidget {
  const AccountPicker({Key? key}) : super(key: key);

  @override
  _AccountPickerState createState() => _AccountPickerState();
}

class _AccountPickerState extends State<AccountPicker> {
  _AccountPickerState() {
    LedgerEditView.account = LedgerEditView.accounts[0];
    LedgerEditView.icon = LedgerEditView.icons[0];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('選擇帳本'),
                  content: Container(
                    width: double.minPositive,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: LedgerEditView.accounts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(LedgerEditView.accounts[index]),
                          leading: Icon(LedgerEditView.icons[index]),
                          onTap: () {
                            setState(() {
                              LedgerEditView.account =
                                  LedgerEditView.accounts[index];
                              LedgerEditView.icon = LedgerEditView.icons[index];
                            });

                            Navigator.pop(
                                context, LedgerEditView.accounts[index]);
                          },
                        );
                      },
                    ),
                  ),
                );
              });
        }, //TODO: expand account
        child: Container(
          width: 260,
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          color: Color(0x1FF0D821),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(LedgerEditView.icon),
              Text(LedgerEditView.account),
              Icon(Icons.expand_more),
            ],
          ),
        ),
      ),
    );
  }
}
