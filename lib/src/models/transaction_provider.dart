import 'transaction.dart';

class TransactionProvider {
  List<Transaction> dummyTransactions = [
    Transaction(
      id: 0,
      amount: 100,
      account: 0,
      category: 0,
      date: DateTime(2021, 9, 22),
      remark: "我是備註",
    ),
    Transaction(
      id: 1,
      amount: 1200,
      account: 0,
      category: 0,
      date: DateTime(2021, 11, 3),
      invoice: "AA123456789",
    ),
    Transaction(
      id: 2,
      amount: 567,
      account: 1,
      category: 3,
      date: DateTime(2021, 11, 1),
    ),
    Transaction(
      id: 3,
      amount: 888,
      account: 0,
      category: 3,
      date: DateTime(2021, 12, 12),
      remark: "我也是備註的啦",
      invoice: "BB987654321",
    ),
    Transaction(
      id: 4,
      amount: 100,
      account: 0,
      category: 0,
      date: DateTime(2021, 9, 22),
    ),
  ];

  Future<List<Transaction>> getTransactions({
    List<int>? accounts,
    List<int>? categories,
    DateTime? startDate,
    DateTime? endDate,
    int? offset,
    int? limit,
  }) async {
    assert(offset == null || offset >= 0, "offset should be null or >= 0");
    assert(limit == null || limit >= 0, "limit should be null or >= 0");

    List<Transaction> transactions = dummyTransactions;

    if (accounts != null) {
      transactions
          .retainWhere((transaction) => accounts.contains(transaction.account));
    }

    if (categories != null) {
      transactions.retainWhere(
          (transaction) => categories.contains(transaction.category));
    }

    if (startDate != null) {
      transactions
          .retainWhere((transaction) => !transaction.date.isBefore(startDate));
    }

    if (endDate != null) {
      transactions
          .retainWhere((transaction) => !transaction.date.isAfter(endDate));
    }

    transactions.sort((t1, t2) => t1.date.isAfter(t2.date) ? -1 : 1);

    if (offset != null) {
      transactions = transactions.skip(offset).toList();
    }

    if (limit != null) {
      transactions = transactions.take(limit).toList();
    }

    await Future.delayed(const Duration(seconds: 3));

    return transactions;
  }

  // When insert into database, id will be ignore and replaced, use getAccounts to get new list with new id
  Future<void> addTransaction(Transaction transaction) async {
    dummyTransactions.add(transaction);

    await Future.delayed(const Duration(seconds: 3));
  }

  Future<void> deleteTransaction(int transactionId) async {
    dummyTransactions
        .removeWhere((transaction) => transaction.id == transactionId);

    await Future.delayed(const Duration(seconds: 3));
  }

  Future<void> updateTransaction(
      int transactionId, Transaction newTransaction) async {
    dummyTransactions
        .removeWhere((transaction) => transaction.id == transactionId);
    dummyTransactions.add(Transaction(
      id: transactionId,
      amount: newTransaction.amount,
      account: newTransaction.account,
      category: newTransaction.category,
      date: newTransaction.date,
      remark: newTransaction.remark,
      invoice: newTransaction.invoice,
    ));

    await Future.delayed(const Duration(seconds: 3));
  }
}
