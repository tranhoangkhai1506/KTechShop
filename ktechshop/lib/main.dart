import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ktechshop/constants/theme.dart';
import 'package:ktechshop/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:ktechshop/firebase_helper/firebase_options/firebase_options.dart';
import 'package:ktechshop/provider/app_provider.dart';
import 'package:ktechshop/screens/auth_ui/welcome/welcome.dart';
import 'package:ktechshop/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51NcQH0CizuobP5vV9ZC0fDWT25Or9yeykFi2i5JXqARUstruauJWUMJqSDUIz2OxQj8vV1fa0Ytmolnmltx1xl1s00bihWFCpt";
  await Firebase.initializeApp(
    options: DefaultFirebaseConfig.platformOptions,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        title: 'K-Tech',
        home: StreamBuilder(
            stream: FirebaseAuthHelper.instance.getAuthChange,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CustomBottomBar();
              }
              return Welcome();
            }),
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark().copyWith(
          useMaterial3: true,
          primaryColor: Colors.indigo,
          hintColor: Colors.amber,
          brightness: Brightness.dark,
          canvasColor: Colors.purple,
        ),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
