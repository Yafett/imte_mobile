import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imte_mobile/widget/history-card.dart';

import '../widget/gradient-text.dart';

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imte_mobile/widget/news-card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class saffa extends StatefulWidget {
  const saffa({Key? key}) : super(key: key);

  @override
  State<saffa> createState() => _saffaState();
}

class _saffaState extends State<saffa> {
  @override
  void initState() {
    super.initState();
  }

  Widget newsHeader() {
    return GestureDetector(
      onTap: () {},
      child: Container(
          padding: EdgeInsets.all(20),
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/image.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "'V.I.P Imunization' fot the powerful and Their Cronies Ratles South America",
                style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text('see more',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Icon(
                    Icons.arrow_right,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              newsHeader(),
              Container(
                height: 350,
                padding: EdgeInsets.all(15),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    newsCard(
                        onTap: () {
                          Navigator.pushNamed(context, '/news-detail');
                        },
                        title:
                            "PASS OVER, SOMETHING ROTTEN & More - Check Out This Week's Top Stage Mags",
                        user: 'Mr. John',
                        date: '21 - 02 - 2021',
                        image: Image.network(
                          'https://static-cse.canva.com/blob/688642/TealandYellowChurchIconDotsCharityEventFundraisingPoster.jpg',
                          fit: BoxFit.fill,
                        )),
                    newsCard(
                        onTap: () {
                          Navigator.pushNamed(context, '/news-detail');
                        },
                        title:
                            "PASS OVER, SOMETHING ROTTEN & More - Check Out This Week's Top Stage Mags",
                        user: 'Mr. John',
                        date: '21 - 02 - 2021',
                        image: Image.network(
                          'https://static-cse.canva.com/blob/688642/TealandYellowChurchIconDotsCharityEventFundraisingPoster.jpg',
                          fit: BoxFit.fill,
                        )),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: Text(
                        'Sign In ',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(249, 255, 255, 255)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
