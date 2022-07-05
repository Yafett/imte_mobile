import 'package:flutter/material.dart';
import 'package:imte_mobile/pages/sign-in.dart';
import 'package:imte_mobile/pages/sign-up.dart';
import 'package:imte_mobile/pages/test.dart';
import 'widget/sticky_navbar.dart';
import 'pages/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFFF0F0F0)),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => LoginPage(),
        '/sign-in': (context) => SignInPage(),
        '/sign-up': (context) => SignUpPage(),
      },
    );
  }
}
