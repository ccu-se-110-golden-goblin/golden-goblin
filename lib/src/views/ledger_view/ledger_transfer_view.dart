import 'package:flutter/material.dart';
import 'package:golden_goblin/src/models/account.dart';
import 'package:golden_goblin/src/models/account_provider.dart';
import 'package:golden_goblin/src/models/transfer.dart';
import 'package:golden_goblin/src/models/transfer_provider.dart';
import 'package:golden_goblin/src/views/ledger_view/ledger_edit_view.dart';
import 'package:golden_goblin/src/views/ledger_view/ledger_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../themes.dart';

class LedgerTransferViewArgs {
  LedgerTransferViewArgs({this.transfer});

  static TransferProvider provider = DBTransferProvider();

  static Future<LedgerTransferViewArgs> getFromId(int id) async {
    var allTransfer = await provider.getTransfers();

    return LedgerTransferViewArgs(
      transfer: allTransfer.where((element) => element.id == id).first,
    );
  }

  final Transfer? transfer;
}

class LedgerTransferView extends StatefulWidget {
  const LedgerTransferView({Key? key, required this.args}) : super(key: key);

  final LedgerTransferViewArgs args;
  static const routeName = '/ledger_transfer';

  @override
  State<LedgerTransferView> createState() =>
      _LedgerTransferViewState(args: args);
}

class _LedgerTransferViewState extends State<LedgerTransferView> {
  _LedgerTransferViewState({required this.args});

  List<Account> accountList = [];
  Account? accountDst;
  Account? accountSrc;
  DateTime date = DateTime.now();

  LedgerTransferViewArgs args;
  final _formKey = GlobalKey<FormState>();
  var dollarController = TextEditingController();
  final commentController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AccountProvider accountProvider = Provider.of<AccountProvider>(context);
    Future.wait(
      [accountProvider.loadAccounts()],
    ).then((value) {
      setState(() {
        accountList = accountProvider.getAccounts;

        if (args.transfer != null) {
          accountSrc = accountList
              .where((element) => element.id == args.transfer!.src)
              .first;
          accountDst = accountList
              .where((element) => element.id == args.transfer!.dst)
              .first;

          date = args.transfer!.date;

          dollarController.text = "${args.transfer!.amount}";
          commentController.text = args.transfer!.remark ?? "";
        } else {
          accountSrc = accountList.first;
          accountDst = accountList.last;
        }
      });
    });
  }

  void returnHomePage() {
    Navigator.pop(context);
    Navigator.restorablePushReplacementNamed(context, LedgerView.routeName);
  }

  void handleSave(TransferProvider transferProvider) {
    if (accountSrc == null || accountDst == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error: account or category missing',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (accountSrc!.id == accountDst!.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '轉入、轉出帳戶不能相同',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (args.transfer == null) {
      transferProvider
          .addTransfer(Transfer(
              id: 0,
              src: accountSrc!.id,
              dst: accountDst!.id,
              amount: int.parse(dollarController.text),
              date: date,
              remark: commentController.text))
          .then((value) => returnHomePage());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '已新增交易',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color(0xFFFFD344),
        ),
      );
    } else {
      transferProvider
          .updateTransfer(
              args.transfer!.id,
              Transfer(
                  id: args.transfer!.id,
                  src: accountSrc!.id,
                  dst: accountDst!.id,
                  amount: int.parse(dollarController.text),
                  date: date,
                  remark: commentController.text))
          .then((value) => returnHomePage());
    }
  }

  void handleDelete(TransferProvider transferProvider) {
    if (args.transfer != null) {
      transferProvider.deleteTransfer(args.transfer!.id);
    }
  }

  @override
  void dispose() {
    super.dispose();
    // Clean up the controller when the widget is disposed.
    commentController.dispose();
    dollarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TransferProvider transferProvider = Provider.of<TransferProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("新增轉帳"),
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                returnHomePage();
              },
            );
          }),
          actions: (args.transfer == null)
              ? <Widget>[
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
                                  context, LedgerEditView.routeName,
                                  arguments: LedgerEditViewArgs());
                            }),
                        const Text("交易", style: TextStyle(fontSize: 8)),
                      ]),
                ]
              : null,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
          child: Form(
            key: _formKey,
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
                              controller: dollarController,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: "0",
                                icon: Icon(Icons.attach_money,
                                    color: Colors.black),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '請輸入金額';
                                }
                                return null;
                              }),
                        ),
                        const Text("NTD"),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("日期:", style: TextStyle(fontSize: 15)),
                      DatePicker(
                        initialDate: date,
                        onUpdate: (DateTime? newDate) {
                          if (newDate != null) {
                            setState(() {
                              date = newDate;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("轉出帳戶:", style: TextStyle(fontSize: 15)),
                          AccountPicker(
                            accounts: accountList,
                            value: accountSrc,
                            callback: (Account _account) {
                              setState(() {
                                accountSrc = _account;
                              });
                            },
                          ),
                        ],
                      )),
                  const Icon(
                    Icons.arrow_downward,
                    size: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("轉入帳戶:", style: TextStyle(fontSize: 15)),
                      AccountPicker(
                        accounts: accountList,
                        value: accountDst,
                        callback: (Account _account) {
                          setState(() {
                            accountDst = _account;
                          });
                        },
                      ),
                    ],
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("註解:", style: TextStyle(fontSize: 15)),
                          TextFormField(
                            controller: commentController,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: "無",
                            ),
                          ),
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (args.transfer != null)
                        TextButton(
                          onPressed: () => handleDelete(transferProvider),
                          child: const Text("刪除"),
                          style: GoldenGoblinThemes.dangerButtonLightStyle,
                        ),
                      TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            handleSave(transferProvider);
                          }
                        },
                        child: const Text("完成"),
                      ),
                    ],
                  ),
                ]),
          ),
        ));
  }
}

typedef _DatePickerUpdateCallback = void Function(DateTime? dateTime);

class DatePicker extends StatelessWidget {
  const DatePicker(
      {Key? key, required this.onUpdate, required this.initialDate})
      : super(key: key);

  final _DatePickerUpdateCallback onUpdate;
  final DateTime initialDate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: initialDate,
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
            },
          ).then((value) => onUpdate(value));
        },
        child: Container(
          width: 260,
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          color: const Color(0x1FF0D821),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.event),
              Text(DateFormat('MM / dd / yyyy').format(initialDate).toString(),
                  style: const TextStyle(fontSize: 20)),
              const Icon(Icons.expand_more),
            ],
          ),
        ),
      ),
    );
  }
}

typedef _AccountPickerUpdateCallback = void Function(Account dateTime);

class AccountPicker extends StatelessWidget {
  const AccountPicker(
      {Key? key,
      required this.value,
      required this.accounts,
      required this.callback})
      : super(key: key);

  final List<Account> accounts;
  final Account? value;
  final _AccountPickerUpdateCallback callback;

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
                      itemCount: accounts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(accounts[index].name),
                          leading: Icon(
                            accounts[index].icon,
                            color: accounts[index].iconColor,
                          ),
                          onTap: () {
                            Navigator.pop(context, accounts[index]);
                            callback(accounts[index]);
                          },
                        );
                      },
                    ),
                  ),
                );
              });
        },
        child: Container(
          width: 260,
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          color: const Color(0x1FF0D821),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: value != null
                ? [
                    Icon(
                      value!.icon,
                      color: value!.iconColor,
                    ),
                    Text(value!.name),
                    const Icon(Icons.expand_more),
                  ]
                : [],
          ),
        ),
      ),
    );
  }
}
