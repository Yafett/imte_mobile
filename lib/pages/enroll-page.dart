// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
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
import 'package:imte_mobile/pages/history-page.dart';
import 'package:imte_mobile/shared/theme.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../bloc/get-profile_bloc/getProfile_bloc.dart';
import '../models/gallery-model.dart';
import '../widget/news-card.dart';

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

  showSimpleCustomDialog(BuildContext context) async {
    Widget simpleDialog1 = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enroll Now',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 30),
                    ),
                    Divider(thickness: 2, height: 20),
                    SizedBox(height: 6),

                    // ! teacher
                    Text('Teacher', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      padding:
                          EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButton(
                        underline: SizedBox(),
                        isExpanded: true,
                        hint: Text('Select Your Teacher'),
                        items: teacherList.map((item) {
                          return DropdownMenuItem(
                            value: item['first_name'].toString(),
                            child: Text(item['first_name'].toString()),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            teacherval = newVal;
                          });
                        },
                        value: teacherval,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    // ! instruments
                    Text('Instrument', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      padding:
                          EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButton(
                        underline: SizedBox(),
                        isExpanded: true,
                        hint: Text('Select Your Instruments'),
                        items: listInstrument.map((item) {
                          return DropdownMenuItem(
                            value: item.major.toString(),
                            child: Text(item.major.toString()),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            instrumentval = newVal;
                          });
                        },
                        value: instrumentval,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    // ! grade
                    Text('Grade', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      padding:
                          EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButton(
                        underline: SizedBox(),
                        isExpanded: true,
                        hint: Text('Select Your Grade'),
                        items: (instrumentval != 'Piano')
                            ? instrument.map((item) {
                                return DropdownMenuItem(
                                  value: item.toString(),
                                  child: Text(item.toString()),
                                );
                              }).toList()
                            : instrument2.map((item) {
                                return DropdownMenuItem(
                                  value: item.toString(),
                                  child: Text(item.toString()),
                                );
                              }).toList(),
                        //  gradeList.map((item) {
                        //   return DropdownMenuItem(
                        //     value: item['grade'].toString(),
                        //     child: Text(item['grade'].toString()),
                        //   );
                        // }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            gradeval = newVal;
                          });
                        },
                        value: gradeval,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    // ! pickImage
                    Text('Payment Receipt'),
                    SizedBox(height: 10),
                    Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              // ignore: unnecessary_null_comparison
                              hintText: photoName == null
                                  ? "Select your Image"
                                  : photoName,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  _getFromCamera();
                                },
                                child: Container(
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Color.fromARGB(255, 28, 28, 28),
                                    size: 26,
                                  ),
                                ),
                              )),
                        )),
                    SizedBox(height: 20),

                    // ! button
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color(0xffAE2329),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Enroll Now",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );

    showDialog(
        context: context, builder: (BuildContext context) => simpleDialog1);
  }

  dataInstrument() async {
    http.Response response =
        await http.get(Uri.parse('https://adm.imte.education/api/major'));

    final data = await json.decode(response.body);

    for (var a = 0; a < data.length; a++) {
      listInstrument.add(Instrument.fromJson(data[a]));
    }
  }

  dataGrade() async {
    http.Response response =
        await http.get(Uri.parse('https://adm.imte.education/api/grade'));

    final data = await json.decode(response.body);

    for (var a = 0; a < data.length; a++) {
      listGrade.add(Grade.fromJson(data[a]));
    }
  }

  _getFromCamera() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      photoName = photo!.name;
    });
  }

  dataFeed() async {
    String API_URL = 'https://adm.imte.education/api/setup';

    final response = await http.get(Uri.parse(API_URL));

    final data = await json.decode(response.body);

    for (var i = 0; i < data.length; i++) {
      if (data[i]['name'] == 'feed') {
        listFeed.add(Gallery.fromJson(data[i]));
      }
    }
  }

  _checkStatusChip(enrollStatus) {
    if (enrollStatus == 0) {
      return _statusChip("Unverified", Color(0xff686868), Colors.grey);
    } else if (enrollStatus == 1) {
      return _statusChip("Verified", Color(0xff27832B), Color(0xff86E88A));
    } else if (enrollStatus == 2) {
      return _statusChip("Test Taken", Color(0xff007BFF), Color(0xffC9F1FE));
    } else if (enrollStatus == 3) {
      return _statusChip("Result Out", Color(0xffCF3333), Color(0xffFFA8A8));
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
            bottomRight: Radius.circular(12),
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
    var mii = image.replaceAll('./', '');

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
            child: Image.network('https://imte.education/' + mii),
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
    dataInstrument();
    dataGrade();
    _getValData();
    _feedBloc.add(GetFeedList());
    _enrollBloc.add(GetEnrollList());
    _profileBloc.add(GetProfileList());
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
                BlocBuilder<GetProfileBloc, GetProfileState>(
                  bloc: _profileBloc,
                  builder: (context, state) {
                    if (state is GetProfileLoaded) {
                      GetProfile profile = state.profileModel;
                      return Row(
                        children: [
                          _profilePicture(),
                          _profileNametag(profile),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
          _buildActivityBar(context),
          _buildEnrollList(context),
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
          Container(
            height: MediaQuery.of(context).size.height * 0.145,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(0),
            child: _buildFeedList(),
          ),
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
          print(state);
          return ListView.builder(
            padding: EdgeInsets.all(0),
            scrollDirection: Axis.horizontal,
            itemCount: state.feed.length,
            itemBuilder: (BuildContext context, int index) {
              Feed feed = state.feed[index];
              if (feed.name == 'feed') {
                print(feed.src);
                return _buildFeedCard(index, feed);
              } else {
                return Container();
              }
            },
          );
        } else {
          print(state);
          return Container();
        }
      },
    );
  }

  Widget _buildActivityBar(BuildContext context) {
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
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'Activity',
              style: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: semiBold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showSimpleCustomDialog(context);
            },
            child: Container(
              margin: EdgeInsets.only(right: 15),
              child: Text('Enroll',
                  style: (active == 'active')
                      ? greenTextStyle.copyWith(
                          fontSize: 16, fontWeight: semiBold)
                      : greyTextStyle.copyWith(
                          fontSize: 16, fontWeight: semiBold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollList(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height - 550,
        width: MediaQuery.of(context).size.width,
        child: BlocBuilder<EnrollBloc, EnrollState>(
          bloc: _enrollBloc,
          builder: (context, state) {
            if (state is EnrollLoaded) {
              return ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: RefreshIndicator(
                    onRefresh: () async =>
                        context.read<EnrollBloc>().add(GetMoreEnrollList()),
                    child: ListView.builder(
                        itemCount: state.enroll.length,
                        itemBuilder: (BuildContext context, int index) {
                          History enroll = state.enroll[index];
                          Period period = state.period[0];
                          if (enroll.period!.periodName == period.periodName) {
                            return _buildEnrollCard(enroll, index);
                          } else {
                            return Container();
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
    DateTime dt = DateTime.parse(enroll.createdAt);

    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height,
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
                    ]),
              ),
              SizedBox(height: 10),
              Text('P2 | 2022',
                  style: blackTextStyle.copyWith(
                      fontSize: 18, fontWeight: semiBold)),
              SizedBox(height: 10),
              textLine(
                'Grade',
                Text(enroll.grade.grade,
                    style: blackTextStyle.copyWith(fontSize: 14)),
              ),
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
                'Name',
                Text('${enroll.teacher.firstName} ${enroll.teacher.lastName}',
                    style: blackTextStyle.copyWith(fontSize: 14)),
              ),
              textLine(
                'Teacher',
                Text('${enroll.teacher.firstName} ${enroll.teacher.lastName}',
                    style: blackTextStyle.copyWith(fontSize: 14)),
              ),
              textLine(
                'Date',
                Text(DateFormat.yMMMd().format(dt),
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
              Divider(thickness: 1),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                child: detailListView(
                  index,
                  enroll.activityStatus.split(''),
                  enroll.activityFormat.split(','),
                ),
              ),
            ],
          ),
        );
      },
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
        Navigator.pushNamed(context, '/profile');
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
}
