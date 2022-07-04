import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
            colors: [Color.fromRGBO(0, 211, 254, 1),Color.fromRGBO(64, 106, 179, 1)]),
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
      body: Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromRGBO(0, 211, 254, 1),Color.fromRGBO(64, 106, 179, 1)]
          )),
          child: Column(
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
          )),
    );
  }
}
