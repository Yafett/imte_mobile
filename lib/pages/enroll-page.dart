// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imte_mobile/bloc/enroll-bloc/enroll_bloc.dart';
import 'package:imte_mobile/bloc/feed-bloc/feed_bloc.dart';
import 'package:imte_mobile/bloc/news-bloc/news_bloc.dart';
import 'package:imte_mobile/models/News-model.dart';
import 'package:imte_mobile/models/feed-model.dart';
import 'package:imte_mobile/models/history-model.dart';
import 'package:imte_mobile/models/instrument-model.dart';
import 'package:imte_mobile/models/profile-model.dart';
import 'package:imte_mobile/pages/add-enroll.dart';
import 'package:imte_mobile/pages/history-page.dart';
import 'package:imte_mobile/pages/profile-page.dart';
import 'package:imte_mobile/shared/theme.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletons/skeletons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../bloc/get-profile_bloc/getProfile_bloc.dart';
import '../models/gallery-model.dart';
import '../widget/news-card.dart';
import 'edit-enroll.dart';
import 'home-page.dart';

class EnrollPage extends StatefulWidget {
  const EnrollPage({Key? key}) : super(key: key);

  @override
  State<EnrollPage> createState() => _EnrollPageState();
}

class _EnrollPageState extends State<EnrollPage> {
  EnrollBloc _enrollBloc = EnrollBloc();
  GetProfileBloc _profileBloc = GetProfileBloc();
  FeedBloc _feedBloc = FeedBloc();
  NewsBloc _newsBloc = NewsBloc();

  Dio dio = Dio();

  XFile? imageFile;
  String id = '';
  String dlast = '';
  String email = '';
  String active = '';
  String status = '';
  String dfirst = '';
  String statusEnroll = '';
  String statusProfile = '';
  String lastId = '';
  String lastDate = '';
  String lastUser = '';
  String lastTitle = '';
  String lastImage = '';
  String lastContent = '';
  String tests = '';
  String? teacherVal;
  var studentName;
  bool loading = true;
  bool isLoading = true;
  bool isExist = false;
  Map listTest = {};
  List<Map> myList = <Map>[];
  List gradeList = [];
  List teacherList = [];
  List instrumentList = [];
  List<dynamic> teacher = [];
  Color warna = Color(0xff873190);
  Color statusColor = Color(0xffFFFF);
  Color statusBackground = Color(0xffFFFF);
  var listProfile = [];
  var result;
  var imageSrc;
  var gradeval;
  var teacherval;
  var instrumentval;
  var dropdownValue;
  var itemNum = '';
  var photoName = '';
  var activityStatus = '';
  var listGrade = [];
  var listInstrument = [];
  var listMajor = [];
  var listEnroll = [];
  var listStatus = [];
  var listFormat = [];
  var listPeriod = [];
  var listNumber = [];
  var listFeed = [];
  var listTeacher = [];
  var listNews = [];

  var periodData;

  var instrument = [
    'CFK 1',
    'CFK 2',
    'JC 1',
    'JC 2',
    'JC 3',
    'JC 4',
    'JC 5',
    'JC 6'
  ];
  var instrument2 = [
    'CFK 1',
    'CFK 2',
    'JC 1',
    'JC 2',
    'JC 3',
    'JC 4',
    'JC 5 - Pop Jazz',
    'JC 5 - Classical',
    'JC 6 - Pop Jazz',
    'JC 6 - Classical'
  ];

  String? scanResult;

  Future scanBarcode(enrollCode) async {
    String scanResult;

    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      scanResult = 'Failed to scan';
    }

    if (!mounted) return;

    setState(() => this.scanResult = scanResult);

    var decoded = base64.decode(scanResult);

    print(utf8.decode(decoded));

