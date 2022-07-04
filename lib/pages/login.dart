import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ! appbar
      appBar: AppBar(
        title: Image.asset(
          'assets/image/logo.png',
          height: 100,
          width: 100,
          // fit: BoxFit.cover,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(0, 211, 254, 1),
                  Color.fromRGBO(64, 106, 179, 1)
                ]),
          ),
        ),
        actions: <Widget>[
          Row(
            children: [
              Icon(
                Icons.door_back_door_outlined,
              ),
              Padding(
                child: Text('Login', style: whiteTextStyle.copyWith()),
                padding: const EdgeInsets.only(left: 5.0, right: 15.0),
              ),
            ],
          )
        ],
      ),

      //! container
      body: SingleChildScrollView(
          child: Column(
        children: [
          // ! video
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/bg.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),

          Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(10),
              width: double.infinity,
              height: 210,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Color.fromRGBO(0, 211, 254, 1),
                    Color.fromRGBO(64, 106, 179, 1)
                  ])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Challange Your Musical Skill Here!',
                        textAlign: TextAlign.center,
                        style: whiteTextStyle.copyWith(
                          fontSize: 36,
                        ),
                      ),
                      Text(
                        'Creating | Performing | Responding | Instrument Knowledge',
                        textAlign: TextAlign.center,
                        style: whiteTextStyle.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              )),

          // ! image
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 103,
                  backgroundColor: Color.fromARGB(255, 255, 68, 68),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/image/learn.jpg'),
                  ),
                ),
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Creating ',
                        style: blackTextStyle.copyWith(fontSize: 26),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          textAlign: TextAlign.center,
                          style: blackTextStyle.copyWith(fontSize: 14),
                          'Students need to have experience in creating, to be successful musicians and to be successful 21st century citizens.'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 103,
                  backgroundColor: Color.fromARGB(255, 255, 68, 68),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/image/guitar.jpg'),
                  ),
                ),
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Performing ',
                        style: blackTextStyle.copyWith(fontSize: 26),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          textAlign: TextAlign.center,
                          style: blackTextStyle.copyWith(fontSize: 14),
                          'Students need to perform – as singers, as instrumentalists, and in their lives and careers.'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 103,
                  backgroundColor: Color.fromARGB(255, 255, 68, 68),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/image/teach.jpg'),
                  ),
                ),
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Responding',
                        style: blackTextStyle.copyWith(fontSize: 26),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          textAlign: TextAlign.center,
                          style: blackTextStyle.copyWith(fontSize: 14),
                          'Students need to respond to music, as well as to their culture, their community, and their colleagues.'),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '(American Standard of Music Education - NAFME Inspired)',
                        style: blackTextStyle.copyWith(fontSize: 8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ! instruments
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: new TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: new TextStyle(
                            fontSize: 24.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            new TextSpan(text: 'OPEN '),
                            new TextSpan(
                                text: 'for ',
                                style:
                                    new TextStyle(fontWeight: FontWeight.w300)),
                            new TextSpan(text: 'INSTRUMENTALS'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '| Piano | Drum | Acoustic Guitar | Electric Guitar | Vocal | Violin | Flute | Saxophone | Bass |',
                      textAlign: TextAlign.center,
                      style: blackTextStyle.copyWith(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Container(
                          width: 350,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white30,
                                backgroundImage:
                                    AssetImage('assets/image/1.png'),
                              ),
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white30,
                                backgroundImage:
                                    AssetImage('assets/image/2.png'),
                              ),
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white30,
                                backgroundImage:
                                    AssetImage('assets/image/3.png'),
                              ),
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white30,
                                backgroundImage:
                                    AssetImage('assets/image/4.png'),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white30,
                                backgroundImage:
                                    AssetImage('assets/image/5.png'),
                              ),
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white30,
                                backgroundImage:
                                    AssetImage('assets/image/6.png'),
                              ),
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white30,
                                backgroundImage:
                                    AssetImage('assets/image/7.png'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        
          // ! scedhule
          ,Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            height: 1000,
            color: kMaroonColor,
            child: Column(

              children: [
                Column(
                  children: [
                    Text('OPEN REGISTRATION', style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: kWhiteColor),),
                    Divider(
                      height: 50,
                      endIndent: 250,
                      thickness: 5,
                      color: kWhiteColor,
                    ),
                    Text('2nd PERIOD 2022', style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: kWhiteColor),)
                  ],
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
