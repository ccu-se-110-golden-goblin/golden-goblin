import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LedgerEditView extends StatelessWidget {
  const LedgerEditView({Key? key}) : super(key: key);

  static const routeName = '/ledger_edit';

  @override
  Widget build(BuildContext context) {
    print(ModalRoute.of(context)?.settings.name);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ledger Edit"),
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
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(icon: const Icon(Icons.transform), onPressed: () {}),
                // Text("轉帳" ,style: TextStyle(fontSize: 8)),
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

            Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("日期:", style: TextStyle(fontSize: 15)),
                    DatePicker()
                  ],
                )
            ),


            Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("帳戶:", style: TextStyle(fontSize: 15)),
                    AccountPicker()
                  ],
                )
            ),

            Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                      Text("類別:", style: TextStyle(fontSize: 15)),
                  ],
                )
            ),

            Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("註解:", style: TextStyle(fontSize: 15)),

                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: "無",
                      ),
                    ),

                  ],
                )
            ),

          ElevatedButton(
              onPressed: (){},
              child: const Text("完成"),
              style: ButtonStyle(

                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Color(0xFFD344))
                      )
                  )
              )
          )
          ],
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
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () async{
          final newDate = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(DateTime.now().year - 5),
            lastDate: DateTime(DateTime.now().year + 1),
          );

          if (newDate == null) return;

          setState(() => date = newDate);
        },
        child: Container(
          width: 260,
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 2)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.event),
              Text( DateFormat('MM / dd / yyyy').format(date).toString(), style: TextStyle(fontSize: 25)),
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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {}, //TODO: expand account
        child: Container(
          width: 260,
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 2)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const <Widget>[
              Icon(Icons.account_balance_wallet_outlined),
              Text("帳戶"),
              Icon(Icons.expand_more),
            ],
          ),
        ),
      ),
    );
  }
}



