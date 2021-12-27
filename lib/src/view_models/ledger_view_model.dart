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
import 'package:provider/provider.dart';

class LedgerViewModel {
  // CategoryProvider category;
  // Future<List<List<dynamic>> getData() async

  DateTime now;
  DateTime _startOfMonth;
  DateTime _endOfMonth;

  // Providers
  late final TransferProvider _transferProvider;
  late final TransactionProvider _transactionProvider;
  late final AccountProvider _accountProvider;
  late final CategoryProvider _categoryProvider;

  LedgerViewModel({
    required this.now,
  })  : _startOfMonth = now,
        _endOfMonth = now;

  void initProviders(BuildContext context) {
    _transferProvider = Provider.of<TransferProvider>(context);
    _transactionProvider = Provider.of<TransactionProvider>(context);
    _accountProvider = Provider.of<AccountProvider>(context);
    _categoryProvider = Provider.of<CategoryProvider>(context);
  }

  // color List
  static const List<Color> _colorList = [
    Color(0x80CBD7A4), // green, imcome
    Color(0x4DFEC81A), // yellow, expense
    Color(0x8099D6EA) // blue , transfer
  ];

  // iconList
  static const List<IconData> _iconList = [
    Icons.wifi_protected_setup, // transfer Icon
    Icons.restaurant,
    Icons.apartment
  ];

  // init or change month
  void setDate(DateTime setDate) {
    _startOfMonth = DateTime(setDate.year, setDate.month, 1);

    _endOfMonth = (setDate.month < 12)
        ? DateTime(setDate.year, setDate.month + 1, 0, 23, 59, 59, 999, 999)
        : DateTime(setDate.year + 1, 1, 0, 23, 59, 59, 999, 999);

    // DEBUG
    if (!kReleaseMode) {
      print("setTime : $now");
      print("Start of month : $_startOfMonth");
      print("End of month : $_endOfMonth");
    }
  }

  // need to setDate before use
  Future<List<DailyListData>>? getDailyLists() async {
    final transfer = await _transferProvider.getTransfers(
        startDate: _startOfMonth, endDate: _endOfMonth);
    final transaction = await _transactionProvider.getTransactions(
        startDate: _startOfMonth, endDate: _endOfMonth);

    // init category
    await _categoryProvider.loadCategories();
    await _accountProvider.loadAccounts();

    // Prepare ItemTitleData
    Map<DateTime, List<ItemTitleData>> itemLists = {};
    List<DailyListData> dailyLists = [];

    // setup transactionData
    for (var transactionData in transaction) {
      Account account = _accountProvider.getAccount(transactionData.account);
      String title =
          _categoryProvider.getCategory(transactionData.category).name;
      Category category =
          _categoryProvider.getCategory(transactionData.category);
      Color color =
          (category.type == Type.income) ? _colorList[0] : _colorList[1];
      DateTime index = DateTime(transactionData.date.year,
          transactionData.date.month, transactionData.date.day);
      ItemTitleData itemTile = ItemTitleData(
          id: transactionData.id,
          icon: category.iconData,
          title: title,
          amount: transactionData.amount,
          color: color,
          remark: transactionData.remark,
          type: category.type);
      if (itemLists[index] == null) {
        itemLists[index] = [];
      }
      itemLists[index]!.add(itemTile);
    }

    // setup transferData
    for (var transferData in transfer) {
      Account srcAccount = _accountProvider.getAccount(transferData.src);
      Account dstAccount = _accountProvider.getAccount(transferData.dst);
      DateTime index = DateTime(transferData.date.year, transferData.date.month,
          transferData.date.day);
      ItemTitleData itemTile = ItemTitleData(
          id: transferData.id,
          icon: _iconList[0], // transferIcon
          title: srcAccount.name,
          amount: transferData.amount,
          color: _colorList[2], // transfer color
          title2: dstAccount.name,
          remark: transferData.remark);
      if (itemLists[index] == null) {
        itemLists[index] = [];
      }
      itemLists[index]!.add(itemTile);
    }

    // put into DailyListData
    int dailyCounter = 0;
    for (DateTime i =
            DateTime(_endOfMonth.year, _endOfMonth.month, _endOfMonth.day);
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
  Future<void> addMock() async {
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
    Category categoryA = Category(
        id: 1,
        name: "TestIncoming",
        type: Type.income,
        iconData: Icons.apartment);
    Category categoryB = Category(
        id: 2,
        name: "TestExpenses",
        type: Type.expenses,
        iconData: Icons.restaurant);

    var accountAId = await _accountProvider.addAccount(accountA);
    var accountBId = await _accountProvider.addAccount(accountB);
    var categoryAId = await _categoryProvider.addCategory(categoryA);
    var categoryBId = await _categoryProvider.addCategory(categoryB);

    Transfer transferA = Transfer(
        id: 0, src: accountAId, dst: accountBId, amount: 300, date: dayA);
    Transfer transferB = Transfer(
        id: 1, src: accountBId, dst: accountAId, amount: 500, date: dayB);
    Transaction transactionA = Transaction(
        id: 0,
        amount: 1000,
        account: accountAId,
        category: categoryAId,
        date: dayA);
    Transaction transactionB = Transaction(
        id: 1,
        amount: 1500,
        account: accountAId,
        category: categoryBId,
        date: dayB);

    await _transferProvider.addTransfer(transferA);
    await _transferProvider.addTransfer(transferB);
    await _transactionProvider.addTransaction(transactionA);
    await _transactionProvider.addTransaction(transactionB);
  }
}

// connect with itemTitleData in view
class ItemTitleData {
  const ItemTitleData(
      {required this.id,
      required this.icon,
      required this.title,
      required this.amount,
      required this.color,
      this.title2,
      this.remark,
      this.type});

  final int id; // id is transferID or transactionID
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
