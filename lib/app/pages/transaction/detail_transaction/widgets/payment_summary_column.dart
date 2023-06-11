import 'package:e_commerce_app/app/pages/transaction/detail_transaction/widgets/selected_payment_method.dart';
import 'package:e_commerce_app/core/domain/entities/payment_method/payment_method.dart';
import 'package:e_commerce_app/utils/extension.dart';
import 'package:flutter/material.dart';

class PaymentSummaryColumn extends StatelessWidget {
  final double totalBill;
  final double serviceFee;
  final double totalPay;
  final PaymentMethod paymentMethod;
  const PaymentSummaryColumn({
    super.key,
    required this.totalBill,
    required this.serviceFee,
    required this.totalPay,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ödeme Yöntemi Özeti',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        SelectedPaymentMethod(
          paymentMethod: paymentMethod,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Toplam Fatura Tutarı',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              totalBill.toCurrency(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kargo Ücreti',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              serviceFee.toCurrency(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Toplam Tutar',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              totalPay.toCurrency(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ],
    );
  }
}
