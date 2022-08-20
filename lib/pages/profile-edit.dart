import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:imte_mobile/pages/dashboard.dart';
import 'package:imte_mobile/pages/profile.dart';
import 'package:imte_mobile/shared/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'enroll.dart';

class ProfileEditPage extends StatefulWidget {
  final String enableBack;

  const ProfileEditPage({Key? key, required this.enableBack}) : super(key: key);

  @override
  // _ProfileEditPageStat  e createState() => _ProfileEditPageState();
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  TextEditingController genderController = new TextEditingController();
  TextEditingController firstnameController = new TextEditingController();
  TextEditingController lastnameController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController placeController = new TextEditingController();
  TextEditingController birthController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController waliController = new TextEditingController();
  TextEditingController noWaliController = new TextEditingController();

  int user = 1;

  var profile;
  bool buttonLoading = false;
  var photoName = '';
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
  String dcity = '';

  @override
  void initState() {
    super.initState();
    dataProfile();
    checkBack();
    print(checkBack());
  }

  // ! get Data from Camera
  getFromCamera() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      photoName = photo!.name;
    });
  }

  // ! get data Profile
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
      dfirst = data['profile'][0]['first_name'].toString();
      dlast = data['profile'][0]['last_name'].toString();
      dgender = data['profile'][0]['gender'].toString();
      dplace = data['profile'][0]['place'].toString();
      dbirth = data['profile'][0]['date_of_birth'].toString();
      dmobile = data['profile'][0]['mobile'].toString();
      dwali = data['profile'][0]['wali'].toString();
      dnowali = data['profile'][0]['no_wali'].toString();
      daddress = data['profile'][0]['address'].toString();
      dcity = data['profile'][0]['city'].toString();
      firstnameController.text = dfirst;
      lastnameController.text = dlast;
      genderController.text = dgender;
      placeController.text = dplace;
      mobileController.text = dmobile;
      waliController.text = dwali;
      noWaliController.text = dnowali;
      cityController.text = dcity;
      addressController.text = daddress;
      birthController.text = dbirth;
    });

    loading = false;
  }

  // ! edit data Profile
  editProfile() async {
    Map data = {
      "first_name": firstnameController.text,
      "last_name": lastnameController.text,
      "gender": genderController.text,
      "place": placeController.text,
      "date_of_birth": birthController.text,
      "mobile": mobileController.text,
      "address": addressController.text,
      "wali": waliController.text,
      "city": cityController.text,
      "no_wali": noWaliController.text,
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('tokenz').toString();

    int? user = prefs.getInt('user');
    var response = await http.put(
        Uri.parse(
            'https://adm.imte.education/api/user/updatev2/' + user.toString()),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer ' + token
        },
        body: data);

    final result = await json.decode(response.body);
    print(result['message']);
    print(data);

    if (result['message'] == "Update User Profile Berhasil.") {
      var snackBar = SnackBar(content: Text('Update User Profile Berhasil.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => DashboardPage(
                    token: token,
                  )),
          (route) => false);
    } else {
      var snackBar =
          SnackBar(content: Text('Terjadi Kesalahan, Gagal Mengupdate Data'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      loading = true;
    });
  }

  // ! back button !isExist
  checkBack() {
    return (widget.enableBack == 'true') ? 'true' : 'false';
  }

  // ! backButton
  Widget backButton() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,
              color: Color.fromARGB(255, 147, 163, 173)),
        ),
      ],
    );
  }

  // ! form Part
  Widget photoProfile() {
    return GestureDetector(
      onTap: () {
        getFromCamera();
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            color: Colors.red,
            image: DecorationImage(
              image: AssetImage('assets/image/smile.jpg'),
              fit: BoxFit.fill,
            ),
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget nameTag() {
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

  Widget gender() {
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
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: TextFormField(
                controller: genderController,
                style: TextStyle(color: Color(0xff4F4F4F)),
                decoration: new InputDecoration.collapsed(
                  hintText: dgender,
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  Widget firstName() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'First Name',
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
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: TextFormField(
                controller: firstnameController,
                style: TextStyle(color: Color(0xff4F4F4F)),
                decoration: new InputDecoration.collapsed(
                  hintText: (dfirst == null) ? '-' : dfirst,
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  Widget lastName() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Last Name',
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
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: TextFormField(
                controller: lastnameController,
                style: TextStyle(color: Color(0xff4F4F4F)),
                decoration: new InputDecoration.collapsed(
                  hintText: dlast,
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  Widget mobile() {
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
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: TextFormField(
                controller: mobileController,
                style: TextStyle(color: Color(0xff4F4F4F)),
                decoration: new InputDecoration.collapsed(
                  hintText: dmobile,
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  Widget place() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'PLace',
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
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: TextFormField(
                controller: placeController,
                style: TextStyle(color: Color(0xff4F4F4F)),
                decoration: new InputDecoration.collapsed(
                  hintText: dplace,
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  Widget date() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Date of Birth',
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
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: TextFormField(
                controller: birthController,
                style: TextStyle(color: Color(0xff4F4F4F)),
                decoration: new InputDecoration.collapsed(
                  hintText: dbirth,
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  Widget address() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Address',
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
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: TextFormField(
                controller: addressController,
                style: TextStyle(color: Color(0xff4F4F4F)),
                decoration: new InputDecoration.collapsed(
                  hintText: daddress,
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  Widget city() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'City',
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
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: TextFormField(
                controller: cityController,
                style: TextStyle(color: Color(0xff4F4F4F)),
                decoration: new InputDecoration.collapsed(
                  hintText: (dcity == null) ? '-' : dcity,
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  Widget wali() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Wali',
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
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: TextFormField(
                controller: waliController,
                style: TextStyle(color: Color(0xff4F4F4F)),
                decoration: new InputDecoration.collapsed(
                  hintText: dwali,
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  Widget noWali() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Wali Number',
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
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: TextFormField(
                controller: noWaliController,
                style: TextStyle(color: Color(0xff4F4F4F)),
                decoration: new InputDecoration.collapsed(
                  hintText: dnowali,
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
  // ! form Part end

  // ! loading Bar
  Widget loadingBar() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 5,
            color: Color.fromARGB(255, 70, 111, 234),
          ),
        ],
      ),
    );
  }

  // ! form
  Widget form() {
    return Column(
      children: [
        (checkBack() == 'true') ? backButton() : Container(),
        photoProfile(),
        SizedBox(
          height: 10,
        ),
        // nameTag(),
        firstName(),
        lastName(),
        mobile(),
        place(),
        date(),
        address(),
        city(),
        wali(),
        noWali(),
        gender(),
        Container(
            margin: EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.065,
            child: TextButton(
              onPressed: () {
                editProfile();
              },
              style: TextButton.styleFrom(
                  backgroundColor: kBlueColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: Text(
                (buttonLoading == true) ? "Loading..." : 'Edit ',
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(249, 255, 255, 255)),
              ),
            )),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Column(children: [
                        form(),
                      ]),
                    ),
                  ]),
            ),
          ),
        ));
  }
}
