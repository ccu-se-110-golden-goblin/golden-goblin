class Transfer {
  // basic props
  final int id;
  final int src;
  final int dst;
  final int amount;
  final DateTime date;

  // optional props(nullable)
  final String? remark;

  // construct
  Transfer({
    required this.id,
    required this.src,
    required this.dst,
    required this.amount,
    required this.date,
    this.remark,
  });

  // DEBUG ONLY: Convert a Transaction into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'src': src,
      'dst': dst,
      'amount': amount,
      'date': date,
      'remark': remark,
    };
  }

  // Implement toString to make Transfer easier to use the print statement.
  @override
  String toString() {
    return 'Transfer{id: $id, src: $src, dst: $dst, amount: $amount, date: $date, remark: $remark}';
  }
}
