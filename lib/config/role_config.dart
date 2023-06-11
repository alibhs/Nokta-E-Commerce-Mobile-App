import 'package:flutter/material.dart';

abstract class RoleConfig {
  String appName() {
    return 'Nokta';
  }

  Color primaryColor() {
    return Colors.green;
  }

  Color primaryDarkColor() {
    return Colors.greenAccent;
  }

  ThemeData theme() {
    return ThemeData.light();
  }
}
