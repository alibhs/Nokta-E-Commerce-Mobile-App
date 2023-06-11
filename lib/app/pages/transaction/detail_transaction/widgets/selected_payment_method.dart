import 'package:e_commerce_app/core/domain/entities/payment_method/payment_method.dart';
import 'package:flutter/material.dart';

class SelectedPaymentMethod extends StatelessWidget {
  final PaymentMethod paymentMethod;

  const SelectedPaymentMethod({
    Key? key,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ödeme Yöntemi',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        ListTile(
          dense: true,
          title: Text(paymentMethod.cardholderName),
          contentPadding: EdgeInsets.zero,
          visualDensity: const VisualDensity(vertical: -4),
          subtitle: Text(
            paymentMethod.cardNumber,
          ),
        ),
      ],
    );
  }
}