    final response = await http.get(
        Uri.parse(
            'https://adm.imte.education/api/activity/changeStatus/${utf8.decode(decoded)}/${enrollCode.toString()}'),
        headers: {'Accept': 'application/json'});

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      Navigator.pop(context);
      final succesSnackbar = SnackBar(
        content: const Text('QR Scanned Successfully'),
        backgroundColor: (Colors.black),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(succesSnackbar);
    } else {
      Navigator.pop(context);
      final failedSnackbar = SnackBar(
        content: const Text('Failed to Scan QR Code'),
        backgroundColor: (Colors.black),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(failedSnackbar);
    }
  }

  String capitalize(String value) {
    var result = value[0].toUpperCase();
    bool cap = true;
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " " && cap == true) {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
        cap = false;
      }
    }
    return result;
  }

  _fetchInstrument() async {
    http.Response response =
        await http.get(Uri.parse('https://adm.imte.education/api/major'));

    final data = await json.decode(response.body);

    for (var a = 0; a < data.length; a++) {
      listInstrument.add(Instrument.fromJson(data[a]));
    }
  }

  _fetchGrade() async {
    http.Response response =
        await http.get(Uri.parse('https://adm.imte.education/api/grade'));

    final data = await json.decode(response.body);

    for (var a = 0; a < data.length; a++) {
      listGrade.add(Grade.fromJson(data[a]));
    }
  }

  _fetchTeacher() async {
    final response = await dio.get('https://adm.imte.education/api/teacher');

    for (var a = 0; a < response.data.length; a++) {
      teacherList.add(response.data[a]);
    }
  }

  _fetchFeed() async {
    String API_URL = 'https://adm.imte.education/api/setup';

    final response = await http.get(Uri.parse(API_URL));

    final data = await json.decode(response.body);

    for (var i = 0; i < data.length; i++) {
      if (data[i]['name'].toString().contains('Feed')) {
        listFeed.add(Gallery.fromJson(data[i]));
      }
    }

    print('conan : ${listFeed.toString()}');
  }

  _checkStatusChip(enrollStatus) {
    if (enrollStatus == 0) {
      return _statusChip("Unverified", Color(0xff686868), Colors.grey);
    } else if (enrollStatus == 1) {
      return _statusChip("Verified", Color(0xff27832B), Color(0xff86E88A));
    } else if (enrollStatus == 2) {
      return _statusChip("Test Taken", Color(0xff007BFF), Color(0xffC9F1FE));
    } else if (enrollStatus == 3) {
      return _statusChip("Result Out", Color.fromARGB(255, 140, 0, 196),
          Color.fromARGB(255, 241, 207, 255));
    }
  }

  Widget _statusChip(statusTitle, statusTitleColor, chipColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: chipColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            statusTitle,
            style: GoogleFonts.poppins(
                fontSize: 14,
                color: statusTitleColor,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  dataNews() async {
    String API_URL = 'https://adm.imte.education/api/blog/showAll';

    final response = await http.get(Uri.parse(API_URL));

    final data = await json.decode(response.body);

    for (var a = 0; a < data.length; a++) {
      listNews.add(News.fromJson(data[a]));
      var itemNews = listNews[a];

      setState(() {
        lastId = itemNews.id.toString();
        lastTitle = itemNews.title.toString();
        lastUser = itemNews.firstName.toString();
        lastDate = itemNews.createdAt;
        lastImage = itemNews.filename.toString();
        lastContent = itemNews.content.toString();
      });
    }

    setState(() {
      loading = false;
    });
  }

  Widget fluidContainer() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
          color: kBlueColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            // bottomRight: Radius.circular(12),
          )),
    );
  }

  Widget textLine(String key, Widget value) {
    return Column(
      children: [
        Row(
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Text(
                  key,
                  style: greyTextStyle.copyWith(
                      fontSize: 16, fontWeight: semiBold),
                )),
            Container(
                width: MediaQuery.of(context).size.width * 0.05,
                child: Text(
                  ':',
                  style: greyTextStyle.copyWith(
                      fontSize: 16, fontWeight: semiBold),
                )),
            value,
          ],
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget _buildFeedCard(index, feed) {
    var image = feed.src;
    var filteredImage = image.replaceAll('./', '');

    return Container(
      margin: EdgeInsets.only(right: 5),
      child: InkWell(
        onTap: () {
          launch(feed.url);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16), // Image border
          child: SizedBox.fromSize(
            size: Size.fromRadius(
              MediaQuery.of(context).size.width * 0.145,
            ),
            child: Image.network('https://imte.education/' + filteredImage),
          ),
        ),
      ),
    );
  }

  Widget buildListviewNews(index) {
    var itemNews = listNews[index];
    DateTime dt = DateTime.parse(itemNews.createdAt);

    return newsCard(
      image: Image.network(
        'https://adm.imte.education/img/BlogImages/' + itemNews.filename,
        fit: BoxFit.fill,
      ),
      newsDate: DateFormat.yMMMd().format(dt),
      newsTitle: itemNews.title,
      newsUser: itemNews.firstName,
      newsImage:
          'https://adm.imte.education/img/BlogImages/' + itemNews.filename,
      newsContent: itemNews.content,
    );
  }

  @override
  void initState() {
    super.initState();
    _profileBloc.add(GetProfileList());
    _enrollBloc.add(GetEnrollList());
    _fetchInstrument();
    _fetchGrade();
    _fetchTeacher();
    _getValData();
    _feedBloc.add(GetFeedList());
    _newsBloc.add(GetNewsList());
  }

  @override
  Widget build(BuildContext context) {
    return _buildEnrollPage();
  }

  Widget _buildEnrollPage() {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: Scaffold(body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: Stack(children: [
              fluidContainer(),
              _headerContent(context),
            ]),
          );
        }),
      )),
    );
  }

  Widget _headerContent(context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocConsumer<GetProfileBloc, GetProfileState>(
                  bloc: _profileBloc,
                  listener: (context, state) {
                    if (state is GetProfileExpired) {
                      _logout();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false);
                      final expiredSnackbar = SnackBar(
                        content:
                            const Text('Token Expired, Please Login Again'),
                        backgroundColor: (Colors.black),
                        action: SnackBarAction(
                          label: 'Close',
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(expiredSnackbar);
                    }
                  },
                  builder: (context, state) {
                    if (state is GetProfileLoaded) {
                      GetProfile profile = state.profileModel;
                      return Row(
                        children: [
                          _profilePicture(),
                          _profileNametag(profile),
                        ],
                      );
                    } else if (state is GetProfileLoading) {
                      return Row(
                        children: [
                          SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              width: 80,
                              height: 80,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkeletonParagraph(
                                style: SkeletonParagraphStyle(
                                    lines: 1,
                                    spacing: 6,
                                    lineStyle: SkeletonLineStyle(
                                      randomLength: true,
                                      height: 20,
                                      borderRadius: BorderRadius.circular(4),
                                      minLength:
                                          MediaQuery.of(context).size.width / 6,
                                      maxLength:
                                          MediaQuery.of(context).size.width / 3,
                                    )),
                              ),
                              SkeletonParagraph(
                                style: SkeletonParagraphStyle(
                                    lines: 1,
                                    spacing: 6,
                                    lineStyle: SkeletonLineStyle(
                                      randomLength: true,
                                      height: 15,
                                      borderRadius: BorderRadius.circular(4),
                                      minLength:
                                          MediaQuery.of(context).size.width / 6,
                                      maxLength:
                                          MediaQuery.of(context).size.width / 3,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else if (state is GetProfileLoaded) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/image/smile.jpg'),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: radiusNormal),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
          _buildActivityBar(),
          _buildEnrollList(),
          Container(
            margin: EdgeInsets.only(top: 30, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Recent News',
                    style: blackTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: semiBold,
                    )),
              ],
            ),
          ),
          // Container(
          //   height: MediaQuery.of(context).size.height * 0.145,
          //   width: MediaQuery.of(context).size.width,
          //   padding: EdgeInsets.all(0),
          //   child: _buildFeedList(),
          // ),
          Divider(thickness: 1),
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: _buildNewsList(),
          ),
        ]),
      ),
    );
  }

  Widget _buildNewsList() {
    return BlocBuilder<NewsBloc, NewsState>(
      bloc: _newsBloc,
      builder: (context, state) {
        if (state is NewsLoaded) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: state.news.length,
              itemBuilder: (context, index) {
                News news = state.news[index];
                return _buildNewsCard(news);
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildNewsCard(news) {
    DateTime dt = DateTime.parse(news.createdAt);

    return newsCard(
      image: Image.network(
          'https://adm.imte.education/img/BlogImages/' + news.filename),
      newsTitle: news.title,
      newsDate: DateFormat.yMMMd().format(dt),
      newsImage: 'https://adm.imte.education/img/BlogImages/' + news.filename,
      newsUser: news.firstName,
      newsContent: news.content,
    );
  }

  Widget _buildFeedList() {
    return BlocBuilder<FeedBloc, FeedState>(
      bloc: _feedBloc,
      builder: (context, state) {
        if (state is FeedLoaded) {
          return ListView.builder(
            padding: EdgeInsets.all(0),
            scrollDirection: Axis.horizontal,
            itemCount: state.feed.length,
            itemBuilder: (BuildContext context, int index) {
              Feed feed = state.feed[index];
              if (feed.name.toString().contains('Feed')) {
                return _buildFeedCard(index, feed);
              } else {
                return Container();
              }
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildActivityBar() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radiusNormal,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), //color of shadow
              spreadRadius: 5, //spread radius
              blurRadius: 10, // blur radius
              offset: Offset(0, 1),
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          (active == 'active')
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddEnrollPage()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: new TextSpan(
                        style: new TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Enroll Here! ',
                              style: greenTextStyle.copyWith(
                                  fontSize: 14, fontWeight: semiBold)),
                        ],
                      ),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    final expiredImte = SnackBar(
                      content: const Text("IMTE Registration has been Closed"),
                      backgroundColor: (Colors.black),
                      action: SnackBarAction(
                        label: 'Close',
                        onPressed: () {},
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(expiredImte);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: new TextSpan(
                        style: new TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Enroll Disabled! ',
                              style: greyTextStyle.copyWith(
                                  fontSize: 14, fontWeight: semiBold)),
                        ],
                      ),
                    ),
                  ),
                ),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => AddEnrollPage()));
          //   },
          //   child: Container(
          //     margin: EdgeInsets.only(right: 15),
          //     child: Text('Enroll',
          // style: (active == 'active')
          //     ? greenTextStyle.copyWith(
          //         fontSize: 16, fontWeight: semiBold)
          //     : greyTextStyle.copyWith(
          //         fontSize: 16, fontWeight: semiBold)),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildEnrollList() {
    return Container(
        height: MediaQuery.of(context).size.height - 550,
        width: MediaQuery.of(context).size.width,
        child: BlocBuilder<EnrollBloc, EnrollState>(
          bloc: _enrollBloc,
          builder: (context, state) {
            if (state is EnrollLoaded) {
              var itemCount = state.enroll.length;
              return ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      BlocProvider.of<EnrollBloc>(context)
                        ..add(GetMoreEnrollList());
                    },
                    child: ListView.builder(
                        itemCount: itemCount,
                        itemBuilder: (BuildContext context, int index) {
                          History enroll = state.enroll[index];
                          Period period = state.period[0];
                          if (enroll.period!.periodName == period.periodName) {
                            return _buildEnrollCard(enroll, index);
                          } else {
                            if (mounted) {
                              itemCount = 1;
                            }
                            return Container(
                                margin: EdgeInsets.only(top: 10),
                                height:
                                    MediaQuery.of(context).size.height - 550,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: radiusNormal,
                                    border: Border.all(
                                        color: Color.fromARGB(
                                            255, 200, 200, 200))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 300,
                                      child: Text(
                                        (statusEnroll == 'active')
                                            ? 'You have never taken the IMTE exam.'
                                            : 'IMTE registration period has closed.',
                                        textAlign: TextAlign.center,
                                        style: greyTextStyle.copyWith(
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
                                ));
                          }
                        }),
                  ));
            } else if (state is EnrollEmpty) {
              return Container(
                  margin: EdgeInsets.only(top: 10),
                  height: MediaQuery.of(context).size.height - 550,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: radiusNormal,
                      border: Border.all(
                          color: Color.fromARGB(255, 200, 200, 200))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        child: Text(
                          (statusEnroll == 'active')
                              ? 'You have never taken the IMTE exam.'
                              : 'IMTE registration period has closed.',
                          textAlign: TextAlign.center,
                          style: greyTextStyle.copyWith(fontSize: 16),
                        ),
                      )
                    ],
                  ));
            } else if (state is EnrollEmpty) {
              return Container();
            } else if (state is EnrollError) {
              return Center(child: Text('${state.message}'));
            } else {
              return Center();
            }
          },
        ));
  }

  Widget _buildEnrollCard(enroll, index) {
    DateTime dt = DateTime.parse(enroll.createdAt);

    return GestureDetector(
      onTap: () {
        _showCardDetail(enroll, index);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 10, left: 0),
        decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(255, 212, 212, 212)),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xffFAFAFA),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
              ),
              padding: EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    enroll.period.periodName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  _checkStatusChip(enroll.enrollStatus)
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  textLine(
                      'Grade',
                      Text(enroll.grade.grade,
                          style: GoogleFonts.poppins(color: Colors.black))),
                  SizedBox(height: 5),
                  textLine(
                      'Major',
                      Text(enroll.major.major,
                          style: GoogleFonts.poppins(color: Colors.black))),
                  SizedBox(height: 5),
                  textLine(
                    'Date',
                    Text(DateFormat.yMMMd().format(dt),
                        style: GoogleFonts.poppins(color: Colors.black)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _showCardDetail(enroll, index) {
    var noSchedule = false;
    DateTime dt = DateTime.parse(enroll.createdAt);

    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      context: context,
      builder: (BuildContext context) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(15),
              height: MediaQuery.of(context).size.height / 1.5,
              decoration: BoxDecoration(
                borderRadius: radiusNormal,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Details",
                                style: blackTextStyle.copyWith(
                                    fontSize: 20, fontWeight: semiBold),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              (enroll.enrollStatus.toString() == '3')
                                  ? GestureDetector(
                                      onTap: () {
                                        if (enroll.enrollStatus.toString() !=
                                            '3') {
                                          Navigator.pop(context);
                                          final failedSnackbar = SnackBar(
                                            content: const Text(
                                                "You can't Scan QR for this Data"),
                                            backgroundColor: (Colors.black),
                                            action: SnackBarAction(
                                              label: 'Close',
                                              onPressed: () {},
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(failedSnackbar);
                                        } else {
                                          scanBarcode(enroll.id.toString());
                                        }
                                      },
                                      child: Icon(
                                        Icons.qr_code_scanner,
                                        color: kBlackColor,
                                        size: 30,
                                      ),
                                    )
                                  : Container(),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  if (enroll.enrollStatus > 1) {
                                    final cantEditedSnackbar = SnackBar(
                                      content: const Text(
                                          "You cant't edit this Data"),
                                      backgroundColor: (Colors.black),
                                      action: SnackBarAction(
                                        label: 'Close',
                                        onPressed: () {},
                                      ),
                                    );

                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(cantEditedSnackbar);
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditEnrollPage(
                                                  enrollId:
                                                      enroll.id.toString(),
                                                  unit: enroll.tabUnitId
                                                      .toString(),
                                                  instrument: enroll.major.id
                                                      .toString(),
                                                  grade: enroll.grade.id
                                                      .toString(),
                                                  teacher: enroll.teacher.id
                                                      .toString(),
                                                  payment: enroll.paymentUrl,
                                                )));
                                  }
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: kBlackColor,
                                  size: 22,
                                ),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close,
                                  color: kBlackColor,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                  SizedBox(height: 10),
                  Text('P2 | 2022',
                      style: blackTextStyle.copyWith(
                          fontSize: 18, fontWeight: semiBold)),
                  SizedBox(height: 10),

                  Row(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Text(
                            'Status',
                            style: greyTextStyle.copyWith(
                                fontSize: 16, fontWeight: semiBold),
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.05,
                          child: Text(
                            ':',
                            style: greyTextStyle.copyWith(
                                fontSize: 16, fontWeight: semiBold),
                          )),
                      _checkStatusChip(enroll.enrollStatus)
                    ],
                  ),

                  Divider(thickness: 1),

                  textLine(
                    'Teacher',
                    Text('${enroll.teacher.firstName}',
                        style: blackTextStyle.copyWith(fontSize: 14)),
                  ),
                  textLine(
                    'Major',
                    Text(enroll.major.major,
                        style: blackTextStyle.copyWith(fontSize: 14)),
                  ),
                  textLine(
                    'Grade',
                    Text(enroll.grade.grade,
                        style: blackTextStyle.copyWith(fontSize: 14)),
                  ),
                  textLine(
                    'Exam Date',
                    Text(DateFormat.yMMMd().format(dt),
                        style: blackTextStyle.copyWith(fontSize: 14)),
                  ),
                  (enroll.schedule != null)
                      ? _scheduleLine(enroll)
                      : Container(),

                  SizedBox(height: 10),
                  Divider(thickness: 1),
                  SizedBox(height: 10),
                  Text('Exam Info :',
                      style: blackTextStyle.copyWith(fontSize: 14)),
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('- Please come 30 minute before the exam start',
                          style: blackTextStyle.copyWith(fontSize: 14)),
                      Text('- Wear proper costume (no sandals/short pants)',
                          style: blackTextStyle.copyWith(fontSize: 14)),
                    ],
                  )),
                  // Container(
                  //   height: MediaQuery.of(context).size.height * 0.15,
                  //   child: detailListView(
                  //     index,
                  //     enroll.activityStatus.split(''),
                  //     enroll.activityFormat.split(','),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _scheduleLine(enroll) {
    String practTime = DateFormat.jm()
        .format(DateFormat("hh:mm:ss").parse(enroll.schedule.practical));
    String examTime = DateFormat.jm()
        .format(DateFormat("hh:mm:ss").parse(enroll.schedule.insKnowledge));

    return Column(
      children: [
        textLine(
          'Pract. Exam',
          Text(practTime, style: blackTextStyle.copyWith(fontSize: 14)),
        ),
        textLine(
          'Instr. Exam',
          Text(examTime, style: blackTextStyle.copyWith(fontSize: 14)),
        ),
        textLine(
          'Room',
          Text(enroll.schedule.practicalRoom,
              style: blackTextStyle.copyWith(fontSize: 14)),
        ),
      ],
    );
  }

  _getValData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.get(
        Uri.parse('https://adm.imte.education/api/activity/getImteStatus'));

    final data = json.decode(response.body);

    setState(() {
      active = data['status'];
      email = prefs.getString("email")!;
    });
  }

  Widget detailListView(index, listNumber, listStatus) {
    var listStat = listStatus;

    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: ListView.builder(
        itemCount: listNumber.length,
        itemBuilder: (context, i) {
          return textLine(
              listStat[i].toString(),
              (listNumber[i].toString() == '1')
                  ? Text(
                      'Done',
                      style: greenTextStyle,
                    )
                  : Text('Not Yet', style: greyTextStyle));
        },
      ),
    );
  }

  Widget _profilePicture() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(
                      enableBack: 'false',
                    )));
      },
      child: Container(
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/smile.jpg'),
                fit: BoxFit.fill,
              ),
              borderRadius: radiusNormal),
        ),
      ),
    );
  }

  Widget _profileNametag(profile) {
    studentName = profile.profile[0].firstName + profile.profile[0].lastName;
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      margin: EdgeInsets.only(left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(profile.profile[0].firstName,
              style: whiteTextStyle.copyWith(
                fontSize: 16,
              )),
          Text(email,
              style: whiteTextStyle.copyWith(
                fontSize: 16,
              )),
        ],
      ),
    );
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
