import 'package:e_commerce_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  Intl.defaultLocale = 'tr_TR';

  initializeDateFormatting('tr_TR', null).then((_) {
    runApp(App());
  });
}
