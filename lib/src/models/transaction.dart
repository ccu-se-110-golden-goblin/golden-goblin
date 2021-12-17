class Transaction {
  // basic props
  final int id;
  final int amount;
  final int account;
  final int category;
  final DateTime date;

  // optional props(nullable)
  final String? remark;
  final String? invoice;

  // construct
  Transaction({
    required this.id,
    required this.amount,
    required this.account,
    required this.category,
    required this.date,
    this.remark,
    this.invoice,
  });

  // DEBUG ONLY: Convert a Transaction into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'account': account,
      'category': category,
      'date': date,
      'remark': remark,
      'invoice': invoice,
    };
  }

  // Implement toString to make Transaction easier to use the print statement.
  @override
  String toString() {
    return 'Transaction{id: $id, amount: $amount, book: $account, category: $category, date: $date, remark: $remark, invoice: $invoice}';
  }
}
