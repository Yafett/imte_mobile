// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imte_mobile/models/gallery-model.dart';
import 'package:imte_mobile/pages/dashboard-page.dart';
import 'package:imte_mobile/shared/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  var isLoading = false;

  var forgetPass = false;
  var emailSend = false;
  var canReset = false;
  var isOtp = true;
  var otpCode;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  TextEditingController forgetEmailController = new TextEditingController();
  TextEditingController otpController = new TextEditingController();
  TextEditingController forgetPasswordController = new TextEditingController();

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
            child: (forgetPass != true)
                ? Column(
                    children: [
                      _emailField(),
                      _passwordField(),
                      _forgotPassword(),
                      _loginButton(),
                      SizedBox(height: 5),
                      _signUpNavigation(),
                      SizedBox(height: 10),
                    ],
                  )
                : Column(
                    children: [
                      _passEmailField(),
                      (emailSend == true)
                          ? Column(
                              children: [
                                _otpField(),
                                _passNewField(),
                              ],
                            )
                          : Container(),
                      _wantLogin(),
                      (isOtp == true)
                          ? _sendOtpButton()
                          : _resetPasswordButton(),
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
                _logged();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage()),
                    (route) => false);
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
      ],
    );
  }

  Widget _loadingButton() {
    return TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 50, 50, 50),
            shape: RoundedRectangleBorder(borderRadius: radiusNormal)),
        child: CircularProgressIndicator(
          color: Colors.white,
        ));
  }

// ! forget password

  Widget _passEmailField() {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: forgetEmailController,
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
      ],
    );
  }

  Widget _otpField() {
    return Column(
      children: [
        SizedBox(height: 20),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: otpController,
          style: blackTextStyle,
          decoration: InputDecoration(
            prefixIcon:
                Icon(Icons.chat_bubble_outline_outlined, color: kBlackColor),
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
            hintText: 'OTP',
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
      ],
    );
  }

  Widget _passNewField() {
    return Column(
      children: [
        SizedBox(height: 20),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: forgetPasswordController,
          style: blackTextStyle,
          decoration: InputDecoration(
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
            hintText: 'New Password',
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
      ],
    );
  }

  Widget _wantLogin() {
    return Column(
      children: [
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            if (mounted) {
              setState(() {
                forgetPass = false;
                emailSend = false;
                isOtp = true;
              });
            }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Back to Login', style: blackTextStyle),
            ],
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _sendOtpButton() {
    return InkWell(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.070,
            child: (isLoading != true)
                ? BlocConsumer<LoginBloc, LoginState>(
                    bloc: _loginBloc,
                    listener: (context, state) {
                      if (state is LoginError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message!)));
                      } else if (state is LoginSuccess) {
                        _logged();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashboardPage()),
                            (route) => false);
                      }
                    },
                    builder: (context, state) {
                      if (state is LoginInitial || state is LoginError) {
                        return TextButton(
                          onPressed: () {
                            if (forgetEmailController.text.length != 0) {
                              _sendOtp();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Can't be empty")));
                            }
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: Color(0xffAE2329),
                              shape: RoundedRectangleBorder(
                                  borderRadius: radiusNormal)),
                          child: Text("Send OTP",
                              style: whiteTextStyle.copyWith(
                                fontSize: 20,
                                fontWeight: semiBold,
                              )),
                        );
                      } else if (state is LoginLoading) {
                        return _loadingButton();
                      } else {
                        return Container();
                      }
                    },
                  )
                : TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 50, 50, 50),
                        shape:
                            RoundedRectangleBorder(borderRadius: radiusNormal)),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ))));
  }

  Widget _resetPasswordButton() {
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
                _logged();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage()),
                    (route) => false);
              }
            },
            builder: (context, state) {
              if (state is LoginInitial || state is LoginError) {
                return TextButton(
                  onPressed: () {
                    if (canReset == true) {
                      if (forgetEmailController.text.length != 0 &&
                          forgetPasswordController.text.length != 0 &&
                          otpController.text.toString() == otpCode.toString()) {
                        resetPassword();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Your OTP was Wrong")));
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Color(0xffAE2329),
                      shape:
                          RoundedRectangleBorder(borderRadius: radiusNormal)),
                  child: Text("Reset Password",
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

  Widget _forgotPassword() {
    return Column(
      children: [
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            if (mounted) {
              setState(() {
                forgetPass = true;
              });
            }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('forget password', style: blackTextStyle),
            ],
          ),
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

  showAlertDialog() {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Send Link"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // title: Text("My title"),
      contentPadding: EdgeInsets.all(15),
      content: TextFormField(
        obscureText: _obscureText,
        controller: passwordController,
        style: blackTextStyle,
        decoration: InputDecoration(
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
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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

  _logged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", true);

    var status = prefs.getBool('isLoggedIn');

    print('status : ' + status.toString());
  }

  _sendOtp() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    final response = await http.post(
        Uri.parse('https://adm.imte.education/api/user/sendPassResetOtp'),
        headers: {
          "Accept": "application/json"
        },
        body: {
          "email": forgetEmailController.text,
        });
    final data = await json.decode(response.body);

    if (data['message'] == 'Email is sent.') {
      if (mounted) {
        setState(() {
          canReset = true;
          emailSend = true;
          isOtp = false;
          otpCode = data['otp'];
        });
      }

      print(otpCode.toString());

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Link Sent, Check ur Email")));
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("User not Found!")));
    }
  }

  resetPassword() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    final response = await http.post(
        Uri.parse('https://adm.imte.education/api/user/resetPass'),
        headers: {
          "Accept": "application/json"
        },
        body: {
          "email": forgetEmailController.text,
          'password': forgetPasswordController.text,
        });

    if (mounted) {
      setState(() {
        forgetPass = false;
        isLoading = false;
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Your Password was Successfully changed")));
  }
}
