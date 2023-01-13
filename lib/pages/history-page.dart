import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imte_mobile/bloc/history-bloc/history_bloc.dart';
import 'package:imte_mobile/models/history-model.dart';
import 'package:imte_mobile/shared/theme.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  HistoryBloc _historyBloc = HistoryBloc();

  @override
  void initState() {
    super.initState();
    _historyBloc.add(GetHistoryList());
  }

  @override
  Widget build(BuildContext context) {
    return _buldHistoryPage(context);
  }

  Widget _buldHistoryPage(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: Scaffold(
        body: SafeArea(
          child: Container(
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
              _buildHistoryList(context)
            ]),
          ),
        ),
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
              print(state.history.length);
              return RefreshIndicator(
                onRefresh: () async =>
                    context.read<HistoryBloc>().add(GetMoreHistoryList()),
                child: ListView.builder(
                  itemCount: state.history.length,
                  itemBuilder: (BuildContext context, int index) {
                    Period period = state.period[0];
                    History history = state.history[index];
                    if (history.period!.periodName != period.periodName &&
                        history.status.toString() == '3') {
                      return _buildHistoryCard(index, history, period);
                    }
                    return Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: Center(
                          child: Text(
                        "You didn't have any history yet",
                        style: greyTextStyle,
                      )),
                    );
                  },
                ),
              );
            } else if (state is HistoryError) {
              return Center(child: Text('${state.message}'));
            } else {
              return Center(
                child: Text(
                  'You have never taken the IMTE exam.',
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
              Text(
                history.result.gpa.toString(),
                style: _getGpaColor(history.result.gpa),
              ),
              _gpaScore(history.result.gpa),
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
                          history.period.periodName,
                          style: blackTextStyle.copyWith(
                              fontSize: 16, fontWeight: semiBold),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Text(
                            '${history.teacher.firstName} ${history.teacher.lastName} ',
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
                                _getMajorPicture(history.major.major)),
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
                      history.grade.grade,
                      style: blackTextStyle,
                    ),
                  ],
                )
              ]),
        ),
      ]),
    );
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
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
