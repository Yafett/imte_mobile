// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imte_mobile/bloc/register-bloc/register_bloc.dart';
import 'package:imte_mobile/pages/history-page.dart';

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

  RegisterBloc _registerBloc = new RegisterBloc();

  var unitval;
  List unitList = [];
  bool isLoading = false;
  String? _valFriends;
  bool _isLoading = false;

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
      prefs.setString('emailSignUp', email);
      prefs.setString('passwordSignUp', password);

      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else {
      var snackBar = SnackBar(content: Text(jsonData['errors'].toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

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

  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });

    checkingField();
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  // ! get data Unit
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

  @override
  void initState() {
    super.initState();
    dataUnit();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSignUpPage(context);
  }

  Scaffold _buildSignUpPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kWhiteColor,
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
          BlocConsumer<RegisterBloc, RegisterState>(
            bloc: _registerBloc,
            listener: (context, state) {
              if (state is RegisterSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              } else if (state is RegisterError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message!)));
              }
            },
            builder: (context, state) {
              if (state is RegisterInitial) {
                print(state);

                return InkWell(
                  onTap: () {
                    _registerBloc.add(Register(
                      lastnameController.text,
                      unitval,
                      firstnameController.text,
                      emailController.text,
                      mobileController.text,
                      passwordController.text,
                      passwordConfirmationController.text,
                    ));
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 15),
                    child: Chip(
                      backgroundColor: Color(0xff1F98A8),
                      label: Text('Sign Up',
                          style: whiteTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: semiBold,
                          )),
                    ),
                  ),
                );
              } else if (state is RegisterLoading) {
                print(state);

                return InkWell(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(right: 15),
                    child: Chip(
                      backgroundColor: Color(0xff1F98A8),
                      label: Text('Loading...',
                          style: whiteTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: semiBold,
                          )),
                    ),
                  ),
                );
              } else if (state is RegisterError) {
                print(state);

                return InkWell(
                  onTap: () {
                    _registerBloc.add(Register(
                      lastnameController.text,
                      unitval,
                      firstnameController.text,
                      emailController.text,
                      mobileController.text,
                      passwordController.text,
                      passwordConfirmationController.text,
                    ));
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 15),
                    child: Chip(
                      backgroundColor: Color(0xff1F98A8),
                      label: Text('Sign Up',
                          style: whiteTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: semiBold,
                          )),
                    ),
                  ),
                );
              } else {
                return InkWell(
                  onTap: () {
                    _registerBloc.add(Register(
                      lastnameController.text,
                      unitval,
                      firstnameController.text,
                      emailController.text,
                      mobileController.text,
                      passwordController.text,
                      passwordConfirmationController.text,
                    ));
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 15),
                    child: Chip(
                      backgroundColor: Color(0xff1F98A8),
                      label: Text('Sign Up',
                          style: whiteTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: semiBold,
                          )),
                    ),
                  ),
                );
              }
            },
          ),
        ],
        title: Text('Sign Up',
            style: blackTextStyle.copyWith(
              fontSize: 20,
              fontWeight: semiBold,
            )),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: _buildSignUpForm(context),
        ),
      ),
    );
  }

  Widget _buildSignUpForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: kWhiteColor,
      child: Column(
        // ! header
        children: [
          Column(
            children: [
              // ! unit textField
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unit',
                    style: blackTextStyle.copyWith(fontSize: 16),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: radiusNormal,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButton(
                      underline: SizedBox(),
                      isExpanded: true,
                      hint: Text('Select Your Unit',
                          style: greyTextStyle.copyWith(fontSize: 16)),
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
              SizedBox(height: 20),

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
                          Text('First Name',
                              style: blackTextStyle.copyWith(fontSize: 16)),
                          SizedBox(height: 5),
                          TextFormField(
                            style: greyTextStyle.copyWith(fontSize: 16),
                            controller: firstnameController,
                            decoration: InputDecoration(
                              hintText: 'First Name',
                              border: OutlineInputBorder(
                                borderRadius: radiusNormal,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: radiusNormal,
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
                            style: blackTextStyle.copyWith(fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            style: greyTextStyle.copyWith(fontSize: 16),
                            controller: lastnameController,
                            decoration: InputDecoration(
                              hintText: 'Last Name',
                              border: OutlineInputBorder(
                                borderRadius: radiusNormal,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: radiusNormal,
                              ),
                            ),
                          )
                        ]),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // ! email textField
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: blackTextStyle.copyWith(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          hintStyle: greyTextStyle.copyWith(fontSize: 16),
                          hintText: 'Email Address',
                          border: OutlineInputBorder(
                            borderRadius: radiusNormal,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: radiusNormal,
                          ),
                        ),
                      )
                    ]),
              ),
              SizedBox(height: 20),

              // ! Mobile textField
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mobile',
                        style: blackTextStyle.copyWith(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: mobileController,
                        decoration: InputDecoration(
                          hintStyle: greyTextStyle.copyWith(fontSize: 16),
                          hintText: 'Mobile',
                          border: OutlineInputBorder(
                            borderRadius: radiusNormal,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: radiusNormal,
                          ),
                        ),
                      )
                    ]),
              ),
              SizedBox(height: 20),

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
                            style: blackTextStyle.copyWith(fontSize: 16),
                          ),
                          Text(
                            ' | must contain 8 characters',
                            style: redTextStyle.copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintStyle: greyTextStyle.copyWith(fontSize: 16),
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: radiusNormal,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: radiusNormal,
                          ),
                        ),
                      )
                    ]),
              ),
              SizedBox(height: 20),

              // ! Confirm Password textField
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm Password',
                        style: blackTextStyle.copyWith(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: passwordConfirmationController,
                        decoration: InputDecoration(
                          hintStyle: greyTextStyle.copyWith(fontSize: 16),
                          hintText: 'Confirm Password',
                          border: OutlineInputBorder(
                            borderRadius: radiusNormal,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: radiusNormal,
                          ),
                        ),
                      )
                    ]),
              ),
            ],
          )
        ],
      ),
    );
  }
}
