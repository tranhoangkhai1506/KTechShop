import 'package:flutter/material.dart';

ThemeData themData = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Color.fromARGB(255, 10, 200, 240),
    inputDecorationTheme: InputDecorationTheme(
        border: outlineInputBorder,
        errorBorder: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        prefixIconColor: Colors.grey,
        suffixIconColor: Colors.grey,
        focusedBorder: outlineInputBorder,
        disabledBorder: outlineInputBorder),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 10, 200, 240),
            disabledBackgroundColor: Colors.grey)));

OutlineInputBorder outlineInputBorder =
    OutlineInputBorder(borderSide: BorderSide(color: Colors.grey));
