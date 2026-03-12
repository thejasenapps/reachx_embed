class WalletEntity {
  final String walletId;
  final double walletBalance;
  final String currencySymbol;

  WalletEntity({
    required this.walletBalance,
    required this.walletId,
    required this.currencySymbol
  });
}