import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.black
    ),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
  ),
  colorScheme: ColorScheme.light(
    surface: Colors.grey[300]!,
    primary: Colors.grey[200]!,
    secondary: Colors.grey[100]!
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.black)
  )
);