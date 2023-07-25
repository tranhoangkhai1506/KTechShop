import 'package:flutter/material.dart';
import 'package:ktechshop/constants/theme.dart';
import 'package:ktechshop/screens/auth_ui/welcome/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'K-Tech',
      home: Welcome(),
      theme: themData,
      debugShowCheckedModeBanner: false,
    );
  }
}
