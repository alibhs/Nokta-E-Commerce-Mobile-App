import 'package:flutter/material.dart';

class PersonalInfoTile extends StatelessWidget {
  final String personalInfo;
  final String value;
  final Function() onTap;
  const PersonalInfoTile({Key? key, required this.personalInfo, required this.value, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
      },
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Text(personalInfo),
      title: Text(value),
      trailing: const Icon(
        Icons.navigate_next_rounded,
      ),
    );
  }
}
