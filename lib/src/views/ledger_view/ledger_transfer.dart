import 'package:flutter/material.dart';
import 'package:golden_goblin/src/views/ledger_view/ledger_edit_view.dart';
import 'package:golden_goblin/src/views/ledger_view/ledger_view.dart';
import 'package:intl/intl.dart';

class LedgerTransferView extends StatefulWidget {
  const LedgerTransferView({Key? key}) : super(key: key);

  static const routeName = '/ledger_transfer';
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
  State<LedgerTransferView> createState() => _LedgerTransferViewState();
}

class _LedgerTransferViewState extends State<LedgerTransferView> {
  var dollar = "";

  var comment = "";

  @override
  Widget build(BuildContext context) {
    print(ModalRoute.of(context)?.settings.name);
    return Scaffold(
        appBar: AppBar(
          title: const Text("新增轉帳"),
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
                      padding: const EdgeInsets.only(top: 10, bottom: 0,left: 10, right: 10),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, LedgerEditView.routeName);
                  }),
                  const Text("交易" ,style: TextStyle(fontSize: 8)),
            ]),
          ],
        ),

        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                child: Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        keyboardType: TextInputType.number,

                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "0",
                          icon: Icon(Icons.attach_money, color:Colors.black),
                        ),
                      ),
                    ),
                    const Text("NTD"),
                  ],

                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("日期:", style: TextStyle(fontSize: 15)),
                  DatePicker()
                ],
              ),


              Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("轉出帳戶:", style: TextStyle(fontSize: 15)),
                      AccountPicker()
                    ],
                  )
              ),

              const Icon(Icons.arrow_downward, size: 40,),

              Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("轉入帳戶:", style: TextStyle(fontSize: 15)),
                      AccountPicker()
                    ],
                  )
              ),


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
                  )
              ),

              ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text("完成"),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: const BorderSide(color: Color(0x00ffd344))
                          )
                      )
                  )
              )
            ]
          ),
        )

    );
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
        onTap: () async{
          final newDate = await showDatePicker(
            context: context,
            initialDate: LedgerTransferView.date,
            firstDate: DateTime(DateTime.now().year - 5),
            lastDate: DateTime(DateTime.now().year + 1),
          );

          if (newDate == null) return;

          setState(() => LedgerTransferView.date = newDate);
        },
        child: Container(
          width: 260,
          color: const Color(0x1FF0D821),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.event),
              Text( DateFormat('MM / dd / yyyy').format(LedgerTransferView.date).toString(), style: const TextStyle(fontSize: 20)),
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
  _AccountPickerState(){
    LedgerTransferView.account = LedgerTransferView.accounts[0];
    LedgerTransferView.icon = LedgerTransferView.icons[0];
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
                  content: SizedBox(
                    width: double.minPositive,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: LedgerTransferView.accounts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(LedgerTransferView.accounts[index]),
                          leading: Icon(LedgerTransferView.icons[index]),
                          onTap: () {
                            setState(() {
                              LedgerTransferView.account = LedgerTransferView.accounts[index];
                              LedgerTransferView.icon = LedgerTransferView.icons[index];
                            });

                            Navigator.pop(context, LedgerTransferView.accounts[index]);

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
          color: const Color(0x1FF0D821),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:<Widget>[
              Icon(LedgerTransferView.icon),
              Text(LedgerTransferView.account),
              const Icon(Icons.expand_more),
            ],
          ),
        ),
      ),
    );
  }
}



