import 'transfer.dart';

class TransferProvider {
  List<Transfer> dummyTransfers = [
    Transfer(
      id: 0,
      src: 0,
      dst: 1,
      amount: 100,
      date: DateTime(2021, 9, 22),
    ),
  ];

  Future<List<Transfer>> getTransfers({
    int? account,
    DateTime? startDate,
    DateTime? endDate,
    int? offset,
    int? limit,
  }) async {
    assert(offset == null || offset >= 0, "offset should be null or >= 0");
    assert(limit == null || limit >= 0, "limit should be null or >= 0");

    List<Transfer> transfers = dummyTransfers;

    if (account != null) {
      transfers.retainWhere(
          (transfer) => transfer.src == account || transfer.dst == account);
    }

    if (startDate != null) {
      transfers.retainWhere((transfer) => !transfer.date.isBefore(startDate));
    }

    if (endDate != null) {
      transfers.retainWhere((transfer) => !transfer.date.isAfter(endDate));
    }

    transfers.sort((t1, t2) => t1.date.isAfter(t2.date) ? -1 : 1);

    if (offset != null) {
      transfers = transfers.skip(offset).toList();
    }

    if (limit != null) {
      transfers = transfers.take(limit).toList();
    }

    await Future.delayed(const Duration(seconds: 3));

    return transfers;
  }

  // When insert into database, id will be ignore and replaced, use getAccounts to get new list with new id
  Future<void> addTransfer(Transfer transfer) async {
    dummyTransfers.add(transfer);

    await Future.delayed(const Duration(seconds: 3));
  }

  Future<void> deleteTransfer(int transferId) async {
    dummyTransfers.removeWhere((transfer) => transfer.id == transferId);

    await Future.delayed(const Duration(seconds: 3));
  }

  Future<void> updateTransfer(int transferId, Transfer newTransfer) async {
    dummyTransfers.removeWhere((transfer) => transfer.id == transferId);
    dummyTransfers.add(Transfer(
      id: transferId,
      src: newTransfer.src,
      dst: newTransfer.dst,
      amount: newTransfer.amount,
      date: newTransfer.date,
      remark: newTransfer.remark,
    ));

    await Future.delayed(const Duration(seconds: 3));
  }
}
