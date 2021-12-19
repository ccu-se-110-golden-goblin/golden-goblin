import 'dart:async';

import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';

import 'package:golden_goblin/src/models/account.dart';
import 'package:golden_goblin/src/models/account_provider.dart';

import 'package:golden_goblin/src/models/transaction.dart';
import 'package:golden_goblin/src/models/category_provider.dart';

import 'package:golden_goblin/src/models/transaction_provider.dart';
import 'package:golden_goblin/src/models/transfer_provider.dart';

import 'package:golden_goblin/src/models/category.dart';
import 'package:golden_goblin/src/models/transfer.dart';

class LedgerViewModel {
  // CategoryProvider category;
  // Future<List<List<dynamic>> getData() async

  DateTime now;
  DateTime _startOfMonth;
  DateTime _endOfMonth;

  LedgerViewModel({required this.now})
      : _startOfMonth = now,
        _endOfMonth = now;

  // color List
  static const List<Color> _colorList = [
    Color(0x4DFEC81A), // yellow
    Color(0x8099D6EA), // blue
    Color(0x80CBD7A4) // green
  ];

  // iconList
  static const List<IconData> _iconList = [
    Icons.restaurant,
    Icons.wifi_protected_setup,
    Icons.apartment
  ];

  // init or change month
  void setDate(DateTime setDate) {
    final now = DateTime.now();

    _startOfMonth = DateTime(setDate.year, setDate.month, 1);

    if ((setDate.month == now.month) && (setDate.year == now.year)) {
      // if is current
      _endOfMonth = DateTime(now.year, now.month, now.day, 0, 0, 0);
    } else {
      // Find the last day of the month.
      _endOfMonth = (setDate.month < 12)
          ? DateTime(setDate.year, setDate.month + 1, 0)
          : DateTime(setDate.year + 1, 1, 0);
    }

    // DEBUG
    if (!kReleaseMode) {
      print("setTime : $now");
      print("Start of month : $_startOfMonth");
      print("End of month : $_endOfMonth");
    }
  }

  // need to setDate before use
  Future<List<DailyListData>>? getDailyLists() async {
    final transfer = await TransferProvider.getTransfers(
        startDate: _startOfMonth, endDate: _endOfMonth);
    final transaction = await TransactionProvider.getTransactions(
        startDate: _startOfMonth, endDate: _endOfMonth);

    // init category
    CategoryProvider categoryProvider = CategoryProvider();
    AccountProvider accountProvider = AccountProvider();
    await categoryProvider.loadCategories();
    await accountProvider.loadAccounts();

    // Prepare ItemTitleData
    Map<DateTime, List<ItemTitleData>> itemLists = {};
    List<DailyListData> dailyLists = [];

    // setup transactionData
    for (var transactionData in transaction) {
      Account account = accountProvider.getAccount(transactionData.account);
      String title =
          categoryProvider.getCategory(transactionData.category).name;
      Type type = categoryProvider.getCategory(transactionData.category).type;
      ItemTitleData itemTile = ItemTitleData(
          icon: _iconList[0],
          title: title,
          amount: transactionData.amount,
          color: _colorList[0],
          remark: transactionData.remark,
          type: type);
      if (itemLists[transactionData.date] == null) {
        itemLists[transactionData.date] = [];
      }
      itemLists[transactionData.date]!.add(itemTile);
    }

    // setup transferData
    for (var transferData in transfer) {
      Account srcAccount = accountProvider.getAccount(transferData.src);
      Account dstAccount = accountProvider.getAccount(transferData.dst);
      ItemTitleData itemTile = ItemTitleData(
          icon: _iconList[0],
          title: srcAccount.name,
          amount: transferData.amount,
          color: _colorList[0],
          title2: dstAccount.name,
          remark: transferData.remark);
      if (itemLists[transferData.date] == null) {
        itemLists[transferData.date] = [];
      }
      itemLists[transferData.date]!.add(itemTile);
    }

    // put into DailyListData
    int dailyCounter = 0;
    for (DateTime i = _endOfMonth;
        !i.isBefore(_startOfMonth);
        i = i.subtract(const Duration(days: 1))) {
      var dailyItemLists = itemLists[i];
      if (dailyItemLists == null) continue;
      if (dailyItemLists.isNotEmpty) {
        dailyLists.add(
            DailyListData(inputDate: i, inputItemTitleList: dailyItemLists));
        // calculate daily incoming and outgoing
        for (var x in dailyLists[dailyCounter].itemTitleList) {
          if (x.type == null) {
            continue;
          }
          if (x.type == Type.income) {
            dailyLists[dailyCounter].totalIncoming += x.amount;
          }
          if (x.type == Type.expenses) {
            dailyLists[dailyCounter].totalExpense += x.amount;
          }
        }
        dailyCounter++;
      }
    }

    return dailyLists;
  }

  // MockData for debug Only
  void addMock() async {
    if (kReleaseMode) return;
    var now = DateTime.now();
    var dayA = DateTime(now.year, now.month, now.day);
    var dayB = DateTime(now.year, now.month, now.day - 2);
    const Color colorA = Color(0x4DFEC81A);
    const Color colorB = Color(0x8099D6EA);
    Account accountA = Account(
        id: 0,
        name: "AccountA",
        icon: Icons.equalizer_rounded,
        iconColor: colorA);
    Account accountB = Account(
        id: 1, name: "AccountB", icon: Icons.wifi_lock, iconColor: colorB);
    Category categoryA =
        Category(id: 1, name: "TestIncoming", type: Type.income);
    Category categoryB =
        Category(id: 2, name: "TestExpenses", type: Type.expenses);
    Transfer transferA =
        Transfer(id: 0, src: 1, dst: 2, amount: 300, date: dayA);
    Transfer transferB =
        Transfer(id: 1, src: 2, dst: 1, amount: 500, date: dayB);
    Transaction transactionA =
        Transaction(id: 0, amount: 1000, account: 1, category: 1, date: dayA);
    Transaction transactionB =
        Transaction(id: 1, amount: 1500, account: 1, category: 2, date: dayB);

    AccountProvider accountProvider = AccountProvider();
    CategoryProvider categoryProvider = CategoryProvider();

    await accountProvider.addAccount(accountA);
    await accountProvider.addAccount(accountB);
    await categoryProvider.addCategory(categoryA);
    await categoryProvider.addCategory(categoryB);
    await TransferProvider.addTransfer(transferA);
    await TransferProvider.addTransfer(transferB);
    await TransactionProvider.addTransaction(transactionA);
    await TransactionProvider.addTransaction(transactionB);
  }
}

// connect with itemTitleData in view
class ItemTitleData {
  const ItemTitleData(
      {required this.icon,
      required this.title,
      required this.amount,
      required this.color,
      this.title2,
      this.remark,
      this.type});

  final IconData icon;
  final String title;
  final String? title2;
  final int amount;
  final String? remark;
  final Color color;
  final Type? type;
}

// connect with itemTitleData in view(include ItemTitleData in a day)
class DailyListData {
  DateTime date;
  int totalIncoming;
  int totalExpense;

  List<ItemTitleData> itemTitleList;

  DailyListData(
      {required DateTime inputDate,
      required List<ItemTitleData> inputItemTitleList})
      : date = inputDate,
        itemTitleList = inputItemTitleList,
        totalIncoming = 0,
        totalExpense = 0;
}
