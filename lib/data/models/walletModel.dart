
import 'package:reachx_embed/domain/entities/walletEntity.dart';

class WalletModel extends WalletEntity{
  WalletModel({
    required super.walletBalance,
    required super.walletId,
    required super.currencySymbol
  });


  factory WalletModel.fromJson( Map<String, dynamic> json ) => WalletModel(
      walletId: json["walletId"] ?? '',
      walletBalance: (json["walletBalance"] as num).toDouble(),
      currencySymbol: json["currencySymbol"] ?? "₹"
  );


  Map<String, dynamic> toJson() => {
    "walletId": walletId,
    "walletBalance": walletBalance,
    "currencySymbol": currencySymbol
  };
}