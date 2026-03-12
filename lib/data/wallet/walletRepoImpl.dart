
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/getFromFireStore.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/saveInFirestore.dart';
import 'package:reachx_embed/data/models/transactionModel.dart';
import 'package:reachx_embed/data/models/userModel.dart';
import 'package:reachx_embed/data/models/walletModel.dart';
import 'package:reachx_embed/domain/entities/transactionEntity.dart';
import 'package:reachx_embed/domain/entities/walletEntity.dart';
import 'package:reachx_embed/domain/wallet/walletRepo.dart';

class WalletRepoImpl implements WalletRepo{

  final firebaseAuthentication = FirebaseAuthentication();
  final getFromFirestore = GetFromFirestore();
  final saveInFirestore = SaveInFirestore();

  @override
  Future<Results> registerWallet(WalletEntity walletEntity) {
    WalletModel walletModel = WalletModel(
        walletBalance: walletEntity.walletBalance,
        walletId: walletEntity.walletId,
        currencySymbol: walletEntity.currencySymbol
    );

    return saveInFirestore.saveWallet(walletModel);
  }


  @override
  Future<Results> fetchBalance() async {
    try {
      final userId = await FirebaseAuthentication().getFirebaseUid();

      if(userId != null) {
        final balanceFuture = getFromFirestore.getBalance(userId);
        final transactionsFuture = getFromFirestore.getProfileTransactionDetails();

        final results = await Future.wait([balanceFuture, transactionsFuture]);

        WalletModel walletModel = results[0] as WalletModel;

        WalletEntity walletEntity = WalletEntity(
            walletBalance: walletModel.walletBalance,
            walletId: walletModel.walletId,
            currencySymbol: walletModel.currencySymbol
        );

        TransactionsModel transactionsModel = results[1] as TransactionsModel;

        TransactionsEntity transactionsEntity = TransactionsEntity(
            transactions:  transactionsModel.transactions.map(
                    (transaction) => TransactionModel(
                    id: transaction.id,
                    amount: transaction.amount,
                    timestamp: transaction.timestamp,
                    type: transaction.type,
                    transactionIds: transaction.transactionIds,
                    bookingId: transaction.bookingId,
                    reachExCharge: transaction.reachExCharge,
                    paidByWallet: transaction.paidByWallet,
                    tokensSpent: transaction.tokensSpent,
                    productId: transaction.productId,
                    orderId: transaction.orderId,
                    invoiceId: transaction.invoiceId
                )
            ).toList()
        );


        return Results.success({
          "walletEntity": walletEntity,
          "transactions": transactionsEntity,
        });
      }
      return Results.error("Exception occurred");

    } catch (e) {
      print("Error in fetchBalance: $e");
      return Results.error("Exception occurred: $e");
    }
  }

  @override
  Future<Results> fetchCouponTokens(String couponId) async {
    Results results = await  getFromFirestore.getCouponTokens();

    if(results is SuccessState) {
      Map<String, dynamic> data = results.value;
      if(data[couponId] != null) {
        return Results.success(data[couponId]);
      }
      return Results.error('');
    }
    return Results.error('');
  }

  @override
  Future<Results> fetchUserName(String userId) async {
    UserModel userModel = await getFromFirestore.getUserDetails(userId);

    if(userModel.name.isNotEmpty) {
      return Results.success(userModel.name);
    }

    return Results.error('Not found');
  }

}