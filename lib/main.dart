import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imte_mobile/bloc/edit-profile-bloc/editProfile_bloc.dart';
import 'package:imte_mobile/bloc/enroll-bloc/enroll_bloc.dart';
import 'package:imte_mobile/bloc/feed-bloc/feed_bloc.dart';
import 'package:imte_mobile/bloc/get-profile_bloc/getProfile_bloc.dart';
import 'package:imte_mobile/bloc/history-bloc/history_bloc.dart';
import 'package:imte_mobile/pages/News/news-page.dart';
import 'package:imte_mobile/pages/certificate-page.dart';
import 'package:imte_mobile/pages/dashboard-page.dart';
import 'package:imte_mobile/pages/enroll-page.dart';
import 'package:imte_mobile/pages/history-page.dart';
import 'package:imte_mobile/pages/home-page.dart';
import 'package:imte_mobile/pages/profile-page.dart';
import 'package:imte_mobile/pages/sign-in.dart';
import 'package:imte_mobile/pages/sign-up.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/news-bloc/news_bloc.dart';

Future<void> main() async {
  _notLogged() {
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
        '/dashboard': (context) => DashboardPage(),
        '/enroll': (context) => MultiBlocProvider(
              providers: [
                BlocProvider<EnrollBloc>(
                  create: (BuildContext context) =>
                      EnrollBloc()..add(GetEnrollList()),
                ),
                BlocProvider<GetProfileBloc>(
                  create: (context) => GetProfileBloc()..add(GetProfileList()),
                ),
                BlocProvider<FeedBloc>(
                  create: (context) => FeedBloc()..add(GetFeedList()),
                ),
              ],
              child: EnrollPage(),
            ),
        '/profile': (context) => MultiBlocProvider(
              providers: [
                BlocProvider<GetProfileBloc>(
                  create: (context) => GetProfileBloc()..add(GetProfileList()),
                ),
                BlocProvider<EditProfileBloc>(
                  create: (context) => EditProfileBloc(),
                ),
              ],
              child: ProfilePage(
                enableBack: 'true',
              ),
            ),
        '/news': (context) => BlocProvider<NewsBloc>(
              create: (context) => NewsBloc()..add(GetNewsList()),
              child: NewsPage(),
            ),
        '/history': (context) => BlocProvider(
              create: (context) => HistoryBloc()..add(GetHistoryList()),
              child: HistoryPage(),
            ),
        '/certificate': (context) => CertificatePage(),
      },
    );
  }

  _logged() {
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
        '/': (context) => DashboardPage(),
        '/sign-in': (context) => SignInPage(),
        '/sign-up': (context) => SignUpPage(),
        '/dashboard': (context) => DashboardPage(),
        '/enroll': (context) => MultiBlocProvider(
              providers: [
                BlocProvider<EnrollBloc>(
                  create: (BuildContext context) =>
                      EnrollBloc()..add(GetEnrollList()),
                ),
                BlocProvider<GetProfileBloc>(
                  create: (context) => GetProfileBloc()..add(GetProfileList()),
                ),
                BlocProvider<FeedBloc>(
                  create: (context) => FeedBloc()..add(GetFeedList()),
                ),
              ],
              child: EnrollPage(),
            ),
        '/profile': (context) => MultiBlocProvider(
              providers: [
                BlocProvider<GetProfileBloc>(
                  create: (context) => GetProfileBloc()..add(GetProfileList()),
                ),
                BlocProvider<EditProfileBloc>(
                  create: (context) => EditProfileBloc(),
                ),
              ],
              child: ProfilePage(
                enableBack: 'true',
              ),
            ),
        '/news': (context) => BlocProvider<NewsBloc>(
              create: (context) => NewsBloc()..add(GetNewsList()),
              child: NewsPage(),
            ),
        '/history': (context) => BlocProvider(
              create: (context) => HistoryBloc()..add(GetHistoryList()),
              child: HistoryPage(),
            ),
        '/certificate': (context) => CertificatePage(),
      },
    );
  }

  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status = prefs.getBool('isLoggedIn') ?? false;
  print('status : ' + status.toString());

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MaterialApp(
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
        home: status == true ? _logged() : _notLogged()),
  );
  // runApp(MyApp());
}
