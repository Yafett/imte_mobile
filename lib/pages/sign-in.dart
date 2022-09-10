import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:imte_mobile/pages/dashboard-page.dart';
import 'package:imte_mobile/shared/theme.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  // ! sign in func
  signIn(String email, String password) async {
    Map data = {
      'email': email,
      'password': password,
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = '';
    int user = 0;

    var response = await http.post(
        Uri.parse('https://adm.imte.education/api/user/loginv2'),
        headers: {
          "Accept": "application/json",
        },
        body: data);
    var result = response.body;

    print(result.toString());

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      token = jsonData['token'];
      user = jsonData['user'];

      prefs.setInt('user', user);

      prefs.setString('emails', email);

      print('your token : ${token}, your email : ${email}');

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
          (route) => false);
    } else {
      var snackBar = SnackBar(content: Text('Wrong Data Input'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // ! loading indicator
  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));
    checkingField();

    setState(() {
      _isLoading = false;
    });
  }

  // ! form part
  Widget imteLogo() {
    return Container(
      margin: EdgeInsets.only(top: 0),
      height: 200,
      width: 200,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/logo.png'),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget signInText() {
    return Text(
      'Sign In',
      style: blackTextStyle.copyWith(fontSize: 26, fontWeight: semiBold),
    );
  }

  Widget email() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email', style: blackTextStyle.copyWith(fontSize: 16)),
            SizedBox(height: 5),
            TextFormField(
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
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Can\'t be empty';
                }
                if (text.length < 4) {
                  return 'Too short';
                }
                return null;
              },
            )
          ]),
    );
  }

  Widget password() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Password', style: blackTextStyle.copyWith(fontSize: 16)),
            SizedBox(height: 5),
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
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Can\'t be empty';
                }
                if (text.length < 4) {
                  return 'Too short';
                }
                return null;
              },
            )
          ]),
    );
  }
  // ! end form part

  // ! signIn Button
  Widget signInButton() {
    return InkWell(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 0.070,
          child: TextButton(
            onPressed: _isLoading ? null : _startLoading,
            style: TextButton.styleFrom(
                backgroundColor: Color(0xff1F98A8),
                shape: RoundedRectangleBorder(borderRadius: radiusNormal)),
            child: Text(_isLoading ? 'Loading...' : 'Sign In',
                style: whiteTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: semiBold,
                )),
          )),
    );
  }

  // ! button signup
  Widget signUpNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Didn't have any Account yet? ",
            style: blackTextStyle.copyWith(fontSize: 14)),
        GestureDetector(
          child: Text('Sign Up', style: blueTextStyle.copyWith(fontSize: 14)),
          onTap: () {
            Navigator.pushNamed(context, '/sign-up');
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          color: Color(0xffFFFFFF),
          child: Column(
            children: [
              Column(
                children: [
                  imteLogo(),
                  SizedBox(height: 2),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: radiusNormal,
                        border: Border.all(
                            color: Color.fromARGB(174, 143, 143, 143))),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    child: Column(
                      children: [
                        signInText(),
                        SizedBox(height: 30),
                        Container(
                          child: Column(
                            children: [
                              email(),
                              SizedBox(height: 10),
                              password(),
                              signInButton(),
                              SizedBox(height: 10),
                              signUpNavigation(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // ! empty field validator
  checkingField() {
    if (emailController.text == "" || passwordController.text == "") {
      var snackBar = SnackBar(content: Text("There's still empty"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      signIn(emailController.text, passwordController.text);
    }
  }
}
