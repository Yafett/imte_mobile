import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imte_mobile/main.dart';
import 'package:imte_mobile/pages/dashboard.dart';
import 'package:imte_mobile/pages/sign-in.dart';
import 'package:imte_mobile/shared/theme.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  TextEditingController firstnameController = new TextEditingController();
  TextEditingController lastnameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordConfirmationController =
      new TextEditingController();
  TextEditingController mobileController = new TextEditingController();

  bool isLoading = false;

  // ! fungsi register 
  signUp(String unit, String firstName, String lastName, String email,
      String password, String passwordConfirmation, String mobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map data = {
      'unit': unitval,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'confirm': passwordConfirmation,
      'mobile': mobile,
    };

    var response = await http.post(
        Uri.parse('https://adm.imte.education/api/user/registerv2'),
        headers: {'Accept': 'application/json'},
        body: data);

    var result = response.body;
    var jsonData = jsonDecode(response.body);

    print(jsonData);

    if (response.statusCode == 200) {
      Navigator.pushNamedAndRemoveUntil(context, '/sign-in', (route) => false);
    } else {
      var snackBar = SnackBar(content: Text(jsonData['errors'].toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    print(data);
  }

  // ! textField validator
  checkingField() {
    if (firstnameController.text == "" ||
        passwordController.text == "" ||
        mobileController.text == "" ||
        emailController.text == "" ||
        lastnameController.text == "" ||
        passwordConfirmationController.text == "") {
      var snackBar = SnackBar(content: Text("There's still empty"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      isLoading = true;
      Timer(Duration(seconds: 3), () {
        signUp(
          _valFriends.toString(),
          firstnameController.text,
          lastnameController.text,
          emailController.text,
          passwordController.text,
          passwordConfirmationController.text,
          mobileController.text,
        );
      });
    }
  }

  // ! mendapatkan data unit
  var unitval;
  List unitList = [];
  dataUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    http.Response response =
        await http.get(Uri.parse('https://adm.imte.education/api/unit'));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        unitList = jsonData;
      });
      print(jsonData);
    }
  }

  List _unit = [
    "Alam Sutra",
    "Gang Pinggir",
    "Madiun",
    "Puri Anjasmoro",
    "Solo",
    "Jogjakarta",
    "Kutoarjo",
    "Kudus",
    "Purwodadi",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataUnit();
  }

  String? _valFriends;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          width: double.infinity,
          color: Color(0xffFFFFFF),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  Text(
                    'Sign Up',
                    style: GoogleFonts.poppins(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(height: 30),

                  // ! unit textField
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unit',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Color(0xff535353),
                            fontWeight: FontWeight.w500),
                      ),
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
                          hint: Text('Select Your Unit'),
                          items: unitList.map((item) {
                            return DropdownMenuItem(
                              value: item['id'].toString(),
                              child: Text(item['unit_name'].toString()),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              unitval = newVal;
                            });
                          },
                          value: unitval,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // ! first name textField
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'First Name',
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Color(0xff535353),
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Color(0xff979797),
                                    fontWeight: FontWeight.w500),
                                controller: firstnameController,
                                decoration: InputDecoration(
                                  hintText: 'First Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              )
                            ]),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Last Name',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Color(0xff535353),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Color(0xff979797),
                                    fontWeight: FontWeight.w500),
                                controller: lastnameController,
                                decoration: InputDecoration(
                                  hintText: 'Last Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              )
                            ]),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // ! email textField
                  Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Color(0xff535353),
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.poppins(
                                  color: Color(0xff979797),
                                  fontWeight: FontWeight.w500),
                              hintText: 'Email Address',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          )
                        ]),
                  ),
                  SizedBox(height: 10),

                  // ! Mobile textField
                  Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mobile',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Color(0xff535353),
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            controller: mobileController,
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.poppins(
                                  color: Color(0xff979797),
                                  fontWeight: FontWeight.w500),
                              hintText: 'Mobile',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          )
                        ]),
                  ),
                  SizedBox(height: 10),

                  // ! Password textField
                  Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Password',
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Color(0xff535353),
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                ' | must contain 8 characters',
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 157, 20, 20),
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.poppins(
                                  color: Color(0xff979797),
                                  fontWeight: FontWeight.w500),
                              hintText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          )
                        ]),
                  ),
                  SizedBox(height: 10),

                  // ! Confirm Password textField
                  Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Confirm Password',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Color(0xff535353),
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 6),
                          TextFormField(
                            controller: passwordConfirmationController,
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.poppins(
                                  color: Color(0xff979797),
                                  fontWeight: FontWeight.w500),
                              hintText: 'Confirm Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          )
                        ]),
                  ),
                  SizedBox(height: 30),

                  // ! button 
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: TextButton(
                        onPressed: () {
                          checkingField();
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xff1F98A8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: Text(
                          'Sign Up ',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
