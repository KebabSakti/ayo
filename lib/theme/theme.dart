import 'package:flutter/material.dart';

enum AppTheme { base, gas, sayur }

final appThemeData = {
  AppTheme.base: ThemeData(primaryColor: Colors.red, fontFamily: 'Montserrat'),
  AppTheme.gas:
      ThemeData(primaryColor: Colors.pink[600], fontFamily: 'Montserrat'),
  AppTheme.sayur:
      ThemeData(primaryColor: Colors.green[400], fontFamily: 'Montserrat'),
};
