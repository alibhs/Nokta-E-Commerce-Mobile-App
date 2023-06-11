import 'package:e_commerce_app/app/pages/checkout/widgets/checkout_product_container.dart';
import 'package:e_commerce_app/app/pages/checkout/widgets/select_shipping_address.dart';
import 'package:e_commerce_app/app/providers/account_provider.dart';
import 'package:e_commerce_app/app/providers/checkout_provider.dart';
import 'package:e_commerce_app/core/domain/entities/address/address.dart';
import 'package:e_commerce_app/routes.dart';
import 'package:e_commerce_app/themes/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/utils/extension.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Address? shippingAddress;

  @override
  void initState() {
    Future.microtask(() {
      setState(() {
        shippingAddress =
            context.read<AccountProvider>().account.primaryAddress;
        context
            .read<CheckoutProvider>()
            .updateTotalBill(shippingAddress: shippingAddress);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ödeme'),
      ),
      body: Consumer<CheckoutProvider>(
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectShippingAddress(
                        shippingAddress: shippingAddress,
                        selectAddress: () async {
                          var result = await NavigateRoute.toManageAddress(
                              context: context, returnAddress: true);
                          setState(() {
                            shippingAddress = result;
                            context.read<CheckoutProvider>().updateTotalBill(
                                shippingAddress: shippingAddress);
                          });
                        },
                        removeAddress: () {
                          setState(() {
                            shippingAddress = null;
                            context.read<CheckoutProvider>().updateTotalBill(
                                shippingAddress: shippingAddress);
                          });
                        },
                      ),
                      ...value.dataTransaction.purchasedProduct.map(
                        (item) => CheckoutProductContainer(item: item),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ara Toplam',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            value.dataTransaction.subTotal?.toCurrency() ?? '-',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Sipariş Özeti',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Toplam Fiyat (${value.countItems} Ürünler)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            value.dataTransaction.totalPrice?.toCurrency() ??
                                '-',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      if (shippingAddress != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Kargo Ücreti',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              value.dataTransaction.shippingFee?.toCurrency() ??
                                  '-',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Toplam Fatura Tutarı',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          value.dataTransaction.totalBill?.toCurrency() ?? '-',
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: CustomColor.error,
                                  ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: shippingAddress == null
                          ? null
                          : () {
                              value.dataTransaction.shippingAddress =
                                  shippingAddress;
                              value.dataTransaction.totalPay =
                                  value.dataTransaction.totalBill! +
                                      value.dataTransaction.serviceFee!;

                              NavigateRoute.toPayment(context: context);
                            },
                      child: const Text('Ödeme Yöntemi Seç'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
