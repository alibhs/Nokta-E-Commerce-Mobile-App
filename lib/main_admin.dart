import 'package:e_commerce_app/app/app.dart';
import 'package:e_commerce_app/config/admin_config.dart';
import 'package:e_commerce_app/config/flavor_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

// flutter run --flavor admin -t .\lib\main_admin.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Intl.defaultLocale = 'tr_TR';
  timeago.setLocaleMessages('tr', timeago.TrMessages());

  FlavorConfig(
    flavor: Flavor.admin,
    flavorValues: FlavorValues(
      roleConfig: AdminConfig(),
    ),
  );

  initializeDateFormatting('tr_TR', null).then((_) {
    runApp(App());
  });
}
