import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:imte_mobile/pages/profile-edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsDetailPage extends StatefulWidget {
  final String title;
  final String user;
  final String date;
  final String newsImage;
  final String newsDate;
  final String newsTitle;
  final String newsUser;
  final String newsContent;

  const NewsDetailPage(
      {Key? key,
      required this.date,
      required this.user,
      required this.newsImage,
      required this.newsDate,
      required this.newsTitle,
      required this.newsUser,
      required this.newsContent,
      required this.title})
      : super(key: key);

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  String date = '';
  String user = '';
  String title = '';
  String newsUser = '';
  String newsDate = '';
  String newsImage = '';
  String newsTitle = '';
  String newsContent = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  // ! NewsDetail Image
  headerImage() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(widget.newsImage),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  // ! NewsDetail Title
  headerText() {
    return Column(
      children: [
        SizedBox(height: 30),
        Text(
          widget.newsTitle,
          style: GoogleFonts.roboto(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // ! NewsDeatil Header Content
  headerContent() {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey,
          child: Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.newsUser,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 18),
            ),
            Text(
              widget.newsDate,
              style: GoogleFonts.roboto(
                  fontSize: 18, color: Color.fromARGB(255, 115, 115, 115)),
            ),
          ],
        ),
      ],
    );
  }

  // ! NewsDetail Content
  content() {
    return Container(
        child: Html(
      data: widget.newsContent,
      style: {
        'p': Style.fromTextStyle(
            GoogleFonts.gothicA1(fontSize: 17, letterSpacing: 1)),
        'html': Style(textAlign: TextAlign.justify),
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(15),
          child: Column(children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Color.fromARGB(255, 82, 82, 82),
                    size: 30.0,
                  ),
                ),
              ],
            ),
            headerText(),
            SizedBox(height: 30),
            headerContent(),
            SizedBox(height: 30),
            headerImage(),
            SizedBox(height: 20),
            content()
          ]),
        )),
      ),
    );
  }
}
