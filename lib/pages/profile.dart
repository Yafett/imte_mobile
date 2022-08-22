import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:imte_mobile/pages/profile-edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String enableBack;

  const ProfilePage({Key? key, required this.enableBack}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

  String _title = 'Radio Button Example';

  var genderList = ['Laki-laki', 'Perempuan'];
  var genderval;

  @override
  void initState() {
    super.initState();
    // dataProfile();
    checkBack();
    print(checkBack());
  }

  // ! enableBack !isExist
  checkBack() {
    return (widget.enableBack == 'true') ? 'true' : 'false';
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
    });

    print(data);

    loading = false;
  }

  // ! back Button
  Widget backButton() {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  // ! form Part
  Widget photoProfile() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
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
    );
  }

  Widget nameTag() {
    return Column(
      children: [
        Text(dfirst.toUpperCase() + ' ' + dlast.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }

  Widget buttonEdit() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileEditPage(enableBack: 'true')));
      },
      child: new Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        width: 150.0,
        height: 40.0,
        decoration: new BoxDecoration(
          color: Color(0xff2398D4),
          borderRadius: new BorderRadius.circular(12),
        ),
        child: new Center(
          child: new Text(
            'EDIT PROFILE',
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

  Widget gender() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Gender',
          style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xff505050)),
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
              child: Text(
                (dgender == 'L') ? "Laki-laki" : "Perempuan",
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(
                    0xff979797,
                  ),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  Widget places() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Place',
          style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xff505050)),
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
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Text(
            dplace == null ? 'no data' : dplace,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(
                0xff979797,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget birth() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Birth',
          style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xff505050)),
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
              child: Text(
                dbirth == null ? 'no data' : dbirth,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(
                    0xff979797,
                  ),
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
        Row(
          children: [
            Text(
              'Mobile ',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff505050)),
            ),
            Icon(
              Icons.verified,
              color: Colors.grey[600],
              size: 14,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
          ],
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
              child: Text(
                dmobile == null ? 'no data' : dmobile,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(
                    0xff979797,
                  ),
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
          'Nama Wali',
          style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xff505050)),
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
              child: Text(
                dwali == null ? 'no data' : dwali,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(
                    0xff979797,
                  ),
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
          'Nomor Wali',
          style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xff505050)),
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
              child: Text(
                dnowali == null ? 'no data' : dnowali,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(
                    0xff979797,
                  ),
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
          'Alamat',
          style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xff505050)),
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
              child: Text(
                daddress == null ? 'no data' : daddress,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(
                    0xff979797,
                  ),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
  // ! end Form Part

  // ! loading bar
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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFFF0F0F0),
          leading: Icon(
            Icons.arrow_back_ios,
            color: Color.fromARGB(255, 37, 37, 37),
            size: 25,
          ),
          actions: [
            InkWell(
              onTap: () {
                print('asd');
              },
              child: Container(
                margin: EdgeInsets.only(right: 15),
                child: Chip(
                  backgroundColor: Color.fromARGB(255, 79, 143, 81),
                  label: Text(
                    'save',
                    style: GoogleFonts.gothicA1(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
          title: Text('My Profile',
              style: GoogleFonts.gothicA1(
                  color: Color.fromARGB(255, 41, 41, 41),
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
        // backgroundColor: Color.fromARGB(255, 207, 32, 32),
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
                                style: GoogleFonts.openSans(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            Container(
                              // margin: EdgeInsets.symmetric(vertical: 5),
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  image: DecorationImage(
                                    image: AssetImage('assets/image/smile.jpg'),
                                    fit: BoxFit.fill,
                                  ),
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(120)),
                            ),
                            Text('Change',
                                style: GoogleFonts.openSans(fontSize: 14)),
                          ],
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            "Put your best profile picture!.",
                            style: GoogleFonts.openSans(fontSize: 14),
                          ),
                        )
                      ],
                    )),
                SizedBox(height: 50),

                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(
                    'Student',
                    style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                ]),
                // !
                SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      initialValue: 'Arthur',
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
                    TextFormField(
                      initialValue: 'Arthur@gmail.com',
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          labelStyle: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          hintText: 'e.g. name@gmail.com',
                          label: Row(
                            children: [
                              Text('Email '),
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
                      hint: Text('Select Your Grade'),
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
                      value: 'Laki-laki',
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
                      initialValue: 'Semarang',
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
                      initialValue: '20 Jun 2022',
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
                      initialValue: '0192831031',
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
                        style: GoogleFonts.openSans(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )
                    ]),

                    SizedBox(height: 30),

                    // !

                    TextFormField(
                      initialValue: 'Arthur',
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
                      initialValue: '8213773289123',
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
