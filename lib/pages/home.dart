import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://imte.education/assets/imtepuri.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    _controller.play();
    _controller.setLooping(true);
  }

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

  Widget loginButton() {
    return InkWell(
        onTap: () {
          _controller.pause();

          Navigator.pushNamed(context, '/sign-in');
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 115),
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(75),
            color: Color(0xffAE2329),
          ),
          child: Text('Login',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              )),
        ));
  }

  Widget smallText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Start Now!",
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white,
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
            height: 154,
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
