import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imte_mobile/pages/history.dart';
import 'package:imte_mobile/pages/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'enroll.dart';
import 'news.dart';

class DashboardPage extends StatefulWidget {
  final String token;

  const DashboardPage({Key? key, required this.token}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedPage = 0;
  String emailController = '';

  @override
  void initState() {
    super.initState();
    getToken();
  }

  // ! get token from sharedPreferences
  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('tokenz', widget.token);

    String tokenz = prefs.getString('tokenz').toString();

    print('token preferences : ' + tokenz);
  }

  // ! modal exit
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Nope"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Sure"),
      onPressed: () {
        SystemNavigator.pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Are you sure want to leave this Page?"),
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
    ProfilePage(
      enableBack: 'false',
    ),
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
              BottomNavigationBarItem(
                  icon: Icon(Icons.person, size: 30), label: ''),
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
