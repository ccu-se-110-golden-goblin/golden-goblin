import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:golden_goblin/src/models/account.dart';
import 'package:golden_goblin/src/models/account_provider.dart';
import 'package:golden_goblin/src/models/category_provider.dart';
import 'package:golden_goblin/src/models/category.dart';
import 'package:golden_goblin/src/models/transaction.dart';
import 'package:golden_goblin/src/models/transaction_provider.dart';
import 'package:golden_goblin/src/views/category_view/category_view.dart';
import 'package:golden_goblin/src/views/ledger_view/ledger_transfer.dart';
import 'package:intl/intl.dart';

import '../../themes.dart';

class LedgerEditView extends StatefulWidget {
  LedgerEditView({Key? key, required this.argsId}) : super(key: key);

  static const routeName = '/ledger_edit';
  final argsId;

  @override
  State<LedgerEditView> createState() => _LedgerEditViewState(args: argsId);
}

class _LedgerEditViewState extends State<LedgerEditView>
    with SingleTickerProviderStateMixin {
  _LedgerEditViewState({required this.args});

  final args;
  final _formKey = GlobalKey<FormState>();
  var dollarController = TextEditingController();
  final commentController = TextEditingController();

  var category = 0;
  static DateTime date = DateTime.now();
  static var account = 0;

  static var categories = [];
  Type cateType = Type.expenses;
  var cateTypeName = "支出";
  static var selectedCate = -1;

  void handleLoadData() {
    CategoryProvider().loadCategories().then((value) {
      setState(() {
        categories = CategoryProvider().getCategories;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    handleLoadData();
  }

  void handleSave() {
    if (args == -1) {
      TransactionProvider.addTransaction(Transaction(
              id: 0,
              amount: int.parse(dollarController.text),
              account: account,
              category: category,
              date: date,
              remark: commentController.text))
          .then((value) => Navigator.pop(context));

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
      TransactionProvider.updateTransaction(
              args,
              Transaction(
                  id: args,
                  amount: int.parse(dollarController.text),
                  account: account,
                  category: category,
                  date: date,
                  remark: commentController.text))
          .then((value) => Navigator.pop(context));
    }
  }

  void handleDelete() {
    TransactionProvider.deleteTransaction(args)
        .then((value) => Navigator.pop(context));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '已刪除交易',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFD344),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    commentController.dispose();
    super.dispose();
  }

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
          actions: (args == -1)
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
                                  context, LedgerTransferView.routeName);
                            }),
                        const Text("轉帳", style: TextStyle(fontSize: 8)),
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
                //dollar
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
                            hintText: "金額",
                            icon: Icon(Icons.attach_money, color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '請輸入金額';
                            }
                            return null;
                          },
                        ),
                      ),
                      const Text("NTD"),
                    ],
                  ),
                ),
                //date
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("日期:", style: TextStyle(fontSize: 15)),
                    DatePicker()
                  ],
                )),
                //account
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("帳戶:", style: TextStyle(fontSize: 15)),
                        AccountPicker()
                      ],
                    )),
                //category
                Expanded(
                    // padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text("類別:", style: TextStyle(fontSize: 15)),
                            const SizedBox(width: 200,),
                            DropdownButton(
                              value: cateTypeName,
                              icon: Icon(Icons.keyboard_arrow_down),
                              underline: Container(
                                  height: 2,
                                  color: Colors.amber),
                              items:["支出","收入"].map((String items) {
                                return DropdownMenuItem(
                                    value: items,
                                    child: Text(items)
                                );
                              }
                              ).toList(),
                              onChanged: (String? v){
                                setState(() {
                                  if(v! == "支出") {
                                    cateType = Type.expenses;
                                    cateTypeName = "支出";
                                  } else {
                                    cateType = Type.income;
                                    cateTypeName = "收入";
                                  }
                                });
                              },
                            ),
                          ],
                        ),

                        Expanded(
                          child: GridView.builder(
                            itemCount: categories.where((value) => value.type == cateType).length,
                            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                childAspectRatio: 0.7,),

                            itemBuilder: (BuildContext context, int ind){
                                  var filterCateItem = categories.where((value) => value.type == cateType).elementAt(ind);
                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        selectedCate = ind;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
                                      child: Container(
                                        decoration: (ind == selectedCate) ? const BoxDecoration(
                                            color: Color(0x6BD3CFBC),
                                            borderRadius: BorderRadius.all(Radius.circular(10))) : null,
                                        child: CategoryItem(
                                          id: ind,
                                          name: filterCateItem.name,
                                          iconData: filterCateItem.iconData,
                                          iconColor: filterCateItem.iconColor,
                                        ),
                                      ),
                                    ),
                                  );
                                }

                          ),

                        ),
                      ],
                    )),
                //comment
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
                    if (args != -1)
                      TextButton(
                        onPressed: handleDelete,
                        child: const Text("刪除",
                            style: TextStyle(color: Color(0xFFFF0000))),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.resolveWith(
                              (states) => const StadiumBorder()),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            handleSave();
                          }
                        },
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
              ],
            ),
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
            initialDate: _LedgerEditViewState.date,
            firstDate: DateTime(DateTime.now().year - 5),
            lastDate: DateTime(DateTime.now().year + 1),
          );

          if (newDate == null) return;

          setState(() => _LedgerEditViewState.date = newDate);
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
                      .format(_LedgerEditViewState.date)
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
  List<Account> accounts = [];
  var account;
  var icon;
  var iconColor;
  void handleLoadData() {
    AccountProvider().loadAccounts().then((value) {
      setState(() {
        accounts = AccountProvider().getAccounts;
        account = accounts[0].name;
        icon = accounts[0].icon;
        iconColor = accounts[0].iconColor;
        print(accounts);
      });
    });
  }

  @override
  void initState() {
    handleLoadData();
    super.initState();
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
                      itemCount: accounts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(accounts[index].name),
                          leading: Icon(
                            accounts[index].icon,
                            color: accounts[index].iconColor,
                          ),
                          onTap: () {
                            setState(() {
                              account = accounts[index].name;
                              icon = accounts[index].icon;
                              iconColor = accounts[index].iconColor;
                              _LedgerEditViewState.account = index;
                            });

                            Navigator.pop(context, accounts[index]);
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
              Icon(
                icon,
                color: iconColor,
              ),
              Text(account),
              Icon(Icons.expand_more),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  const CategoryIcon({Key? key, required this.iconData, required this.color})
      : super(key: key);

  final IconData iconData;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Icon(
        iconData,
        color: const Color(0xFFFFFFFF),
      ),
    );
  }
}
class CategoryItem extends StatefulWidget {
  const CategoryItem(
      {Key? key,
        required this.iconData,
        required this.name,
        required this.iconColor,
        required this.id})
      : super(key: key);

  final IconData iconData;
  final Color iconColor;
  final String name;
  final int id;

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child:
         Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CategoryIcon(
              iconData: widget.iconData,
              color: widget.iconColor,
            ),
            Text(widget.name),
          ],
        ),
    );
  }
}