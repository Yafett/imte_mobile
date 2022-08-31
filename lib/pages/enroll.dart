import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imte_mobile/models/History.dart';
import 'package:imte_mobile/models/Instrument.dart';
import 'package:imte_mobile/models/Profile.dart';
import 'package:imte_mobile/pages/profile-edit.dart';
import 'package:imte_mobile/pages/profile.dart';
import 'package:imte_mobile/shared/theme.dart';
import 'package:imte_mobile/widget/enroll-card-small.dart';
import 'package:imte_mobile/widget/enroll-card.dart';
import 'package:imte_mobile/widget/enroll-news-card.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../models/Gallery.dart';
import '../models/News.dart';
import '../widget/news-card.dart';

class EnrollPage extends StatefulWidget {
  const EnrollPage({Key? key}) : super(key: key);

  @override
  State<EnrollPage> createState() => _EnrollPageState();
}

// ! remove listview scroll glow
class NoGlow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class _EnrollPageState extends State<EnrollPage> {
  XFile? imageFile;
  String id = '';
  String dlast = '';
  String email = '';
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

  // adm.imte.education/img/blogImage/

  // ! modal Enroll
  showSimpleCustomDialog(BuildContext context) async {
    String? dropdownValue;

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
                            print(instrumentval);
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
                              hintText: photoName == null
                                  ? "Select your Image"
                                  : photoName,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  getFromCamera();
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

  // ! get data status
  dataStatus() async {
    String API_URL = 'https://adm.imte.education/api/activity/getImteStatus';

    final response = await http.get(Uri.parse(API_URL));

    final data = await json.decode(response.body);

    setState(() {
      statusEnroll = data['status'];
    });
  }

  // ! data profile
  dataProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? user = prefs.getInt('user');

    String API_URL =
        'https://adm.imte.education/api/user/profile?id=' + user.toString();

    String token = prefs.getString('tokenz').toString();

    final response = await http.get(Uri.parse(API_URL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    });

    final data = await json.decode(response.body);

    setState(() {
      id = data['profile'][0]['id'].toString();
      dfirst = data['profile'][0]['first_name'].toString();
      dlast = data['profile'][0]['last_name'].toString();
      statusProfile = data['profile'][0]['status'].toString();
      email = prefs.getString("emails")!;
    });

    dataEnroll();
  }

