import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../shared/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List unit = [];
  List period = [];
  String nama_periode = '';
  String mulai = '';
  String akhir = '';

  @override
  void initState() {
    super.initState();
    dataUnit();
    dataPeriod();
  }

  dataUnit() async {
    const API_URL = 'https://adm.imte.education/api/unit';

    final response = await http.get(Uri.parse(API_URL));
    final data = json.decode(response.body);

    setState(() {
      unit = data;
    });
  }

  dataPeriod() async {
    const API_URL = 'https://adm.imte.education/api/period';

    final response = await http.get(Uri.parse(API_URL));
    final data = json.decode(response.body);

    setState(() {
      period = data;
      print(period[0]['period_name']);
      nama_periode = period[0]['period_name'];
      mulai = period[0]['start_date'];
      akhir = period[0]['end_date'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ! appbar
      appBar: AppBar(
        title: Image.asset(
          'assets/image/logo.png',
          height: 100,
          width: 100,
          // fit: BoxFit.cover,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(0, 211, 254, 1),
                  Color.fromRGBO(64, 106, 179, 1)
                ]),
          ),
        ),
        actions: <Widget>[
          Row(
            children: [
              Icon(
                Icons.door_back_door_outlined,
              ),
              Padding(
                child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/sign-in');
                    },
                    child: Text(
                      'Login',
                      style: whiteTextStyle.copyWith(),
                    )),
                padding: const EdgeInsets.only(left: 5.0, right: 15.0),
              ),
            ],
          )
        ],
      ),

      //! container
      body: SingleChildScrollView(
          child: Column(
        children: [
          // ! video
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/bg.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),

          Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(10),
              width: double.infinity,
              height: 210,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Color.fromRGBO(0, 211, 254, 1),
                    Color.fromRGBO(64, 106, 179, 1)
                  ])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Challange Your Musical Skill Here!',
                        textAlign: TextAlign.center,
                        style: whiteTextStyle.copyWith(
                          fontSize: 36,
                        ),
                      ),
                      Text(
                        'Creating | Performing | Responding | Instrument Knowledge',
                        textAlign: TextAlign.center,
                        style: whiteTextStyle.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              )),

          // ! image
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 103,
                  backgroundColor: Color.fromARGB(255, 255, 68, 68),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/image/learn.jpg'),
                  ),
                ),
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Creating ',
                        style: blackTextStyle.copyWith(fontSize: 26),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          textAlign: TextAlign.center,
                          style: blackTextStyle.copyWith(fontSize: 14),
                          'Students need to have experience in creating, to be successful musicians and to be successful 21st century citizens.'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 103,
                  backgroundColor: Color.fromARGB(255, 255, 68, 68),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/image/guitar.jpg'),
                  ),
                ),
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Performing ',
                        style: blackTextStyle.copyWith(fontSize: 26),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          textAlign: TextAlign.center,
                          style: blackTextStyle.copyWith(fontSize: 14),
                          'Students need to perform – as singers, as instrumentalists, and in their lives and careers.'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 103,
                  backgroundColor: Color.fromARGB(255, 255, 68, 68),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/image/teach.jpg'),
                  ),
                ),
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Responding',
                        style: blackTextStyle.copyWith(fontSize: 26),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          textAlign: TextAlign.center,
                          style: blackTextStyle.copyWith(fontSize: 14),
                          'Students need to respond to music, as well as to their culture, their community, and their colleagues.'),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '(American Standard of Music Education - NAFME Inspired)',
                        style: blackTextStyle.copyWith(fontSize: 8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ! instruments
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: new TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: new TextStyle(
                            fontSize: 24.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            new TextSpan(text: 'OPEN '),
                            new TextSpan(
                                text: 'for ',
                                style:
                                    new TextStyle(fontWeight: FontWeight.w300)),
                            new TextSpan(text: 'INSTRUMENTALS'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '| Piano | Drum | Acoustic Guitar | Electric Guitar | Vocal | Violin | Flute | Saxophone | Bass |',
                      textAlign: TextAlign.center,
                      style: blackTextStyle.copyWith(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Container(
                          width: 350,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white30,
                                backgroundImage:
                                    AssetImage('assets/image/1.png'),
                              ),
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white30,
                                backgroundImage:
                                    AssetImage('assets/image/2.png'),
                              ),
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white30,
                                backgroundImage:
                                    AssetImage('assets/image/3.png'),
                              ),
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white30,
                                backgroundImage:
                                    AssetImage('assets/image/4.png'),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white30,
                                backgroundImage:
                                    AssetImage('assets/image/5.png'),
                              ),
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white30,
                                backgroundImage:
                                    AssetImage('assets/image/6.png'),
                              ),
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white30,
                                backgroundImage:
                                    AssetImage('assets/image/7.png'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),

          // ! scedhule
          Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            // height: 980,
            color: kMaroonColor,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      'OPEN REGISTRATION',
                      style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: kWhiteColor),
                    ),
                    Divider(
                      height: 50,
                      endIndent: 250,
                      thickness: 5,
                      color: kWhiteColor,
                    ),

                    Text(
                      nama_periode,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: kWhiteColor),
                    ),
                    Text(
                      'REGISTRATION DATE:',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: kWhiteColor),
                    ),
                    SizedBox(height: 10),
                    Text(
                      mulai + ' - ' + akhir,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: kWhiteColor),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/sign-in');
                      },
                      child: new Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        width: 150.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          color: Color.fromRGBO(215, 37, 39, 1),
                          borderRadius: new BorderRadius.circular(24.0),
                        ),
                        child: new Center(
                          child: new Text(
                            'ENROLL NOW',
                            style: new TextStyle(
                                fontSize: 16.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 80),
                    Text(
                      'EXAM \nDATES',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: kWhiteColor,
                      ),
                    ),
                    Divider(
                      height: 50,
                      endIndent: 250,
                      thickness: 5,
                      color: kWhiteColor,
                    ),

                    // ! unit
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: unit.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  unit[index]['unit_name'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  unit[index]['city'],
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  unit[index]['start_date'] +
                                      '-' +
                                      unit[index]['end_date'],
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ]),
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          ),

          // ! update
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 50),
                Text(
                  'IMTE LAST UPDATE',
                  style: blackTextStyle.copyWith(
                      fontSize: 28, fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    launch(
                        'https://www.instagram.com/p/CYbKBpjrpul/?utm_medium=copy_link');
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 350,
                    width: 350,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/image/ban1.png'),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launch(
                        'https://www.instagram.com/p/CYbKBpjrpul/?utm_medium=copy_link');
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 350,
                    width: 350,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/image/ban2.png'),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launch(
                        'https://www.instagram.com/p/CYbKBpjrpul/?utm_medium=copy_link');
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 350,
                    width: 350,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/image/ban3.jpg'),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 50),
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  'IMTE HEAD OFFICE',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 1, 1, 1),
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'address. Puri Anjasmoro Blok E1, No.21, Semarang - Jawa Tengah 50144',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(253, 16, 79, 214),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'email. imte.exam@gmail.com',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(253, 16, 79, 214),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/image/yt.png',
                          width: 15.0,
                          height: 15.0,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          child: Text(
                            'IMTE Exam',
                            style: TextStyle(color: Colors.blue, fontSize: 12),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/image/ig.png',
                          width: 15.0,
                          height: 15.0,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          child: Text(
                            '@itme.education',
                            style: TextStyle(color: Colors.blue, fontSize: 12),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'IMTE | International Music Technology Examination',
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
