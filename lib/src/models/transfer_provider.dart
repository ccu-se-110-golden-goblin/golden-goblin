import 'package:flutter/foundation.dart';

import 'transfer.dart';
import '../helpers/db_helper.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

abstract class TransferProvider {
  Future<List<Transfer>> getTransfers({
    List<int>? srcAccounts,
    List<int>? dstAccounts,
    DateTime? startDate,
    DateTime? endDate,
    int? offset,
    int? limit,
  });

  Future<int> addTransfer(Transfer transfer);

  Future<void> deleteTransfer(int transferId);

  Future<void> updateTransfer(int transferId, Transfer newTransfer);
}

class DBTransferProvider implements TransferProvider {
  @override
  Future<List<Transfer>> getTransfers({
    List<int>? srcAccounts,
    List<int>? dstAccounts,
    DateTime? startDate,
    DateTime? endDate,
    int? offset,
    int? limit,
  }) async {
    assert(offset == null || offset >= 0, "offset should be null or >= 0");
    assert(limit == null || limit >= 0, "limit should be null or >= 0");

    bool hasAddWhere = false;
    String queryString = "SELECT * FROM transfers";

    var db = await DBHelper.opendb();

    if (srcAccounts != null) {
      if (!hasAddWhere) {
        queryString += " WHERE";
        hasAddWhere = true;
      } else {
        queryString += " AND";
      }

      queryString += " src IN(";
      queryString += srcAccounts.join(',');
      queryString += ")";
    }

    if (dstAccounts != null) {
      if (!hasAddWhere) {
        queryString += " WHERE";
        hasAddWhere = true;
      } else {
        queryString += " AND";
      }

      queryString += " dst IN(";
      queryString += dstAccounts.join(',');
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
    List<Map> rawTransfers = await db.rawQuery(queryString);

    List<Transfer> transfers = rawTransfers
        .map((mapobj) => Transfer(
              id: mapobj['id'],
              amount: mapobj['amount'],
              src: mapobj['src'],
              dst: mapobj['dst'],
              date: DateTime.fromMillisecondsSinceEpoch(mapobj['date'] as int),
              remark: mapobj['remark'],
            ))
        .toList();

    return transfers;
  }

  // When insert into database, id will be ignore and replaced, use getAccounts to get new list with new id
  @override
  Future<int> addTransfer(Transfer transfer) async {
    FirebaseAnalytics.instance.logEvent(name: 'add_tranfer', parameters: {
      'transfer_amount': transfer.amount,
      'transfer_source': transfer.src,
      'transfer_destination': transfer.dst,
      'transfer_date': transfer.date,
    });
    var db = await DBHelper.opendb();

    var transferMap = transfer.toMap();
    transferMap.remove('id');
    transferMap['date'] =
        (transferMap['date'] as DateTime).millisecondsSinceEpoch;

    var recordid = await db.insert('transfers', transferMap);

    return recordid;
  }

  @override
  Future<void> deleteTransfer(int transferId) async {
    FirebaseAnalytics.instance.logEvent(name: 'delete_tranfer', parameters: {
      'transfer_id': transferId,
    });
    var db = await DBHelper.opendb();

    await db.delete('transfers', where: 'id = ?', whereArgs: [transferId]);
  }

  @override
  Future<void> updateTransfer(int transferId, Transfer newTransfer) async {
    FirebaseAnalytics.instance.logEvent(name: 'update_tranfer', parameters: {
      'old_transfer_id': transferId,
      'new_transfer_amount': newTransfer.amount,
      'new_transfer_source': newTransfer.src,
      'new_transfer_destination': newTransfer.dst,
      'new_transfer_date': newTransfer.date,
    });
    var db = await DBHelper.opendb();

    var transferMap = newTransfer.toMap();
    transferMap.remove('id');
    transferMap['date'] =
        (transferMap['date'] as DateTime).millisecondsSinceEpoch;

    await db.update('transfers', transferMap,
        where: 'id = ?', whereArgs: [transferId]);
  }
}
