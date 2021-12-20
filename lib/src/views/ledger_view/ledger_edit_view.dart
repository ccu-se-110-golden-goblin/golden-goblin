import 'package:flutter/foundation.dart' hide Category;
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
import 'package:provider/provider.dart';

import '../../themes.dart';

class LedgerEditViewArgs {
  LedgerEditViewArgs({this.transaction});

  final Transaction? transaction;
}

class LedgerEditView extends StatefulWidget {
  const LedgerEditView({Key? key, required this.args}) : super(key: key);

  static const routeName = '/ledger_edit';
  final LedgerEditViewArgs args;

  @override
  State<LedgerEditView> createState() => _LedgerEditViewState(args: args);
}

class _LedgerEditViewState extends State<LedgerEditView>
    with SingleTickerProviderStateMixin {
  _LedgerEditViewState({required this.args});

  LedgerEditViewArgs args;

  final _formKey = GlobalKey<FormState>();
  var dollarController = TextEditingController();
  final commentController = TextEditingController();

  DateTime date = DateTime.now();
  Account? account;
  Type cateType = Type.expenses;
  Category? category;

  List<Account> accountList = [];
  List<Category> categoryList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);
    AccountProvider accountProvider = Provider.of<AccountProvider>(context);
    Future.wait(
      [categoryProvider.loadCategories(), accountProvider.loadAccounts()],
    ).then((value) {
      setState(() {
        accountList = accountProvider.getAccounts;
        categoryList = categoryProvider.getCategories;

        account = accountList.first;
        category =
            categoryList.where((element) => element.type == cateType).first;
      });
    });
  }

  void handleSave(TransactionProvider transactionProvider) {
    if (account != null && category != null) {
      var transaction = args.transaction;
      if (transaction != null) {
        transactionProvider
            .updateTransaction(
                transaction.id,
                Transaction(
                    id: transaction.id,
                    amount: int.parse(dollarController.text),
                    account: account!.id,
                    category: category!.id,
                    date: date,
                    remark: commentController.text))
            .then((value) => Navigator.pop(context));
      } else {
        transactionProvider
            .addTransaction(Transaction(
                id: 0,
                amount: int.parse(dollarController.text),
                account: account!.id,
                category: category!.id,
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
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error: account or category missing',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void handleDelete(TransactionProvider transactionProvider) {
    var transaction = args.transaction;

    if (transaction != null) {
      transactionProvider
          .deleteTransaction(transaction.id)
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
  }

  @override
  void dispose() {
    super.dispose();
    // Clean up the controller when the widget is disposed.
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);

    TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context);

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
        actions: (args.transaction == null)
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
              //account
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("帳戶:", style: TextStyle(fontSize: 15)),
                    AccountPicker(
                      accounts: accountList,
                      value: account,
                      callback: (Account _account) {
                        setState(() {
                          account = _account;
                        });
                      },
                    ),
                  ],
                ),
              ),
              //category
              Expanded(
                // padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text("類別:", style: TextStyle(fontSize: 15)),
                        const SizedBox(
                          width: 200,
                        ),
                        DropdownButton(
                          value: cateType,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          underline: Container(height: 2, color: Colors.amber),
                          items: Type.values.map((Type item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item == Type.expenses ? "支出" : "收入"),
                            );
                          }).toList(),
                          onChanged: (Type? v) {
                            if (v != null) {
                              setState(() {
                                cateType = v;
                                category = categoryList
                                    .where(
                                        (element) => element.type == cateType)
                                    .first;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    Expanded(
                      child: GridView.builder(
                          itemCount: categoryProvider.getCategories
                              .where((value) => value.type == cateType)
                              .length,
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (BuildContext context, int ind) {
                            Category filterCateItem = categoryProvider
                                .getCategories
                                .where((value) => value.type == cateType)
                                .elementAt(ind);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  category = filterCateItem;
                                });
                              },
                              child: _LedgerCategoryItem(
                                name: filterCateItem.name,
                                iconData: filterCateItem.iconData,
                                iconColor: filterCateItem.iconColor,
                                selected: category == filterCateItem,
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
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
                  TextButton(
                    onPressed: args.transaction == null
                        ? null
                        : () => handleDelete(transactionProvider),
                    child: const Text("刪除"),
                    style: GoldenGoblinThemes.dangerButtonLightStyle,
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        handleSave(transactionProvider);
                      }
                    },
                    child: const Text("完成"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

class _LedgerCategoryItem extends StatelessWidget {
  const _LedgerCategoryItem(
      {Key? key,
      required this.iconData,
      required this.name,
      required this.iconColor,
      this.onTap,
      required this.selected})
      : super(key: key);

  final IconData iconData;
  final Color iconColor;
  final String name;
  final GestureTapCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: selected
          ? const BoxDecoration(
              color: Color(0x6BD3CFBC),
              borderRadius: BorderRadius.all(Radius.circular(10)))
          : null,
      child: CategoryItem(
        iconData: iconData,
        iconColor: iconColor,
        name: name,
        onTap: onTap,
      ),
    );
  }
}
