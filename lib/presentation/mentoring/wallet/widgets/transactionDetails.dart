import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/domain/entities/transactionEntity.dart';
import 'package:reachx_embed/presentation/mentoring/wallet/walletViewModel.dart';

class TransactionDetails extends StatelessWidget {
  TransactionsEntity transactions;
  String currencySymbol;
  WalletViewModel walletViewModel;

  TransactionDetails({super.key, 
    required this.transactions,
    required this.currencySymbol,
    required this.walletViewModel
  });

  @override
  Widget build(BuildContext context) {
    // Wrap in Expanded so it fills available space if placed in a Column/Row
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        itemCount: transactions.transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions.transactions[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: ListTile(
              leading: Icon(
                  Icons.swap_horiz,
                  color: HexColor(lightBlue),
              ),
              title: Text(
                transaction.payeeName ?? 'Unknown',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                DateFormat.yMMMd().add_jm().format(transaction.timestamp),
                style: TextStyle(
                  color: HexColor(lightBlue),
                ),
              ),
              trailing: Text(
                walletViewModel.userId == transaction.transactionIds[0] ? '${transaction.amount}' : '${transaction.amount + transaction.reachExCharge}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: transaction.transactionIds[0] == walletViewModel.userId ? Colors.green : Colors.red,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}