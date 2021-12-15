import 'package:flutter/foundation.dart';

import 'transaction.dart';
import '../helpers/db_helper.dart';

class TransactionProvider {
  static Future<List<Transaction>> getTransactions({
    List<int>? accounts,
    List<int>? categories,
    DateTime? startDate,
    DateTime? endDate,
    int? offset,
    int? limit,
  }) async {
    assert(offset == null || offset >= 0, "offset should be null or >= 0");
    assert(limit == null || limit >= 0, "limit should be null or >= 0");

    bool hasAddWhere = false;
    String queryString = "SELECT * FROM transactions";

    var db = await DBHelper.opendb();

    if (accounts != null) {
      if (!hasAddWhere) {
        queryString += " WHERE";
        hasAddWhere = true;
      } else {
        queryString += " AND";
      }

      queryString += " account IN(";
      queryString += accounts.join(',');
      queryString += ")";
    }

    if (categories != null) {
      if (!hasAddWhere) {
        queryString += " WHERE";
        hasAddWhere = true;
      } else {
        queryString += " AND";
      }

      queryString += " category IN(";
      queryString += categories.join(',');
      queryString += ")";
    }

    if (startDate != null) {
      if (!hasAddWhere) {
        queryString += " WHERE";
        hasAddWhere = true;
      } else {
        queryString += " AND";
      }

      queryString += " date >= ${startDate.millisecondsSinceEpoch}";
    }

    if (endDate != null) {
      if (!hasAddWhere) {
        queryString += " WHERE";
        hasAddWhere = true;
      } else {
        queryString += " AND";
      }

      queryString += " date <= ${endDate.millisecondsSinceEpoch}";
    }

    queryString += " ORDER BY date DESC";

    if (limit != null) {
      queryString += " LIMIT $limit";
    } else {
      //without limit, offset is unusable
      queryString += " LIMIT -1";
    }

    if (offset != null) {
      queryString += " OFFSET $offset";
    }

    if (!kReleaseMode) {
      print("queryString = $queryString");
    }
    List<Map> rawTransactions = await db.rawQuery(queryString);

    List<Transaction> transactions = rawTransactions
        .map((mapobj) => Transaction(
              id: mapobj['id'],
              amount: mapobj['amount'],
              account: mapobj['account'],
              category: mapobj['category'],
              date: DateTime.fromMillisecondsSinceEpoch(mapobj['date'] as int),
              remark: mapobj['remark'],
              invoice: mapobj['invoice'],
            ))
        .toList();

    return transactions;
  }

  // When insert into database, id will be ignore and replaced, use getAccounts to get new list with new id
  static Future<int> addTransaction(Transaction transaction) async {
    var db = await DBHelper.opendb();

    var transactionMap = transaction.toMap();
    transactionMap.remove('id');
    transactionMap['date'] =
        (transactionMap['date'] as DateTime).millisecondsSinceEpoch;

    var recordid = await db.insert('transactions', transactionMap);

    return recordid;
  }

  static Future<void> deleteTransaction(int transactionId) async {
    var db = await DBHelper.opendb();

    await db
        .delete('transactions', where: 'id = ?', whereArgs: [transactionId]);
  }

  static Future<void> updateTransaction(
      int transactionId, Transaction newTransaction) async {
    var db = await DBHelper.opendb();

    var transactionMap = newTransaction.toMap();
    transactionMap.remove('id');
    transactionMap['date'] =
        (transactionMap['date'] as DateTime).millisecondsSinceEpoch;

    await db.update('transactions', transactionMap,
        where: 'id = ?', whereArgs: [transactionId]);
  }
}
