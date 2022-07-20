import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  // _ProfilePageState createState() => _ProfilePageState(token: this.token);
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String token = '';
  int user = 1;

  var profile;
  // _ProfilePageState({required this.token});
  bool loading = true;

  String dfirst = '';
  String dlast = '';
  String dgender = '';
  String dplace = '';
  String dbirth = '';
  String dmobile = '';
  String dwali = '';
  String dnowali = '';
  String daddress = '';

  @override
  void initState() {
    //you are not allowed to add async modifier to initState
    // Future.delayed(Duration(seconds: 2), () async {});
    super.initState();
    dataProfile();
  }

  dataProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? user = prefs.getInt('user');

    String API_URL = 'https://adm.imte.education/api/user/profile?id=' + user.toString();

    String token = prefs.getString('tokenz').toString();

    final response = await http.get(Uri.parse(API_URL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    });

    final data = await json.decode(response.body);
    setState(() {
      dfirst = data['profile'][0]['first_name'].toString();
      dlast = data['profile'][0]['last_name'].toString();
      dgender = data['profile'][0]['gender'].toString();
      dplace = data['profile'][0]['place'].toString();
      dbirth = data['profile'][0]['date_of_birth'].toString();
      dmobile = data['profile'][0]['mobile'].toString();
      dwali = data['profile'][0]['wali'].toString();
      dnowali = data['profile'][0]['no_wali'].toString();
      daddress = data['profile'][0]['address'].toString();
    });

    print(dfirst);
    print(data['profile'][0]['mobile'].toString());

    loading = false;
  }

  backButton() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon:
              Icon(Icons.arrow_back, color: Color.fromARGB(255, 147, 163, 173)),
        ),
      ],
    );
  }

  photoProfile() {
    return CircleAvatar(
      radius: 52,
      backgroundColor: Color(0xff2398D4),
      child: CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage('assets/image/learn.jpg'),
      ),
    );
  }

  nameTag() {
    return Column(
      children: [
        Text(dfirst + ' ' + dlast,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }

  buttonEdit() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/sign-in');
      },
      child: new Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        width: 150.0,
        height: 40.0,
        decoration: new BoxDecoration(
          color: Color(0xff2398D4),
          borderRadius: new BorderRadius.circular(24.0),
        ),
        child: new Center(
          child: new Text(
            'Edit Profile',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  @override
  gender() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Gender',
          style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xff4F4F4F)),
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xffEDF1FA),
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Text(
                (dgender == 'L') ? "Laki-laki" : "Perempuan",
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(
                    0xff717172,
                  ),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  places() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Place',
          style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xff4F4F4F)),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Color(0xffEDF1FA),
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child: Text(
            dplace == null ? dplace : 'no data',
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(
                  0xff717172,
                )),
          ),
        ),
      ],
    );
  }

  birth() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Birth',
          style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xff4F4F4F)),
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xffEDF1FA),
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Text(
                dbirth == null ? dbirth : 'no data',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(
                    0xff717172,
                  ),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  mobile() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Mobile',
          style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xff4F4F4F)),
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xffEDF1FA),
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Text(
                dmobile == null ? dmobile : 'no data',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(
                    0xff717172,
                  ),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  wali() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Nama Wali',
          style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xff4F4F4F)),
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xffEDF1FA),
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Text(
                dwali == null ? dwali : 'no data',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(
                    0xff717172,
                  ),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  noWali() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Nomor Wali',
          style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xff4F4F4F)),
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xffEDF1FA),
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Text(
                dnowali == null ? dnowali : 'no data',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(
                    0xff717172,
                  ),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  address() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Alamat',
          style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xff4F4F4F)),
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xffEDF1FA),
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Text(
                daddress == null ? daddress : 'no data',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(
                    0xff717172,
                  ),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  Widget form() {
    return Column(
      children: [
        backButton(),
        photoProfile(),
        SizedBox(
          height: 10,
        ),
        nameTag(),
        buttonEdit(),
        gender(),
        places(),
        birth(),
        mobile(),
        wali(),
        noWali(),
        address(),
        SizedBox(
          height: 30,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
            width: double.infinity,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  SizedBox(height: 5),
                  Container(
                    child: Column(children: [
                      (loading == true)
                          ? CircularProgressIndicator(
                              color: Colors.grey,
                            )
                          : form(),
                    ]),
                  ),
                ]),
          ),
        ));
  }
}
