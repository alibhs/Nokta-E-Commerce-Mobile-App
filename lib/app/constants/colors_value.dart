import 'package:e_commerce_app/config/flavor_config.dart';
import 'package:flutter/material.dart';

FlavorConfig flavor = FlavorConfig.instance;

class ColorsValue {
  static Color primaryColor(BuildContext context) {
    return flavor.flavorValues.roleConfig.primaryColor();
  }
}
