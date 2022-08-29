import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imte_mobile/models/History.dart';
import 'package:imte_mobile/shared/theme.dart';
import 'package:imte_mobile/widget/history-card.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/gradient-text.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  var listHistory = [];
  var listPeriod = [];
  var listTeacher = [];
  var listGrade = [];
  var listMajor = [];

  bool isLoading = true;

  // You have never taken the IMTE exam.

  // ! get data history
  getHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? user = prefs.getInt('user');
    String API_URL = 'https://adm.imte.education/api/enroll/show';

    final response = await http.post(Uri.parse(API_URL), headers: {
      'Accept': 'application/json',
    }, body: {
      'tab_user_id': user.toString(),
      // 'tab_user_id': '1482',
    });

    final data = await json.decode(response.body);

    if (data.length > 0) {
      setState(() {
        isLoading = false;
      });
    }

    for (var i = 0; i < data.length; i++) {
      listHistory.add(History.fromJson(data[i]));
      listPeriod.add(Period.fromJson(data[i]['period']));
      listTeacher.add(Teacher.fromJson(data[i]['teacher']));
      listGrade.add(Grade.fromJson(data[i]['grade']));
      listMajor.add(Major.fromJson(data[i]['major']));
      var itemHistory = listHistory[i];
      var testNumber = 1;
      if (testNumber < 4 && testNumber >= 3.51) {
        print('Exemplary');
      } else if (testNumber <= 3.5 && testNumber >= 3.01) {
        print('Advancing');
      } else if (testNumber <= 3 && testNumber >= 2.01) {
        print('Developing');
      } else if (testNumber <= 2 && testNumber >= 1) {
        print('Beginning');
      } else {
        print('Not Yet');
      }
      print(testNumber);
    }
  }

  // ! result Check
  cekResult(var result) async {
    if (result == 'Exemplary') {
      Color.fromARGB(255, 218, 201, 43);
    } else if (result == 'Advancing') {
      Color.fromARGB(255, 218, 201, 43);
    } else if (result == 'Developing') {
      Color.fromARGB(255, 218, 201, 43);
    } else if (result == 'Beginning') {
      Color.fromARGB(255, 218, 201, 43);
    } else {
      Color.fromARGB(255, 218, 201, 43);
    }
  }

  // ! history list
  Widget buildListview(index) {
    var itemHistory = listHistory[index];
    var itemPeriod = listPeriod[index];
    var itemTeacher = listTeacher[index];
    var itemGrade = listGrade[index];
    var itemMajor = listMajor[index];
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Container(
          height: MediaQuery.of(context).size.width * 0.3,
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: radiusNormal,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1), //color of shadow
                  spreadRadius: 5, //spread radius
                  blurRadius: 10, // blur radius
                  offset: Offset(0, 2),
                ),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (itemHistory.result.toString() == 'null')
                Text(
                  '0',
                  style: greyTextStyle.copyWith(fontSize: 30),
                ),
              Text(
                'Not Yet',
                style: greyTextStyle.copyWith(fontSize: 30),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.width * 0.3,
          width: MediaQuery.of(context).size.width * 0.6,
          margin: EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: radiusNormal,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1), //color of shadow
                  spreadRadius: 5, //spread radius
                  blurRadius: 10, // blur radius
                  offset: Offset(0, 2),
                ),
              ]),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          itemPeriod.periodName,
                          style: blackTextStyle.copyWith(
                              fontSize: 18, fontWeight: semiBold),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Text(
                            itemTeacher.firstName + itemTeacher.lastName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: greyTextStyle.copyWith(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    if (itemMajor.major.toString() == 'Piano')
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/image/1.png'),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: radiusNormal),
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '21 Juni 2022',
                      style: blackTextStyle,
                    ),
                    Text(
                      itemGrade.grade,
                      style: blackTextStyle,
                    ),
                  ],
                )
              ]),
        ),
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 350) {
        return Container(
          padding: EdgeInsets.all(15),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('History',
                    style: blackTextStyle.copyWith(
                      fontSize: 30,
                      fontWeight: semiBold,
                    )),
              ],
            ),
            Divider(
              thickness: 1,
            ),
            Container(
                decoration: BoxDecoration(
                  borderRadius: radiusNormal,
                ),
                height: MediaQuery.of(context).size.height - 250,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: radiusNormal,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: (listHistory.length > 0)
                        ? ListView.builder(
                            itemCount: listHistory.length,
                            itemBuilder: (BuildContext context, int index) {
                              return buildListview(index);
                            },
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('You have never taken the IMTE exam.',
                                  style: greyTextStyle.copyWith(fontSize: 16)),
                            ],
                          )))
          ]),
        );
      }

      // ! Small screens
      return Container(
        padding: EdgeInsets.all(15),
        child: Column(children: [
          Text(
            'History',
            style: GoogleFonts.poppins(
              color: Color.fromARGB(255, 2, 1, 1),
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            child: ListView(
              // reverse: true,
              padding: EdgeInsets.all(0),
              children: [
                HistoryCard(
                  textColor: Colors.green,
                  color: Colors.green,
                  textScore: 3.52.toString(),
                  textResult: 'Examplary!',
                  textPeriod: 'Period 1 | 2021',
                  textDate: '12 June 2021',
                  image: AssetImage('assets/image/1.png'),
                  textGrade: 'JC - Classical',
                  textTeacher: 'Mr. Benny',
                ),
                HistoryCard(
                  textColor: Colors.orange,
                  color: Colors.orange,
                  textScore: 2.11.toString(),
                  textResult: 'Developing',
                  textPeriod: 'Period 1 | 2021',
                  textDate: '31 June 2021',
                  image: AssetImage('assets/image/3.png'),
                  textGrade: 'CFK 2',
                  textTeacher: 'Mr. Roulette',
                ),
                HistoryCard(
                  textColor: Colors.green,
                  color: Colors.green,
                  textScore: 4.toString(),
                  textResult: 'Examplary',
                  textPeriod: 'Period 2 | 2022',
                  textDate: '14 July 2022',
                  image: AssetImage('assets/image/2.png'),
                  textGrade: 'CFK 1',
                  textTeacher: 'Mrs. Lina',
                ),
                HistoryCard(
                  textColor: Colors.red,
                  color: Colors.red,
                  textScore: 1.toString(),
                  textResult: 'Beginning',
                  textPeriod: 'Period 1 | 2021',
                  textDate: '12 June 2021',
                  image: AssetImage('assets/image/4.png'),
                  textGrade: 'JC - Classical',
                  textTeacher: 'Mr. Benny',
                ),
                HistoryCard(
                  textColor: Color.fromARGB(255, 218, 201, 43),
                  color: Color.fromARGB(255, 218, 201, 43),
                  textScore: 3.11.toString(),
                  textResult: 'Advancing!',
                  textPeriod: 'Period 1 | 2021',
                  textDate: '31 June 2021',
                  image: AssetImage('assets/image/5.png'),
                  textGrade: 'CFK 2',
                  textTeacher: 'Mr. Roulette',
                ),
                HistoryCard(
                  textColor: Colors.grey,
                  color: Colors.grey,
                  textScore: 0.toString(),
                  textResult: 'Not Yet',
                  textPeriod: 'Period 2 | 2022',
                  textDate: '14 July 2022',
                  image: AssetImage('assets/image/6.png'),
                  textGrade: 'CFK 1',
                  textTeacher: 'Mrs. Lina',
                ),
              ],
            ),
          ),
        ]),
      );
    })));
  }
}
