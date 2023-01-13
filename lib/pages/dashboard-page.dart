import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imte_mobile/pages/history-page.dart';
import 'package:imte_mobile/pages/home-page.dart';
import 'package:imte_mobile/pages/sign-in.dart';
import 'package:imte_mobile/shared/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'News/news-page.dart';
import 'enroll-page.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedPage = 0;
  String emailController = '';
  final dio = Dio();

  @override
  void initState() {
    super.initState();
  }

  dialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(' Alert'),
            content: Text('Are you sure want to Logout?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    //action code for "Yes" button
                    _logout();
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  child: Text(
                    'Yes',
                    style: blackTextStyle.copyWith(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: semiBold),
                  )),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); //close Dialog
                },
                child: Text(
                  'Close',
                  style:
                      redTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
                ),
              ),
            ],
          );
        });
  }

  // ! appbar navigation
  final _pageOptions = [
    EnrollPage(),
    NewsPage(),
    HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: _pageOptions[selectedPage],
        bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined, size: 30), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper_outlined, size: 30), label: ''),
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.person, size: 30), label: ''),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(Icons.history_outlined, size: 30),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: GestureDetector(
                    onTap: () {
                      dialog();
                    },
                    child: Icon(Icons.exit_to_app_outlined, size: 30)),
              ),
            ],
            selectedItemColor: Color.fromARGB(255, 228, 65, 65),
            elevation: 5.0,
            unselectedItemColor: Color(0xff2398D4),
            currentIndex: selectedPage,
            backgroundColor: Colors.white,
            onTap: (index) {
              setState(() {
                selectedPage = index;
              });
            }));
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    var token = prefs.getString('token');
    print('adsadas' + id.toString());
    dio.options.headers['Accept'] = 'application/json';
    final response = await http.get(
        Uri.parse('https://adm.imte.education/api/user/logoutv2?id=${id}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer + ${token}'
        });

    print(response.body.toString());

    prefs.remove('isLoggedIn');
    prefs.setBool('isLoggedIn', false);
  }
}
