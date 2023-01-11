import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imte_mobile/pages/history-page.dart';
import 'package:imte_mobile/shared/theme.dart';
import 'News/news-page.dart';
import 'enroll-page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedPage = 0;
  String emailController = '';

  @override
  void initState() {
    super.initState();
  }

  // ! modal exit
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Nope",
        style: redTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Sure",
        style: blackTextStyle.copyWith(
            fontSize: 16, color: Colors.green, fontWeight: semiBold),
      ),
      onPressed: () {
        SystemNavigator.pop();
        exit(0);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Alert",
        style: blackTextStyle.copyWith(fontSize: 20, fontWeight: semiBold),
      ),
      content: Text(
        "Are you sure want to leave this Page?",
        style: greyTextStyle.copyWith(fontSize: 16),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
                      showAlertDialog(context);
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
}
