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

  String _title = 'Radio Button Example';

  var genderList = ['Laki-laki', 'Perempuan'];
  var genderval;

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
      genderval = dgender == 'L' ? 'Laki-laki' : 'Perempuan';
    });

    loading = false;
  }

  // ! edit data Profile
  editProfile() async {
    Map data = {
      "first_name": firstnameController.text,
      "last_name": lastnameController.text,
      "gender": genderval == 'Perempuan' ? 'P' : 'L',
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
                  backgroundColor: Color(0xff1F98A8),
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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFFF0F0F0),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, 37, 37, 37),
              size: 25,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                editProfile();
              },
              child: Container(
                margin: EdgeInsets.only(right: 15),
                child: Chip(
                  backgroundColor: kBlueColor,
                  label: Text('save',
                      style: whiteTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      )),
                ),
              ),
            )
          ],
          title: Text(
            'My Profile',
            style: blackTextStyle.copyWith(
              fontSize: 20,
              fontWeight: semiBold,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width,
              child: Column(children: [
                SizedBox(height: 10),
                Container(
                    color: Color(0xFFF0F0F0),
                    height: MediaQuery.of(context).size.height * 0.18,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Profile Image',
                                style: blackTextStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: semiBold,
                                )),
                            InkWell(
                              onTap: () {
                                getFromCamera();
                              },
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    image: DecorationImage(
                                      image:
                                          AssetImage('assets/image/smile.jpg'),
                                      fit: BoxFit.fill,
                                    ),
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: radiusNormal),
                              ),
                            ),
                            Text('Change',
                                style: blackTextStyle.copyWith(fontSize: 14)),
                          ],
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            "Put your best profile picture!.",
                            style: blackTextStyle.copyWith(fontSize: 14),
                          ),
                        )
                      ],
                    )),
                SizedBox(height: 50),

                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text('Student',
                      style: blackTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: semiBold,
                      ))
                ]),
                // !
                SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: firstnameController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          labelStyle: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          hintText: 'e.g., John Doe',
                          label: Row(
                            children: [
                              Text('Name '),
                              Text('*', style: TextStyle(color: Colors.red)),
                            ],
                          )),
                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (String? value) {
                        return (value!.length < 0 || value.contains('@'))
                            ? "Can't be empty"
                            : null;
                      },
                    ),
                    SizedBox(height: 30),

                    // !
                    Row(
                      children: [
                        Text('Gender '),
                        Text('*', style: TextStyle(color: Colors.red)),
                      ],
                    ),

                    DropdownButton(
                      underline: Container(
                          height: 2, color: Color.fromARGB(255, 209, 209, 209)),
                      isExpanded: true,
                      hint: Text('Select your gender'),
                      items: genderList.map((item) {
                        return DropdownMenuItem(
                          value: item.toString(),
                          child: Text(item.toString()),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          genderval = newVal;
                        });
                      },
                      value: genderval,
                    ),

                    // ! radio buttons
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   children: [
                    //     Expanded(
                    //       child: Row(
                    //         children: [
                    //           Radio(
                    //             value: 'b',
                    //             groupValue: _title,
                    //             onChanged: (String? value) {
                    //               setState(() {
                    //                 _title = value!;
                    //               });
                    //             },
                    //           ),
                    //           Expanded(
                    //             child: Text('Laki-laki'),
                    //           )
                    //         ],
                    //       ),
                    //       flex: 1,
                    //     ),
                    //     Expanded(
                    //       child: Row(
                    //         children: [
                    //           Radio(
                    //             value: 'a',
                    //             groupValue: _title,
                    //             onChanged: (String? value) {
                    //               setState(() {
                    //                 _title = value!;
                    //               });
                    //             },
                    //           ),
                    //           Expanded(child: Text('Perempuan'))
                    //         ],
                    //       ),
                    //       flex: 1,
                    //     ),
                    //   ],
                    // ),

                    SizedBox(height: 30),

                    // !
                    TextFormField(
                      controller: placeController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          labelStyle: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          hintText: 'e.g city',
                          label: Row(
                            children: [
                              Text('Place '),
                              Text('*', style: TextStyle(color: Colors.red)),
                            ],
                          )),
                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (String? value) {
                        return (value!.length < 0) ? "Can't be empty" : null;
                      },
                    ),
                    SizedBox(height: 30),

                    // !
                    TextFormField(
                      controller: birthController,
                      decoration: InputDecoration(
                          suffix: IconButton(
                            icon: Icon(
                              Icons.edit_calendar,
                              size: 20,
                            ),
                            onPressed: () {},
                          ),
                          contentPadding: EdgeInsets.all(0),
                          labelStyle: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          hintText: 'e.g city',
                          label: Row(
                            children: [
                              Text('Birth Date '),
                              Text('*', style: TextStyle(color: Colors.red)),
                            ],
                          )),
                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (String? value) {
                        return (value!.length < 0) ? "Can't be empty" : null;
                      },
                    ),
                    SizedBox(height: 30),

                    // !
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          labelStyle: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          hintText: 'e.g city',
                          label: Row(
                            children: [
                              Text('Address '),
                              Text('*', style: TextStyle(color: Colors.red)),
                            ],
                          )),
                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (String? value) {
                        return (value!.length < 0) ? "Can't be empty" : null;
                      },
                    ),
                    SizedBox(height: 30),

                    // !
                    TextFormField(
                      controller: cityController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          labelStyle: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          hintText: 'e.g city',
                          label: Row(
                            children: [
                              Text('City '),
                              Text('*', style: TextStyle(color: Colors.red)),
                            ],
                          )),
                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (String? value) {
                        return (value!.length < 0) ? "Can't be empty" : null;
                      },
                    ),
                    SizedBox(height: 30),

                    // !
                    TextFormField(
                      controller: mobileController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          labelStyle: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          hintText: 'e.g 123xxxxxx',
                          label: Row(
                            children: [
                              Text('Mobile '),
                              Text('*', style: TextStyle(color: Colors.red)),
                            ],
                          )),
                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (String? value) {
                        return (value!.length < 0) ? "Can't be empty" : null;
                      },
                    ),
                    SizedBox(height: 40),

                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Text(
                        'Guardian',
                        style: blackTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: semiBold,
                        ),
                      )
                    ]),

                    SizedBox(height: 30),

                    // !

                    TextFormField(
                      controller: waliController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          labelStyle: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          hintText: 'e.g., John Doe',
                          label: Row(
                            children: [
                              Text('Name '),
                              Text('*', style: TextStyle(color: Colors.red)),
                            ],
                          )),
                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (String? value) {
                        return (value!.length < 0 || value.contains('@'))
                            ? "Can't be empty"
                            : null;
                      },
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: noWaliController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          labelStyle: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          hintText: 'e.g 123xxxxxx',
                          label: Row(
                            children: [
                              Text('Mobile '),
                              Text('*', style: TextStyle(color: Colors.red)),
                            ],
                          )),
                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (String? value) {
                        return (value!.length < 0) ? "Can't be empty" : null;
                      },
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ]),
            ),
          ),
        ));
  }
}
