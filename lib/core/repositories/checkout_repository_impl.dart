import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:e_commerce_app/core/domain/entities/transaction/transaction.dart';
import 'package:e_commerce_app/core/domain/entities/cart/cart.dart';
import 'package:e_commerce_app/core/domain/entities/account/account.dart';
import 'package:e_commerce_app/core/domain/repositories/checkout_repository.dart';
import 'package:e_commerce_app/utils/extension.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final firestore.CollectionReference collectionReference;
  CheckoutRepositoryImpl({required this.collectionReference});

  @override
  Future<void> pay({required Transaction data}) async {
    await collectionReference
        .doc(data.transactionId)
        .set(data.toJson(), firestore.SetOptions(merge: true));
  }

  @override
  Transaction startCheckout(
      {required List<Cart> cart, required Account account}) {
    double subTotal = 0;
    for (var element in cart) {
      subTotal += element.product!.productPrice * element.quantity;
    }

    double serviceFee = 15;

    double shippingFee = 20;

    Transaction temp = Transaction(
      transactionId: ''.generateUID(),
      accountId: account.accountId,
      purchasedProduct: cart,
      subTotal: subTotal,
      transactionStatus: TransactionStatus.gonderiliyor.value,
      totalPrice: subTotal,
      serviceFee: serviceFee,
      shippingFee: shippingFee,
    );

    return temp;
  }
}
