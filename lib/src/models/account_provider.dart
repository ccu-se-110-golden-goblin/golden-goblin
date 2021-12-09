import 'package:flutter/material.dart';

import 'account.dart';

class AccountProvider {
  List<Account> _accounts = [];

  //This is only for init AccountProvider
  Future<void> loadAccounts() async {
    //TODO: Fetch from DB
    //mock data
    _accounts = [
      Account(
        id: 0,
        name: "Account 1",
        icon: Icons.face_retouching_natural,
        iconColor: Colors.blue,
      ),
      Account(
        id: 1,
        name: "Account 2",
        icon: Icons.hail,
        iconColor: Colors.orange,
      ),
    ];
  }

  List<Account> get getAccounts => _accounts;

  Account getAccount(int accountId) {
    assert(accountId >= 0, "accountId must >= 0");

    return _accounts.firstWhere((account) => account.id == accountId);
  }

  // When insert into database, id will be ignore and replaced, use getAccounts to get new list with new id
  Future<void> addAccount(Account account) async {
    //TODO: Add and reload from DB
    //mock operation
    _accounts.add(Account(
      id: _accounts.last.id + 1,
      name: account.name,
      icon: account.icon,
      iconColor: account.iconColor,
    ));

    await Future.delayed(const Duration(seconds: 3));
  }

  Future<void> deleteAccount(int accountId) async {
    //TODO: delete and reload from DB
    //mock operation
    _accounts.removeWhere((account) => account.id == accountId);

    await Future.delayed(const Duration(seconds: 3));
  }

  Future<void> updateAccount(int accountId, Account newAccount) async {
    //TODO: update and reload from DB
    //mock operation
    _accounts.removeWhere((account) => account.id == accountId);
    _accounts.add(Account(
      id: accountId,
      name: newAccount.name,
      icon: newAccount.icon,
      iconColor: newAccount.iconColor,
    ));

    await Future.delayed(const Duration(seconds: 3));
  }
}
