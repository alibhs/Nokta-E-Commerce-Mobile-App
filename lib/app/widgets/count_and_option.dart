import 'package:flutter/material.dart';

class CountAndOption extends StatelessWidget {
  final int count;
  final String itemName;
  final bool isSort;
  final Function() onTap;
  const CountAndOption({
    Key? key,
    required this.count,
    required this.itemName,
    required this.isSort,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Burada',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: ' ' '$count $itemName',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        isSort
            ? OutlinedButton.icon(
                onPressed: () {
                  onTap();
                },
                icon: const Icon(Icons.sort_rounded),
                label: const Text('Sırala'),
              )
            : OutlinedButton.icon(
                onPressed: () {
                  onTap();
                },
                icon: const Icon(Icons.filter_list_rounded),
                label: const Text('Filtre'),
              ),
      ],
    );
  }
}
