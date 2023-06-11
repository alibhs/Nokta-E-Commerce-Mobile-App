import 'package:e_commerce_app/app/constants/colors_value.dart';
import 'package:flutter/material.dart';

class RadioCard<T> extends StatelessWidget {
  final T value;
  final T? selectedValue;
  final void Function(T?) onChanged;
  final String title;
  final String subtitle;
  final Function() onDelete;
  final Function() onEdit;
  const RadioCard({
    Key? key,
    required this.value,
    required this.selectedValue,
    required this.onChanged,
    required this.onDelete,
    required this.onEdit,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = value == selectedValue;

    return InkWell(
      onTap: () {
        isSelected ? onChanged(null) : onChanged(value);
      },
      borderRadius: BorderRadius.circular(8),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isSelected
                ? ColorsValue.primaryColor(context)
                : Theme.of(context).colorScheme.outline,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Radio<T>(
                    value: value,
                    groupValue: selectedValue,
                    onChanged: onChanged,
                    toggleable: true,
                    activeColor: ColorsValue.primaryColor(context),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: onDelete,
                    child: const Text('Sil'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: onEdit,
                    child: const Text('Düzenle'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