  // ! get data teacher
  dataTeacher() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    http.Response response =
        await http.get(Uri.parse('https://adm.imte.education/api/teacher'));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        teacherList = jsonData;
      });
    }
  }

  // ! get data instrument
  dataInstrument() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    http.Response response =
        await http.get(Uri.parse('https://adm.imte.education/api/major'));

    final data = await json.decode(response.body);

    for (var a = 0; a < data.length; a++) {
      listInstrument.add(Instrument.fromJson(data[a]));
      var itemInstrument = listInstrument[a];

      print(itemInstrument);
    }
  }

  // ! get data grade
  dataGrade() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    http.Response response =
        await http.get(Uri.parse('https://adm.imte.education/api/grade'));

    final data = await json.decode(response.body);

    for (var a = 0; a < data.length; a++) {
      listGrade.add(Grade.fromJson(data[a]));
      var itemGrade = listGrade[a];

      print(itemGrade.grade);
    }
  }

  // ! get image from camera
  getFromCamera() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      photoName = photo!.name;
    });
  }

  // ! get data feed
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

  // ! get data enroll
  dataEnroll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? user = prefs.getInt('user');
    String API_URL = 'https://adm.imte.education/api/enroll/show';

    final response = await http.post(Uri.parse(API_URL), headers: {
      'Accept': 'application/json',
    }, body: {
      'tab_user_id': id,
    });

    print('id : ' + id);

    final data = await json.decode(response.body);

    if (data.length > 1) {
      print(data.length);
      print('filled');
      for (var i = 0; i < data.length; i++) {
        listEnroll.add(History.fromJson(data[i]));
        listPeriod.add(Period.fromJson(data[i]['period']));
        listMajor.add(Major.fromJson(data[i]['major']));
        listGrade.add(Grade.fromJson(data[i]['grade']));
        listTeacher.add(Teacher.fromJson(data[i]['teacher']));
        var itemEnroll = listEnroll[i];

        setState(() {
          activityStatus = itemEnroll.activityStatus;
          isLoading = false;
        });

        var activityFormat = itemEnroll.activityFormat;

        if (itemEnroll.status == '0') {
          status = 'Unverified';
          statusColor = Color(0xff686868);
          statusBackground = Color(0xffD9D9D9);
        } else if (itemEnroll.status == '1') {
          status = 'Verified';
          statusColor = Color(0xff27832B);
          statusBackground = Color(0xff86E88A);
        } else if (itemEnroll.status == '2') {
          status = 'Test Taken';
          statusColor = Color(0xff007BFF);
          statusBackground = Color(0xffC9F1FE);
        } else if (itemEnroll.status == '3') {
          status = 'Result Out';
          statusColor = Color(0xffCF3333);
          statusBackground = Color(0xffFFA8A8);
        }
      }

      setState(() {
        isExist = true;
      });
    }
  }

  // ! get data news
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
      print(itemNews.createdAt);
    }
    DateTime dt = DateTime.parse(lastDate);

    print(DateFormat.yMMMd().format(dt));

    setState(() {
      loading = false;
    });
  }

  // ! background header
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

  // ! textLine for list card enroll
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

  // ! listView enroll
  Widget buildListview(index) {
    var itemEnroll = listEnroll[index];
    var itemGrade = listGrade[index];
    var itemMajor = listMajor[index];
    var itemTeacher = listTeacher[index];
    var itemPeriod = listPeriod[index];
    DateTime dt = DateTime.parse(itemEnroll.createdAt);

    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
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
                                'Details',
                                style: blackTextStyle.copyWith(fontSize: 20),
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
                  SizedBox(height: 20),
                  textLine(
                    'Name',
                    Text((dfirst).toLowerCase(),
                        style: blackTextStyle.copyWith(fontSize: 14)),
                  ),
                  textLine(
                    'Teacher',
                    Text(itemTeacher.firstName.toString().toLowerCase(),
                        style: blackTextStyle.copyWith(fontSize: 14)),
                  ),
                  textLine(
                    'Date',
                    Text(DateFormat.yMMMd().format(dt),
                        style: blackTextStyle.copyWith(fontSize: 14)),
                  ),
                  textLine(
                    'Major',
                    Text(itemMajor.major,
                        style: blackTextStyle.copyWith(fontSize: 14)),
                  ),
                  textLine(
                    'Grade',
                    Text(itemGrade.grade,
                        style: blackTextStyle.copyWith(fontSize: 14)),
                  ),
                  Divider(thickness: 1),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: detailListView(
                          index,
                          itemEnroll.activityStatus.split(''),
                          itemEnroll.activityFormat.split(','))),
                  InkWell(
                    onTap: () {},
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: radiusNormal),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'View Result',
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(height: 5),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/certificate');
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: radiusNormal),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'View Certificate',
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        )),
                  )
                ],
              ),
            );
          },
        );
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
                // ! verified
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
                        itemPeriod.periodName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: statusBackground,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              status,
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: statusColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
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
                          Text(itemGrade.grade,
                              style: GoogleFonts.poppins(color: Colors.black))),
                      SizedBox(height: 5),
                      textLine(
                          'Major',
                          Text(itemMajor.major,
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
              ])),
    );
  }

  // ! listView Feed
  Widget buildFeedList(index) {
    var itemFeed = listFeed[index];
    var image = itemFeed.src;
    var mii = image.replaceAll('./', '');

    return Container(
      margin: EdgeInsets.only(right: 5),
      child: InkWell(
        onTap: () {
          launch(itemFeed.url);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16), // Image border
          child: SizedBox.fromSize(
            size: Size.fromRadius(
              MediaQuery.of(context).size.width * 0.145,
            ), // Image radius
            child: Image.network('https://imte.education/' + mii),
          ),
        ),
      ),
    );
  }

  // ! listView news
  Widget buildListviewNews(index) {
    var itemNews = listNews[index];
    DateTime dt = DateTime.parse(itemNews.createdAt);

    return newsCard(
      title: itemNews.title,
      user: itemNews.firstName,
      date: DateFormat.yMMMd().format(dt),
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

  // ! detail listview enroll
  Widget detailListView(index, listNumber, listStatus) {
    var listNum = listNumber;
    var listStat = listStatus;

    return ScrollConfiguration(
      behavior: NoGlow(),
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

  Widget loadingNews() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'No Updated News',
          style: GoogleFonts.poppins(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget profilePicture() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileEditPage(
                      enableBack: 'true',
                    )));
      },
      child: Container(
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/learn.jpg'),
                fit: BoxFit.fill,
              ),
              borderRadius: radiusNormal),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    dataProfile();
    dataTeacher();
    dataInstrument();
    dataGrade();

    dataStatus();
    dataFeed();
    dataNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 350) {
          return SingleChildScrollView(
            child: Stack(children: [
              fluidContainer(),
              Container(
                padding: EdgeInsets.all(15),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child:

                          // ! Section Header
                          Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              profilePicture(),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                margin: EdgeInsets.only(left: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text((dfirst).toLowerCase() + ' ',
                                        style: whiteTextStyle.copyWith(
                                          fontSize: 16,
                                        )),
                                    Text(email,
                                        style: whiteTextStyle.copyWith(
                                          fontSize: 16,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: radiusNormal,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.1), //color of shadow
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
                                  fontWeight: semi,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  child: Container(
                                    width: MediaQuery.of(context).size.height *
                                        0.10,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    decoration: BoxDecoration(
                                      color: (statusEnroll == 'active')
                                          ? Color.fromARGB(255, 255, 166, 0)
                                          : Colors.grey,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Refresh',
                                            style: blackTextStyle.copyWith(
                                              fontSize: 16,
                                            )),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    (statusEnroll == 'active')
                                        ? dataProfile()
                                        : null;
                                  },
                                ),
                                InkWell(
                                  child: Container(
                                    width: MediaQuery.of(context).size.height *
                                        0.10,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                      color: (statusEnroll == 'active')
                                          ? Color.fromARGB(255, 157, 20, 20)
                                          : Colors.grey,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Enroll',
                                            style: whiteTextStyle.copyWith(
                                              fontSize: 16,
                                            )),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    (statusEnroll == 'active')
                                        ? showSimpleCustomDialog(context)
                                        : null;
                                  },
                                ),
                              ],
                            ),
                          ]),
                    ),

                    // ! Listview Enroll
                    Container(
                        height: MediaQuery.of(context).size.height - 550,
                        width: MediaQuery.of(context).size.width,
                        child: !isExist
                            ? Container(
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
                                ))
                            : ScrollConfiguration(
                                behavior: NoGlow(),
                                child: ListView.builder(
                                    itemCount: listEnroll.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return buildListview(index);
                                    }))),

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

                    // ! list Feed
                    Container(
                      height: MediaQuery.of(context).size.height * 0.145,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(0),
                      child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        scrollDirection: Axis.horizontal,
                        itemCount: listFeed.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildFeedList(index);
                        },
                      ),
                    ),
                    Divider(thickness: 1),

                    // ! list News
                    loading
                        ? loadingNews()
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: ScrollConfiguration(
                                behavior: NoGlow(),
                                child: ListView.builder(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    itemCount: listNews.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return buildListviewNews(index);
                                    })),
                          )
                  ]),
                ),
              ),
            ]),
          );
        }

        // ! Small screens
        // return SingleChildScrollView(
        //   child: Stack(children: [
        //     Container(
        //       height: MediaQuery.of(context).size.height * 0.20,
        //       width: double.infinity,
        //       decoration: BoxDecoration(
        //           color: Color(0xff0DB1BF),
        //           borderRadius: BorderRadius.only(
        //             bottomLeft: Radius.circular(12),
        //             bottomRight: Radius.circular(12),
        //           )),
        //     ),
        //     Container(
        //       padding: EdgeInsets.all(10),
        //       child: Container(
        //         width: MediaQuery.of(context).size.width,
        //         // color: Colors.red,
        //         child: Column(children: [
        //           Container(
        //             margin: EdgeInsets.symmetric(vertical: 15),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 Row(
        //                   children: [
        //                     GestureDetector(
        //                       onTap: () {
        //                         Navigator.push(
        //                             context,
        //                             MaterialPageRoute(
        //                                 builder: (context) => ProfilePage(
        //                                       enableBack: 'true',
        //                                     )));
        //                       },
        //                       child: Container(
        //                         child: Container(
        //                           height: 70,
        //                           width: 70,
        //                           decoration: BoxDecoration(
        //                               color: Colors.red,
        //                               image: DecorationImage(
        //                                 image: AssetImage(
        //                                     'assets/image/learn.jpg'),
        //                                 fit: BoxFit.fill,
        //                               ),
        //                               borderRadius: BorderRadius.circular(12)),
        //                         ),
        //                       ),
        //                     ),
        //                     Container(
        //                       width: 100,
        //                       margin: EdgeInsets.only(left: 12),
        //                       child: Column(
        //                         crossAxisAlignment: CrossAxisAlignment.start,
        //                         mainAxisAlignment: MainAxisAlignment.center,
        //                         children: [
        //                           Text(
        //                             'Yafhet Rama',
        //                             style: GoogleFonts.poppins(
        //                               color: Colors.white,
        //                               fontSize: 14,
        //                               fontWeight: FontWeight.w500,
        //                             ),
        //                           ),
        //                           Text(
        //                             '0821317391',
        //                             style: GoogleFonts.poppins(
        //                               color: Colors.white,
        //                               fontSize: 12,
        //                               fontWeight: FontWeight.w400,
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ],
        //             ),
        //           ),
        //           InkWell(
        //             child: Container(
        //               width: MediaQuery.of(context).size.height,
        //               height: MediaQuery.of(context).size.height * 0.05,
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(12),
        //                 color: Color(0xffAE2329),
        //               ),
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Text('Enroll',
        //                       style: GoogleFonts.poppins(
        //                         fontSize: 16,
        //                         fontWeight: FontWeight.w500,
        //                         color: Colors.white,
        //                       )),
        //                 ],
        //               ),
        //             ),
        //             onTap: () {
        //               showModalBottomSheet(
        //                   shape: RoundedRectangleBorder(
        //                       borderRadius: BorderRadius.vertical(
        //                           top: Radius.circular(12.0))),
        //                   backgroundColor: Color.fromARGB(255, 255, 255, 255),
        //                   context: context,
        //                   isScrollControlled: true,
        //                   builder: (context) => Padding(
        //                         padding: const EdgeInsets.symmetric(
        //                             horizontal: 18, vertical: 18),
        //                         child: Column(
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           mainAxisSize: MainAxisSize.min,
        //                           children: <Widget>[
        //                             Container(
        //                               padding:
        //                                   EdgeInsets.symmetric(horizontal: 20),
        //                               child: Column(
        //                                 mainAxisAlignment:
        //                                     MainAxisAlignment.start,
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.start,
        //                                 children: [
        //                                   Text(
        //                                     'Enroll Now',
        //                                     style: GoogleFonts.poppins(
        //                                         fontWeight: FontWeight.w500,
        //                                         fontSize: 24),
        //                                   ),
        //                                   Divider(thickness: 2, height: 20),
        //                                   SizedBox(height: 6),
        //                                   Text('Teacher Name',
        //                                       style: TextStyle(fontSize: 16)),
        //                                   SizedBox(height: 5),
        //                                   SizedBox(
        //                                     height: 20,
        //                                   ),
        //                                   InkWell(
        //                                     onTap: () {
        //                                       // scanBarcode();
        //                                     },
        //                                     child: Container(
        //                                       padding: EdgeInsets.all(15),
        //                                       width: MediaQuery.of(context)
        //                                           .size
        //                                           .width,
        //                                       decoration: BoxDecoration(
        //                                         color: Color.fromARGB(
        //                                             255, 25, 133, 133),
        //                                         borderRadius:
        //                                             BorderRadius.circular(12),
        //                                       ),
        //                                       child: Row(
        //                                         mainAxisAlignment:
        //                                             MainAxisAlignment.center,
        //                                         children: [
        //                                           const Text("Pick Image",
        //                                               style: TextStyle(
        //                                                   color: Colors.white70,
        //                                                   fontWeight:
        //                                                       FontWeight.bold)),
        //                                         ],
        //                                       ),
        //                                     ),
        //                                   ),
        //                                   SizedBox(
        //                                     height: 20,
        //                                   ),
        //                                   InkWell(
        //                                     onTap: () {},
        //                                     child: Container(
        //                                       padding: EdgeInsets.all(15),
        //                                       width: MediaQuery.of(context)
        //                                           .size
        //                                           .width,
        //                                       decoration: BoxDecoration(
        //                                         color: Color(0xffAE2329),
        //                                         borderRadius:
        //                                             BorderRadius.circular(12),
        //                                       ),
        //                                       child: Row(
        //                                         mainAxisAlignment:
        //                                             MainAxisAlignment.center,
        //                                         children: [
        //                                           const Text("Enroll Now",
        //                                               style: TextStyle(
        //                                                   color: Colors.white70,
        //                                                   fontWeight:
        //                                                       FontWeight.bold)),
        //                                         ],
        //                                       ),
        //                                     ),
        //                                   ),
        //                                 ],
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ));
        //             },
        //           ),
        //           Container(
        //             margin: EdgeInsets.only(top: 10),
        //             padding: EdgeInsets.all(10),
        //             width: MediaQuery.of(context).size.width,
        //             decoration: BoxDecoration(
        //                 color: Colors.white,
        //                 borderRadius: BorderRadius.circular(12),
        //                 boxShadow: [
        //                   BoxShadow(
        //                     color:
        //                         Colors.grey.withOpacity(0.1), //color of shadow
        //                     spreadRadius: 5, //spread radius
        //                     blurRadius: 10, // blur radius
        //                     offset: Offset(0, 2),
        //                   ),
        //                 ]),
        //             child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   Text('Activity'),
        //                   Icon(
        //                     Icons.refresh_outlined,
        //                     color: Color.fromARGB(255, 0, 0, 0),
        //                     size: 26,
        //                   ),
        //                 ]),
        //           ),
        return Container();
        // Container(
        //   height: MediaQuery.of(context).size.height - 550,
        //   width: MediaQuery.of(context).size.width,
        //   child: ListView(
        //     padding: const EdgeInsets.all(0),
        //     children: <Widget>[
        //       enrollCardSmall(
        //         textPeriod: 'P2 | 2022',
        //         textGrade: 'Piano - JC - Classical',
        //         textCourse: 'Prsnt',
        //         color: Colors.red,
        //       ),
        //       enrollCardSmall(
        //         textPeriod: 'P1 | 2021',
        //         textGrade: 'Drum - CFK',
        //         textCourse: 'Leve',
        //         color: Colors.grey,
        //       ),
        // enrollCardSmall(
        //         textPeriod: 'P1 | 2021',
        //         textGrade: 'Bass - CFK',
        //         textCourse: 'Prsnt',
        //         color: Colors.green,
        //       ),
        //     ],
        //   ),
        // ),
        //           Container(
        //             margin: EdgeInsets.only(top: 50, bottom: 10),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               children: [
        //                 Text(
        //                   'Recent News',
        //                   style: GoogleFonts.poppins(
        //                     color: Color.fromARGB(255, 0, 0, 0),
        //                     fontSize: 20,
        //                     fontWeight: FontWeight.w500,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //           Container(
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 GestureDetector(
        //                   onTap: () {
        //                     launch(
        //                         'https://www.instagram.com/p/CYbKBpjrpul/?utm_medium=copy_link');
        //                   },
        //                   child: Container(
        //                     child: ClipRRect(
        //                       borderRadius:
        //                           BorderRadius.circular(12), // Image border
        //                       child: SizedBox.fromSize(
        //                         size: Size.fromRadius(
        //                           MediaQuery.of(context).size.width * 0.15,
        //                         ), // Image radius
        //                         child: Image.asset('assets/image/ban2.png'),
        //                       ),
        //                     ),
        //                     decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(12)),
        //                   ),
        //                 ),
        //                 GestureDetector(
        //                   onTap: () {
        //                     launch(
        //                         'https://www.instagram.com/p/CYbKBpjrpul/?utm_medium=copy_link');
        //                   },
        //                   child: Container(
        //                     child: ClipRRect(
        //                       borderRadius:
        //                           BorderRadius.circular(12), // Image border
        //                       child: SizedBox.fromSize(
        //                         size: Size.fromRadius(
        //                           MediaQuery.of(context).size.width * 0.15,
        //                         ), // Image radius
        //                         child: Image.asset('assets/image/ban1.png'),
        //                       ),
        //                     ),
        //                     decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(12)),
        //                   ),
        //                 ),
        //                 GestureDetector(
        //                   onTap: () {
        //                     launch(
        //                         'https://www.instagram.com/p/CYbKBpjrpul/?utm_medium=copy_link');
        //                   },
        //                   child: Container(
        //                     child: ClipRRect(
        //                       borderRadius:
        //                           BorderRadius.circular(12), // Image border
        //                       child: SizedBox.fromSize(
        //                         size: Size.fromRadius(
        //                           MediaQuery.of(context).size.width * 0.15,
        //                         ), // Image radius
        //                         child: Image.asset('assets/image/ban3.jpg'),
        //                       ),
        //                     ),
        //                     decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(12)),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //           Container(
        //             child: Column(children: [
        //               enrollNewsCard(
        //                 title:
        //                     'Why NFT Creators Are Picking Arweave Over IPFS (What Solana And Metaplex Have Known For Some Time Now)',
        //                 user: 'Mr. Yafet',
        //                 date: '15 - 07 - 2022',
        //                 image: Image.network(
        //                   'https://uploads-ssl.webflow.com/61c8ba3864049fa06a524bbd/61e2a0ac1ee9e1696610c78d_3.jpg',
        //                   fit: BoxFit.cover,
        //                 ),
        //               ),
        //               enrollNewsCard(
        //                 title: 'Metaplex Protocol: Fueling Solana (NFT) Summer',
        //                 user: 'Mrs. Lidya',
        //                 date: '12 - 07 - 2022',
        //                 image: Image.network(
        //                     fit: BoxFit.cover,
        //                     'https://cdn.sanity.io/images/2bt0j8lu/production/1e83eae3c3b81ae83ff33fb0f0e1218538bd9221-1280x720.png?w=714&fit=max&auto=format&dpr=3'),
        //               ),
        //             ]),
        //           )
        //         ]),
        //       ),
        //     ),
        //   ]),
        // );
      }),
    ));
  }
}
