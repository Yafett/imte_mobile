import 'dart:io';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imte_mobile/pages/profile.dart';
import 'package:imte_mobile/pages/test.dart';
import 'package:imte_mobile/widget/enroll-card.dart';
import 'package:imte_mobile/widget/enroll-news-card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'news.dart';

class EnrollPage extends StatefulWidget {
  // final String email;
  // final String pass;

  // const EnrollPage({Key? key, required this.email, required this.pass})
  //     : super(key: key);

  const EnrollPage({Key? key}) : super(key: key);

  @override
  State<EnrollPage> createState() => _EnrollPageState();
}

// city.devwork@gmail.com

class _EnrollPageState extends State<EnrollPage> {
  final _formKey = GlobalKey<FormState>();
  SingleValueDropDownController _cnt = SingleValueDropDownController();

  Future pickImage() async {
    await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  Widget headerBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 120),
          // height: 40,
          width: MediaQuery.of(context).size.height * 0.46,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1), //color of shadow
                  spreadRadius: 5, //spread radius
                  blurRadius: 10, // blur radius
                  offset: Offset(0, 2),
                ),
              ]),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Activity'),
            Icon(
              Icons.refresh_outlined,
              color: Color.fromARGB(255, 0, 0, 0),
              size: 26,
            ),
          ]),
        ),
      ],
    );
  }

  Widget fluidContainer() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Color(0xff0DB1BF),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          )),
    );
  }

  Widget content(context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                  child: Container(
                    child: Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          image: DecorationImage(
                            image: AssetImage('assets/image/learn.jpg'),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    margin: EdgeInsets.only(left: 15, top: 20),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Yafhet Rama',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '0821317391',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 26, vertical: 8),
                margin: EdgeInsets.only(right: 15),
                width: MediaQuery.of(context).size.height * 0.15,
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color(0xffAE2329),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Enroll',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              onTap: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25.0))),
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Enroll Now',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    Divider(
                                      thickness: 2,
                                      height: 30,
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'Teacher Name',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: DropDownTextField(
                                        singleController: _cnt,
                                        clearOption: true,
                                        enableSearch: false,
                                        validator: (value) {
                                          if (value == null) {
                                            return "Required field";
                                          } else {
                                            return null;
                                          }
                                        },
                                        dropDownItemCount: 6,
                                        dropDownList: const [
                                          DropDownValueModel(
                                              name: 'name1', value: "value1"),
                                          DropDownValueModel(
                                              name: 'name2',
                                              value: "value2",
                                              toolTipMsg:
                                                  "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                                          DropDownValueModel(
                                              name: 'name3', value: "value3"),
                                          DropDownValueModel(
                                              name: 'name4',
                                              value: "value4",
                                              toolTipMsg:
                                                  "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                                          DropDownValueModel(
                                              name: 'name5', value: "value5"),
                                          DropDownValueModel(
                                              name: 'name6', value: "value6"),
                                          DropDownValueModel(
                                              name: 'name7', value: "value7"),
                                          DropDownValueModel(
                                              name: 'name8', value: "value8"),
                                        ],
                                        onChanged: (val) {},
                                      ),
                                    ),
                                    SizedBox(
                                      height: 18,
                                    ),
                                    Text(
                                      'Instrument',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: DropDownTextField(
                                        singleController: _cnt,
                                        clearOption: true,
                                        enableSearch: false,
                                        validator: (value) {
                                          if (value == null) {
                                            return "Required field";
                                          } else {
                                            return null;
                                          }
                                        },
                                        dropDownItemCount: 6,
                                        dropDownList: const [
                                          DropDownValueModel(
                                              name: 'name1', value: "value1"),
                                          DropDownValueModel(
                                              name: 'name2',
                                              value: "value2",
                                              toolTipMsg:
                                                  "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                                          DropDownValueModel(
                                              name: 'name3', value: "value3"),
                                          DropDownValueModel(
                                              name: 'name4',
                                              value: "value4",
                                              toolTipMsg:
                                                  "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                                          DropDownValueModel(
                                              name: 'name5', value: "value5"),
                                          DropDownValueModel(
                                              name: 'name6', value: "value6"),
                                          DropDownValueModel(
                                              name: 'name7', value: "value7"),
                                          DropDownValueModel(
                                              name: 'name8', value: "value8"),
                                        ],
                                        onChanged: (val) {},
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    InkWell(
                                      onTap: () {
                                        pickImage();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 25, 133, 133),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text("Pick Image",
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        pickImage();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Color(0xffAE2329),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text("Enroll Now",
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ));
              },
            ),
          ],
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('tokens', 'jabikfldbahfbdfhkb shjksab');

    setState(() {
      String tokens = prefs.getString('tokens').toString();

      print(tokens);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
        child: Stack(
          children: [
            fluidContainer(),
            content(context),
            headerBar(),

            // listBox(),
            // testBlock(),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 160),
                  height: MediaQuery.of(context).size.height * 0.46,
                  width: MediaQuery.of(context).size.height * 0.46,
                  child: ListView(
                    padding: const EdgeInsets.all(0),
                    children: <Widget>[
                      enrollCard(
                        textPeriod: 'P2 | 2022',
                        textGrade: 'Piano - JC - Classical',
                        textCourse: 'Prsnt',
                        color: Colors.red,
                      ),
                      enrollCard(
                        textPeriod: 'P1 | 2021',
                        textGrade: 'Drum - CFK',
                        textCourse: 'Leve',
                        color: Colors.grey,
                      ),
                      enrollCard(
                        textPeriod: 'P1 | 2021',
                        textGrade: 'Bass - CFK',
                        textCourse: 'Prsnt',
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, top: 30, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Recent News',
                        style: GoogleFonts.poppins(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          launch(
                              'https://www.instagram.com/p/CYbKBpjrpul/?utm_medium=copy_link');
                        },
                        child: Container(
                          margin: EdgeInsets.only(),
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/image/ban2.png'),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          launch(
                              'https://www.instagram.com/p/CYbKBpjrpul/?utm_medium=copy_link');
                        },
                        child: Container(
                          margin: EdgeInsets.only(),
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/image/ban1.png'),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          launch(
                              'https://www.instagram.com/p/CYbKBpjrpul/?utm_medium=copy_link');
                        },
                        child: Container(
                          margin: EdgeInsets.only(),
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/image/ban3.jpg'),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Column(children: [
                    enrollNewsCard(
                      title:
                          'Why NFT Creators Are Picking Arweave Over IPFS (What Solana And Metaplex Have Known For Some Time Now)',
                      user: 'Mr. Yafet',
                      date: '15 - 07 - 2022',
                      image: Image.network(
                        'https://uploads-ssl.webflow.com/61c8ba3864049fa06a524bbd/61e2a0ac1ee9e1696610c78d_3.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    enrollNewsCard(
                      title: 'Metaplex Protocol: Fueling Solana (NFT) Summer',
                      user: 'Mrs. Lidya',
                      date: '12 - 07 - 2022',
                      image: Image.network(
                          fit: BoxFit.cover,
                          'https://cdn.sanity.io/images/2bt0j8lu/production/1e83eae3c3b81ae83ff33fb0f0e1218538bd9221-1280x720.png?w=714&fit=max&auto=format&dpr=3'),
                    ),
                  ]),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
