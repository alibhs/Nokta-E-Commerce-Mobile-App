import 'package:e_commerce_app/app/constants/colors_value.dart';
import 'package:e_commerce_app/core/domain/entities/transaction/transaction.dart';
import 'package:e_commerce_app/utils/extension.dart';
import 'package:flutter/material.dart';

class TransactionStatusCheckbox extends StatefulWidget {
  final TransactionStatus selectedStatus;
  const TransactionStatusCheckbox({Key? key, required this.selectedStatus})
      : super(key: key);

  @override
  State<TransactionStatusCheckbox> createState() =>
      _TransactionStatusCheckboxState();
}

class _TransactionStatusCheckboxState extends State<TransactionStatusCheckbox> {
  TransactionStatus? selectedStatus;

  List<TransactionStatus> statuses = [];

  @override
  void initState() {
    selectedStatus = widget.selectedStatus;
    for (var status in TransactionStatus.values) {
      if (status != TransactionStatus.tamamlandi &&
          status != TransactionStatus.yorumlandi) {
        statuses.add(status);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'İşlem Durumu',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ...statuses.map((status) {
            return CheckboxListTile(
              title: Text(status.name.capitalizeFirstLetter()),
              value: selectedStatus == status,
              activeColor: ColorsValue.primaryColor(context),
              onChanged: (value) {
                if (value!) {
                  setState(() {
                    selectedStatus = status;
                  });
                } else {
                  setState(() {
                    selectedStatus = null;
                  });
                }
              },
            );
          }),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: selectedStatus == null
                ? null
                : () {
                    Navigator.of(context).pop(selectedStatus);
                  },
            child: const Text('Durumu Değiştir'),
          ),
        ],
      ),
    );
  }
}
