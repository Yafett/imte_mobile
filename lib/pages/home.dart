import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imte_mobile/models/Gallery.dart';
import 'package:imte_mobile/shared/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

import 'dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var listGallery = [];
  var videoSrc = '';
  var emailUp = '';
  var passUp = '';

  bool _obscureText = true;

  // !Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool _isLoading = false;

  // VideoPlayerController _controller = VideoPlayerController.network('');
  VideoPlayerController _controller =
      VideoPlayerController.asset('assets/video/opening.mp4');

  @override
  void initState() {
    super.initState();
    dataVideo();
    afterSignUp();
  }

  Widget loginButton() {
    return InkWell(
      child: Container(
          // margin: EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.070,
          child: TextButton(
            onPressed: _isLoading ? null : _startLoading,
            style: TextButton.styleFrom(
                backgroundColor: Color(0xffAE2329),
                shape: RoundedRectangleBorder(borderRadius: radiusNormal)),
            child: Text(_isLoading ? 'Loading...' : 'Sign In',
                style: whiteTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: semiBold,
                )),
          )),
    );
  }

  Widget smallText() {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              launch('https://imte.education/terms');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Terms and Conditions",
                  style: whiteTextStyle.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              launch('https://imte.education/privacy');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Privacy Policy",
                  style: whiteTextStyle.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget imteLogo() {
    return GestureDetector(
      onTap: () {
        launch('https://imte.education/');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            height: 120,
            width: 203,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/logo-white.png'),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(20)),
          )
        ],
      ),
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
              // controller: emailController,
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
              // controller: passwordController,
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

  // ! video background
  Widget videoBackground() {
    return SizedBox.expand(
      child: FittedBox(
        // If your background video doesn't look right, try changing the BoxFit property.
        // BoxFit.fill created the look I was going for.
        fit: BoxFit.fill,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }

  // ! darken video background
  Widget darkenEffect() {
    return Opacity(
      opacity: 0.8,
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.fill,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: const DecoratedBox(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 22, 20, 20)),
            ),
          ),
        ),
      ),
    );
  }

  // ! get data Video
  dataVideo() async {
    String API_URL = 'https://adm.imte.education/api/setup';

    final response = await http.get(Uri.parse(API_URL));

    final data = await json.decode(response.body);

    for (var i = 0; i < data.length; i++) {
      if (data[i]['name'] == 'hero_image') {
        listGallery.add(Gallery.fromJson(data[i]));
        var itemGallery = listGallery[i];

        setState(() {
          videoSrc = itemGallery.src;
        });
      }
    }

    // ! mengubah . menjadi ''
    var vii = videoSrc.replaceAll('./', '');
    print(vii);

    // _controller = VideoPlayerController.network('https://imte.education/' + vii)
    _controller = VideoPlayerController.asset('assets/video/op.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    _controller.play();
    _controller.setLooping(true);
    _controller.setVolume(0);
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

  // ! get after data
  afterSignUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // emailUp = prefs.getString('emailSignUp')!;
    // passUp = prefs.getString('passwordSignUp')!;

    // print('your email after : ' + emailUp.toString());
    // print('your password after : ' + passUp.toString());
  }

  signIn(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map data = {
      'email': email,
      'password': password,
    };

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

      print('your token : ' + token);

      print('your email : ' + email);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => DashboardPage(
                    token: token,
                  )),
          (route) => false);

      prefs.remove('emailSignUp');
      prefs.remove('passwordSignUp');
    } else {
      var snackBar = SnackBar(content: Text('Wrong Data Input'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: <Widget>[
                    videoBackground(),
                    darkenEffect(),
                    imteLogo(),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 150),
                            decoration: BoxDecoration(
                              borderRadius: radiusNormal,
                              color: Color.fromARGB(143, 255, 255, 255),
                            ),
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                SizedBox(height: 10),

                                // ! email
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                  style: blackTextStyle,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: kBlackColor,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      //  when the TextFormField in unfocused
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      //  when the TextFormField in focused
                                    ),
                                    border: UnderlineInputBorder(),
                                    focusColor: Colors.black,
                                    hintText: 'Email',
                                    hintStyle:
                                        blackTextStyle.copyWith(fontSize: 16),
                                  ),
                                  onSaved: (String? value) {
                                    // This optional block of code can be used to run
                                    // code when the user saves the form.
                                  },
                                  validator: (String? value) {
                                    return (value!.length < 0)
                                        ? "Can't be empty"
                                        : null;
                                  },
                                ),
                                SizedBox(height: 20),

                                // ! password
                                TextFormField(
                                  obscureText: _obscureText,
                                  controller: passwordController,
                                  style: blackTextStyle,
                                  decoration: InputDecoration(
                                    suffix: GestureDetector(
                                      onTap: () {
                                        _toggle();
                                      },
                                      child: Icon((_obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off)),
                                    ),
                                    prefixIcon: Icon(Icons.lock_outline,
                                        color: kBlackColor),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      //  when the TextFormField in unfocused
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      //  when the TextFormField in focused
                                    ),
                                    border: UnderlineInputBorder(),
                                    focusColor: Colors.black,
                                    hintText: 'Password',
                                    hintStyle:
                                        blackTextStyle.copyWith(fontSize: 16),
                                  ),
                                  onSaved: (String? value) {
                                    // This optional block of code can be used to run
                                    // code when the user saves the form.
                                  },
                                  validator: (String? value) {
                                    return (value!.length < 0)
                                        ? "Can't be empty"
                                        : null;
                                  },
                                ),
                                SizedBox(height: 30),

                                loginButton(),
                                signUpNavigation(),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    smallText()
                  ],
                ))));
  }
}
