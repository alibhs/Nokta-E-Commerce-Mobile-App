import 'package:flutter/material.dart';

import '../themes/custom_bottom_sheet.dart';
import '../themes/custom_input_decoration.dart';
import '../themes/custom_text_theme.dart';
import 'role_config.dart';

class AdminConfig implements RoleConfig {
  @override
  String appName() {
    return 'Admin Nokta';
  }

  @override
  Color primaryColor() {
    return const Color(0xFF288364);
  }

  @override
  Color primaryDarkColor() {
    return const Color(0xFF4E9F3D);
  }

  @override
  ThemeData theme() {
    return ThemeData(
      primaryColor: primaryColor(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor(),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor(),
      ),
      useMaterial3: true,
      textTheme: CustomTextTheme.textTheme,
      inputDecorationTheme: CustomInputDecoration.inputDecorationTheme,
      bottomSheetTheme: CustomBottomSheet.bottomSheetThemeData,
    );
  }
}
