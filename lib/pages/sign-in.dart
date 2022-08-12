import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imte_mobile/main.dart';
import 'package:imte_mobile/pages/dashboard.dart';
import 'package:imte_mobile/pages/enroll.dart';
import 'package:imte_mobile/pages/profile.dart';
import 'package:imte_mobile/shared/theme.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool isLoading = false;

  encrypting() {
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
  }

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

    if (emailController.text.isEmpty) {
      print('empty');
    } else {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        token = jsonData['token'];
        user = jsonData['user'];

        prefs.setInt('user', user);

        prefs.setString('emails', email);

        print('your token : ' + token);

        print('your emails : ' + email);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardPage(
                      token: token,
                    )),
            (route) => false);
      } else {
        isLoading = false;
        print(response.body);
      }
    }
  }

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
      style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w600),
    );
  }

  Widget email() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
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
                    color: Color(0xff979797), fontWeight: FontWeight.w500),
                hintText: 'Email Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
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
            Text(
              'Password',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Color(0xff535353),
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 5),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintStyle: GoogleFonts.poppins(
                    color: Color(0xff979797), fontWeight: FontWeight.w500),
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
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

  Widget signInButton() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(top: 20),
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 0.065,
        child: TextButton(
          onPressed: () {
            checkingField();
          },
          style: TextButton.styleFrom(
              backgroundColor: Color(0xff1F98A8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: Text(
            'Sign In ',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ));
  }

  Widget loadingButton() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.065,
        child: TextButton(
          onPressed: () {
            checkingField();
          },
          style: TextButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ));
  }

  Widget signUpNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Didn't have any Account yet? ",
            style: GoogleFonts.poppins(fontSize: 12)),
        GestureDetector(
          child: Text('Sign Up',
              style:
                  GoogleFonts.poppins(fontSize: 12, color: Color(0xff1F98A8))),
          onTap: () {
            Navigator.pushNamed(context, '/sign-up');
          },
        )
      ],
    );
  }

  checkingField() {
    if (emailController.text == "" || passwordController.text == "") {
      var snackBar = SnackBar(content: Text("There's still empty"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      isLoading = true;
      Timer(Duration(seconds: 3), () {
        signIn(emailController.text, passwordController.text);
      });
    }
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
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Color.fromARGB(174, 143, 143, 143))),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    child: Column(
                      children: [
                        signInText(),
                        SizedBox(height: 32),
                        Container(
                          child: Column(
                            children: [
                              email(),
                              SizedBox(height: 20),
                              password(),
                              (isLoading == false)
                                  ? signInButton()
                                  : loadingButton(),
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
}
