import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:imte_mobile/main.dart';
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

    var jsonData = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response = await http.post(
        Uri.parse('https://adm.imte.education/api/user/login'),
        body: data);

    if (response.statusCode == 200) {
      // Navigator.pushNamed(context, '/sign-up');

      // jsonData = json.decode(response.body);

      setState(() {
        Navigator.pushNamed(context, '/sign-up');

        print(response.body);
      });
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
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
                  icon: Icon(Icons.arrow_back,
                      color: Color.fromARGB(255, 147, 163, 173)),
                ),
              ],
            ),
            Column(
              children: [
                // SizedBox(
                //   height: 130,
                // ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 150,
                  width: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/image/logo.png'),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                ),
                SizedBox(height: 70),
                Text(
                  'Sign In',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 32),

                // ! email
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 6),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        )
                      ]),
                ),
                SizedBox(
                  height: 20,
                ),

                // ! password
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Password',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 6),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        )
                      ]),
                ),

                // ! button
                Container(
                    margin: EdgeInsets.only(top: 30),
                    width: 310,
                    height: 55,
                    child: TextButton(
                      onPressed: () {
                        signIn(emailController.text, passwordController.text);
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: kBlueColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17))),
                      child: Text(
                        'Sign In ',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(249, 255, 255, 255)),
                      ),
                    )),
                SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Tidak punya akun? '),
                    GestureDetector(
                      child: Text(
                        'Sign Up',
                        style:
                            TextStyle(color: Color.fromARGB(248, 63, 172, 223)),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/sign-up');
                      },
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
