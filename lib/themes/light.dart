import 'package:flutter/material.dart';

final brilliantAzureColor = Color(0xff269dfe);
final princetonOrangeColor = Color(0xfffe8826);

final brilliantAzureSwatch = <int, Color>{
  50: Color(0xFFECEFF1),
  100: Color(0xFFCFD8DC),
  200: Color(0xFFB0BEC5),
  300: Color(0xFF90A4AE),
  400: Color(0xFF78909C),
  500: brilliantAzureColor,
  600: Color(0xFF546E7A),
  700: Color(0xFF455A64),
  800: Color(0xFF37474F),
  900: Color(0xFF263238),
};
final princetonOrangeSwatch = <int, Color>{
  500: princetonOrangeColor,
};

final primarySwatch = MaterialColor(brilliantAzureColor.value, brilliantAzureSwatch);
final accentSwatch = MaterialColor(princetonOrangeColor.value, princetonOrangeSwatch);

final lightTheme = ThemeData(
  buttonTheme: ButtonThemeData(
    height: 48,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  fontFamily: 'Roboto',
  inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
  primarySwatch: primarySwatch,
  primaryColor: brilliantAzureColor,
  accentColor: princetonOrangeColor,
);