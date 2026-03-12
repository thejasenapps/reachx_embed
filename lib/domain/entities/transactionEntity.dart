
class TransactionEntity {
  final String id;
  String? payeeName;
  final String bookingId;
  double reachExCharge;
  final double amount;
  final List<String> transactionIds;
  final String type;
  final DateTime timestamp;
  final bool paidByWallet;
  final double tokensSpent;
  final String productId;
  final String orderId;
  final String invoiceId;

  TransactionEntity ({
    required this.id,
    required this.transactionIds,
    this.payeeName,
    required this.amount,
    required this.type,
    required this.timestamp,
    required this.reachExCharge,
    required this.bookingId,
    required this.paidByWallet,
    required this.tokensSpent,
    required this.orderId,
    required this.productId,
    required this.invoiceId
  });
}


class TransactionsEntity {
  List<TransactionEntity> transactions;

  TransactionsEntity({required this.transactions});
}