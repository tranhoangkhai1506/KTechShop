import 'package:flutter/material.dart';

ThemeData themData = ThemeData(
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black)),
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

OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color.fromARGB(255, 10, 200, 240), width: 5),
);
