import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imte_mobile/bloc/history-bloc/history_bloc.dart';
import 'package:imte_mobile/models/history-model.dart';
import 'package:imte_mobile/shared/theme.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  HistoryBloc _historyBloc = HistoryBloc();

  var _sortVal;

  var dropdownTrue = false;

  var sortList = ['Highest', 'Lowest', 'Newest', 'Oldest'];

  var historyList = [];

  @override
  void initState() {
    super.initState();
    _historyBloc.add(GetHistoryList());
    _fetchHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    return _buldHistoryPage(context);
  }

  Widget _buldHistoryPage(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: Scaffold(
        body: SafeArea(child: _buildHistoryList(context)
            // Container(
            //   child: Column(children: [
            //     Container(
            //       padding: EdgeInsets.all(15),
            //       height: 140,
            //       width: double.infinity,
            //       decoration: BoxDecoration(
            //           color: kBlueColor,
            //           borderRadius: BorderRadius.only(
            //             bottomLeft: Radius.circular(12),
            //             // bottomRight: Radius.circular(12),
            //           )),
            //       child: Column(
            //         children: [
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             children: [
            //               Text('History',
            //                   style: whiteTextStyle.copyWith(
            //                     fontSize: 30,
            //                     fontWeight: semiBold,
            //                   )),
            //             ],
            //           ),
            //           const SizedBox(height: 10),
            //           dropdownTrue == true ? _sortDropdown() : Container(),
            //         ],
            //       ),
            //     ),
            //   ]),
            // ),
            ),
      ),
    );
  }

  Widget fluidContainer() {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
          color: kBlueColor,
          borderRadius: BorderRadius.only(
              // bottomLeft: Radius.circular(12),
              // bottomRight: Radius.circular(12),
              )),
    );
  }

  _sortDropdown() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        underline: SizedBox(),
        isExpanded: true,
        style: greyTextStyle.copyWith(fontSize: 14, fontWeight: semiBold),
        hint: Text('Sort by'),
        items: sortList.map((item) {
          return DropdownMenuItem(
            value: item.toString(),
            child: Text(item.toString()),
          );
        }).toList(),
        onChanged: (newVal) {
          _sortVal = newVal;
          if (newVal.toString() == 'Lowest') {
            if (mounted) {
              setState(() {
                historyList.sort((score1, score2) {
                  return score1['result']['gpa']
                      .toString()
                      .compareTo(score2['result']['gpa'].toString());
                });
              });
            }
          } else if (newVal == 'Highest') {
            if (mounted) {
              setState(() {
                historyList.sort((score1, score2) {
                  return score2['result']['gpa']
                      .toString()
                      .compareTo(score1['result']['gpa'].toString());
                });
              });
            }
          } else if (newVal == 'Oldest') {
            if (mounted) {
              setState(() {
                historyList.sort((score1, score2) {
                  return score1['period']['period_name']
                      .toString()
                      .compareTo(score2['period']['period_name'].toString());
                });
              });
            }
          } else if (newVal == 'Newest') {
            if (mounted) {
              setState(() {
                historyList.sort((score1, score2) {
                  return score2['period']['period_name']
                      .toString()
                      .compareTo(score1['period']['period_name'].toString());
                });
              });
            }
          }
        },
        value: _sortVal,
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: radiusNormal,
      ),
      height: MediaQuery.of(context).size.height - 250,
      child: Container(
        height: MediaQuery.of(context).size.height - 100,
        decoration: BoxDecoration(
          borderRadius: radiusNormal,
        ),
        width: MediaQuery.of(context).size.width,
        child: BlocBuilder<HistoryBloc, HistoryState>(
          bloc: _historyBloc,
          builder: (context, state) {
            if (state is HistoryLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is HistoryLoaded) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: kBlueColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          // bottomRight: Radius.circular(12),
                        )),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('History',
                                style: whiteTextStyle.copyWith(
                                  fontSize: 30,
                                  fontWeight: semiBold,
                                )),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _sortDropdown(),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    // color: Colors.red,
                    child: RefreshIndicator(
                      onRefresh: () async =>
                          context.read<HistoryBloc>().add(GetMoreHistoryList()),
                      child: ListView.builder(
                        itemCount: historyList.length,
                        itemBuilder: (BuildContext context, int index) {
                          Period period = state.period[0];
                          History history = state.history[index];
                          var hist = historyList[index];

                          return _buildHistoryCard(index, hist, period);
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is HistoryError) {
              return Center(child: Text('${state.toString()}'));
            } else {
              return Center(
                child: Text(
                  'You have never taken any IMTE exam.',
                  style: greyTextStyle.copyWith(fontSize: 16),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildHistoryCard(index, history, period) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            height: MediaQuery.of(context).size.width * 0.3,
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: radiusNormal,
                border: Border.all(
                  color: Color(0xffD7D7D7),
                ),
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
                  history['result']['gpa'].toString(),
                  style: _getGpaColor(history['result']['gpa']),
                ),
                _gpaScore(history['result']['gpa']),
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
                border: Border.all(
                  color: Color(0xffD7D7D7),
                ),
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
                            history['period']['period_name'],
                            style: blackTextStyle.copyWith(
                                fontSize: 20, fontWeight: semiBold),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text(
                              '${history['teacher']['first_name']} ${history['teacher']['last_name']} ',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: greyTextStyle.copyWith(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  _getMajorPicture(history['major']['major'])),
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
                        _setDate(history),
                        style: blackTextStyle,
                      ),
                      Text(
                        history['grade']['grade'],
                        style: blackTextStyle,
                      ),
                    ],
                  )
                ]),
          ),
        ]),
      ),
    );
  }

  _setDate(history) {
    DateTime dt = DateTime.parse(history['created_at']);
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    final String formatted = formatter.format(dt);

    return formatted.toString();
  }

  Widget _gpaScore(number) {
    var testNumber = double.parse(number);
    // ignore: unnecessary_type_check
    assert(testNumber is double);

    if (testNumber < 4 && testNumber >= 3.51) {
      return Text('Examplary', style: greenTextStyle.copyWith(fontSize: 16));
    } else if (testNumber <= 3.5 && testNumber >= 3.01) {
      return Text('Advance', style: blueTextStyle.copyWith(fontSize: 16));
    } else if (testNumber <= 3 && testNumber >= 2.01) {
      return Text('Developing', style: orangeTextStyle.copyWith(fontSize: 16));
    } else if (testNumber <= 2 && testNumber >= 1) {
      return Text('Beginning', style: yellowTextStyle.copyWith(fontSize: 16));
    } else {
      return Text('Not Yet', style: greyTextStyle.copyWith(fontSize: 16));
    }
  }

  _getGpaColor(number) {
    var testNumber = double.parse(number);
    // ignore: unnecessary_type_check
    assert(testNumber is double);

    if (testNumber < 4 && testNumber >= 3.51) {
      return greenTextStyle.copyWith(fontSize: 30, fontWeight: semiBold);
    } else if (testNumber <= 3.5 && testNumber >= 3.01) {
      return blueTextStyle.copyWith(fontSize: 30, fontWeight: semiBold);
    } else if (testNumber <= 3 && testNumber >= 2.01) {
      return orangeTextStyle.copyWith(fontSize: 30, fontWeight: semiBold);
    } else if (testNumber <= 2 && testNumber >= 1) {
      return yellowTextStyle.copyWith(fontSize: 30, fontWeight: semiBold);
    } else {
      return greyTextStyle.copyWith(fontSize: 30, fontWeight: semiBold);
    }
  }

  _getMajorPicture(major) {
    if (major == 'Piano') {
      return 'assets/image/1.png';
    } else if (major == 'Drum') {
      return 'assets/image/2.png';
    } else if (major == 'Acoustic Guitar') {
      return 'assets/image/3.png';
    } else if (major == 'Electric Guitar') {
      return 'assets/image/3.png';
    } else if (major == 'Bass') {
      return 'assets/image/3.png';
    } else if (major == 'Vocal') {
      return 'assets/image/4.png';
    } else if (major == 'Saxophone') {
      return 'assets/image/7.png';
    } else if (major == 'Flute') {
      return 'assets/image/6.png';
    } else if (major == 'Violin') {
      return 'assets/image/5.png';
    }
  }

  _fetchHistoryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('tabUserId');

    final uri = Uri.parse("https://adm.imte.education/api/enroll/show");
    final response = await http.post(uri, body: {'tab_user_id': id.toString()});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      for (var a = 0; a < data.length; a++) {
        print(data[a]);
        historyList.add(data[a]);
      }

      print(historyList.toString());
    } else {
      throw Exception("Failed to load history");
    }
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
