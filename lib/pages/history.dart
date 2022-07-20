import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imte_mobile/widget/history-card.dart';

import '../widget/gradient-text.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

Widget listBox() {
  return Container(
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Container(
        margin: EdgeInsets.only(top: 10),
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
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
            Text(
              '3.52',
              style: GoogleFonts.poppins(
                fontSize: 30,
                color: Color(0xff4CAF50),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Great!',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Color(0xff4CAF50),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.all(10),
        height: 100,
        width: 230,
        margin: EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1), //color of shadow
                spreadRadius: 5, //spread radius
                blurRadius: 10, // blur radius
                offset: Offset(0, 2),
              ),
            ]),
        child: Row(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.watch_later_outlined,
                      color: Color.fromARGB(255, 0, 0, 0),
                      size: 18,
                    ),
                  ),
                  Text(
                    'Period 1 | 2022',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.person_outline,
                      color: Color.fromARGB(255, 0, 0, 0),
                      size: 18,
                    ),
                  ),
                  Text(
                    'Teacher One',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.calendar_month_outlined,
                      color: Color.fromARGB(255, 0, 0, 0),
                      size: 18,
                    ),
                  ),
                  Text(
                    '12 June 2022',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          VerticalDivider(
            color: Colors.grey,
            thickness: 1,
            indent: 0,
            endIndent: 0,
            width: 25,
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 5),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/1.png'),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(20)),
              ),
              GradientText(
                'JC - Classical',
                style: const TextStyle(
                    fontSize: 14, overflow: TextOverflow.ellipsis),
                gradient: LinearGradient(colors: [
                  Color(0xff44C0CB),
                  Color(0xff3F6BB2),
                ]),
              ),
            ],
          ),
        ]),
      ),
    ]),
  );
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.005),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        'History',
                        style: GoogleFonts.poppins(
                          color: Color.fromARGB(255, 2, 1, 1),
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(0),
                  height: MediaQuery.of(context).size.height * 0.76,
                  child: ListView(
                    padding: EdgeInsets.all(0),
                    children: [
                      HistoryCard(
                        textScore: 3.52.toString(),
                        textResult: 'Great!',
                        textPeriod: 'Period1 1 | 2021',
                        textDate: '12 June 2021',
                        image: AssetImage('assets/image/1.png'),
                        textGrade: 'JC - Classical',
                        textTeacher: 'Mr. Benny',
                      ),
                      HistoryCard(
                        textScore: 2.11.toString(),
                        textResult: 'Try Again!',
                        textPeriod: 'Period1 1 | 2021',
                        textDate: '31 June 2021',
                        image: AssetImage('assets/image/3.png'),
                        textGrade: 'CFK 2',
                        textTeacher: 'Mr. Roulette',
                      ),
                      HistoryCard(
                        textScore: 4.toString(),
                        textResult: 'Impossible',
                        textPeriod: 'Period1 2 | 2022',
                        textDate: '14 July 2022',
                        image: AssetImage('assets/image/2.png'),
                        textGrade: 'CFK 1',
                        textTeacher: 'Mrs. Lina',
                      ),
                      HistoryCard(
                        textScore: 3.52.toString(),
                        textResult: 'Great!',
                        textPeriod: 'Period1 1 | 2021',
                        textDate: '12 June 2021',
                        image: AssetImage('assets/image/4.png'),
                        textGrade: 'JC - Classical',
                        textTeacher: 'Mr. Benny',
                      ),
                      HistoryCard(
                        textScore: 2.11.toString(),
                        textResult: 'Try Again!',
                        textPeriod: 'Period1 1 | 2021',
                        textDate: '31 June 2021',
                        image: AssetImage('assets/image/5.png'),
                        textGrade: 'CFK 2',
                        textTeacher: 'Mr. Roulette',
                      ),
                      HistoryCard(
                        textScore: 4.toString(),
                        textResult: 'Impossible',
                        textPeriod: 'Period1 2 | 2022',
                        textDate: '14 July 2022',
                        image: AssetImage('assets/image/6.png'),
                        textGrade: 'CFK 1',
                        textTeacher: 'Mrs. Lina',
                      ),
                      HistoryCard(
                        textScore: 4.toString(),
                        textResult: 'Impossible',
                        textPeriod: 'Period1 2 | 2022',
                        textDate: '14 July 2022',
                        image: AssetImage('assets/image/7.png'),
                        textGrade: 'CFK 1',
                        textTeacher: 'Mrs. Lina',
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
