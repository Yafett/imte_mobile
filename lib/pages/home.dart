import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imte_mobile/models/Gallery.dart';
import 'package:imte_mobile/shared/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var listGallery = [];
  var videoSrc = '';
  VideoPlayerController _controller = VideoPlayerController.network('');

  @override
  void initState() {
    super.initState();
    dataVideo();
  }

  Widget loginButton() {
    return InkWell(
        onTap: () {
          _controller.pause();

          Navigator.pushNamedAndRemoveUntil(
              context, '/sign-in', (route) => false);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 115),
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            borderRadius: radiusNormal,
            color: Color(0xffAE2329),
          ),
          child: Text(
            'Login',
            style: whiteTextStyle.copyWith(fontSize: 20, fontWeight: semiBold),
          ),
        ));
  }

  Widget smallText() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            launch('https://sister.sekolahmusik.co.id/terms');
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
            launch('https://sister.sekolahmusik.co.id/privacy');
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

    _controller = VideoPlayerController.network('https://imte.education/' + vii)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    _controller.play();
    _controller.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            videoBackground(),
            darkenEffect(),
            Container(
              margin: EdgeInsets.only(bottom: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  loginButton(),
                  smallText(),
                ],
              ),
            ),
            imteLogo(),
          ],
        ),
      ),
    );
  }
}
