import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imte_mobile/pages/certificate.dart';
import 'package:imte_mobile/pages/dashboard.dart';
import 'package:imte_mobile/pages/enroll.dart';
import 'package:imte_mobile/pages/history.dart';
import 'package:imte_mobile/pages/home.dart';
import 'package:imte_mobile/pages/news.dart';
import 'package:imte_mobile/pages/news-detail.dart';
import 'package:imte_mobile/pages/profile-edit.dart';
import 'package:imte_mobile/pages/profile.dart';
import 'package:imte_mobile/pages/sign-in.dart';
import 'package:imte_mobile/pages/sign-up.dart';
import 'package:imte_mobile/pages/test.dart';
import 'package:imte_mobile/widget/enroll-card.dart';
import 'package:imte_mobile/widget/news-card.dart';
import 'widget/sticky_navbar.dart';
import 'pages/login.dart'; 
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  // add these lines
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // run app
  runApp(MyApp());
}

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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English, no country code
        Locale('id', ''), // Spanish, no country code
      ],
      routes: {
        '/': (context) => HomePage(),
        '/sign-in': (context) => SignInPage(),
        '/sign-up': (context) => SignUpPage(),
        '/dashboard': (context) => DashboardPage(token: ''),
        '/enroll': (context) => EnrollPage(),
        '/profile': (context) => ProfilePage(
              enableBack: 'true',
            ),
        '/news': (context) => NewsPage(),
        '/history': (context) => HistoryPage(),
        '/certificate': (context) => CertificatePage(),
      },
    );  
  }
}
