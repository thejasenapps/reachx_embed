
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reachx_embed/domain/entities/transactionEntity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.id,
    required super.amount,
    required super.timestamp,
    required super.type,
    required super.transactionIds,
    required super.bookingId,
    required super.reachExCharge,
    required super.paidByWallet,
    required super.tokensSpent,
    required super.orderId,
    required super.productId,
    required super.invoiceId,
    super.payeeName
  });
  
  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
      id: json["id"], 
      transactionIds: (json["transactionIds"] as List<dynamic>).map((id) => id as String).toList(),
      amount: json["amount"], 
      timestamp:  (json["timestamp"] as Timestamp).toDate(),
      type: json["type"],
      bookingId: json["bookingId"],
      reachExCharge: json["reachExCharge"],
      paidByWallet: json["paidByWallet"] ?? false,
      tokensSpent: json["tokensSpent"] ?? 0,
      productId: json["productId"] ?? '',
      orderId: json["orderId"] ?? '',
      invoiceId: json["invoiceId"] ?? ''
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "transactionIds": transactionIds,
    "amount": amount,
    "timestamp": timestamp,
    "type": type,
    "bookingId": bookingId,
    "reachExCharge": reachExCharge,
    "paidByWallet": paidByWallet,
    "tokensSpent": tokensSpent,
    "productId": productId,
    "orderId": orderId,
    "invoiceId": invoiceId
  };
}


class TransactionsModel extends TransactionsEntity {
  TransactionsModel ({required super.transactions});

  factory TransactionsModel.fromRawJson(dynamic str) => TransactionsModel.fromJson(str);

  factory TransactionsModel.fromJson(List<QueryDocumentSnapshot> json) => TransactionsModel(
      transactions: List<TransactionModel>.from(json.map((x) => TransactionModel.fromJson(x.data() as Map<String, dynamic>)))
  );
}