import 'package:flutter/material.dart';

import 'account.dart';
import '../helpers/db_helper.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

abstract class AccountProvider {
  Future<void> loadAccounts();

  List<Account> get getAccounts;

  Account getAccount(int accountId);

  Future<int> addAccount(Account account);

  Future<void> deleteAccount(int accountId);

  Future<void> updateAccount(int accountId, Account newAccount);
}

class DBAccountProvider implements AccountProvider {
  List<Account> _accounts = [];

  //This is only for init AccountProvider
  @override
  Future<void> loadAccounts() async {
    var db = await DBHelper.opendb();

    List<Map> rawAccounts = await db.query('accounts');

    _accounts = rawAccounts
        .map((mapobj) => Account(
              id: mapobj['id'],
              name: mapobj['name'],
              icon: IconData(mapobj['icon'], fontFamily: 'MaterialIcons'),
              iconColor: Color(mapobj['iconColor']),
            ))
        .toList();
  }

  @override
  List<Account> get getAccounts => _accounts;

  @override
  Account getAccount(int accountId) {
    assert(accountId >= 0, "accountId must >= 0");

    return _accounts.firstWhere((account) => account.id == accountId);
  }

  // When insert into database, id will be ignore and replaced, use getAccounts to get new list with new id
  @override
  Future<int> addAccount(Account account) async {
    FirebaseAnalytics.instance.logEvent(name: 'add_account', parameters: {});

    var db = await DBHelper.opendb();

    var accountMap = account.toMap();

    accountMap.remove('id');
    accountMap['icon'] = (accountMap['icon'] as IconData).codePoint;
    accountMap['iconColor'] = (accountMap['iconColor'] as Color).value;

    var recordid = await db.insert('accounts', accountMap);

    await loadAccounts();

    return recordid;
  }

  @override
  Future<void> deleteAccount(int accountId) async {
    FirebaseAnalytics.instance.logEvent(name: 'delete_account', parameters: {});
    var db = await DBHelper.opendb();

    await db.delete('accounts', where: 'id = ?', whereArgs: [accountId]);

    await loadAccounts();
  }

  @override
  Future<void> updateAccount(int accountId, Account newAccount) async {
    FirebaseAnalytics.instance.logEvent(name: 'update_account', parameters: {});
    var db = await DBHelper.opendb();

    var accountMap = newAccount.toMap();

    accountMap.remove('id');
    accountMap['icon'] = (accountMap['icon'] as IconData).codePoint;
    accountMap['iconColor'] = (accountMap['iconColor'] as Color).value;

    await db.update('accounts', accountMap,
        where: 'id = ?', whereArgs: [accountId]);

    await loadAccounts();
  }
}
