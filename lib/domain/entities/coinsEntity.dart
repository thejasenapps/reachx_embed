class CoinsEntity {
  String? userId;
  int? totalBalance;
  int currentBalance;

  CoinsEntity({
    this.userId,
    required this.currentBalance,
    this.totalBalance
  });
}