// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imte_mobile/models/gallery-model.dart';
import 'package:imte_mobile/shared/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

import '../bloc/login-bloc/login_bloc.dart';

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

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool _obscureText = true;

  final _loginBloc = LoginBloc();

  VideoPlayerController _controller =
      VideoPlayerController.asset('assets/video/opening.mp4');

  @override
  void initState() {
    super.initState();
    _dataVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildHomePage(),
    );
  }

  _buildHomePage() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            _videoBackground(),
            _darkenVideoEffect(),
            _imteLogo(),
            _buildLoginForm(),
            _smallText()
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
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
                _emailField(),
                _passwordField(),
                _loginButton(),
                _signUpNavigation(),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return InkWell(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.070,
          child: BlocConsumer<LoginBloc, LoginState>(
            bloc: _loginBloc,
            listener: (context, state) {
              if (state is LoginError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message!)));
              } else if (state is LoginSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/dashboard', (route) => false);
              }
            },
            builder: (context, state) {
              if (state is LoginInitial || state is LoginError) {
                return TextButton(
                  onPressed: () {
                    _loginBloc.add(
                        Login(emailController.text, passwordController.text));
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Color(0xffAE2329),
                      shape:
                          RoundedRectangleBorder(borderRadius: radiusNormal)),
                  child: Text("Login",
                      style: whiteTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: semiBold,
                      )),
                );
              } else if (state is LoginLoading) {
                return TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 50, 50, 50),
                        shape:
                            RoundedRectangleBorder(borderRadius: radiusNormal)),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
              } else {
                return Container();
              }
            },
          )),
    );
  }

  Widget _smallText() {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              // ignore: deprecated_member_use
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
              // ignore: deprecated_member_use
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

  Widget _imteLogo() {
    return GestureDetector(
      onTap: () {
        // ignore: deprecated_member_use
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

  Widget _emailField() {
    return Column(
      children: [
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
              borderSide: BorderSide(color: Colors.black),
              //  when the TextFormField in unfocused
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              //  when the TextFormField in focused
            ),
            border: UnderlineInputBorder(),
            focusColor: Colors.black,
            hintText: 'Email',
            hintStyle: blackTextStyle.copyWith(fontSize: 16),
          ),
          onSaved: (String? value) {
            // This optional block of code can be used to run
            // code when the user saves the form.
          },
          validator: (String? value) {
            return (value!.length < 0) ? "Can't be empty" : null;
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _passwordField() {
    return Column(
      children: [
        TextFormField(
          obscureText: _obscureText,
          controller: passwordController,
          style: blackTextStyle,
          decoration: InputDecoration(
            suffix: GestureDetector(
              onTap: () {
                _toggle();
              },
              child: Icon(
                  (_obscureText ? Icons.visibility : Icons.visibility_off)),
            ),
            prefixIcon: Icon(Icons.lock_outline, color: kBlackColor),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              //  when the TextFormField in unfocused
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              //  when the TextFormField in focused
            ),
            border: UnderlineInputBorder(),
            focusColor: Colors.black,
            hintText: 'Password',
            hintStyle: blackTextStyle.copyWith(fontSize: 16),
          ),
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
    );
  }

  Widget _signUpNavigation() {
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

  Widget _videoBackground() {
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

  Widget _darkenVideoEffect() {
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

  _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _dataVideo() async {
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

    var vii = videoSrc.replaceAll('./', '');
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
}
