import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imte_mobile/models/News.dart';
import 'package:imte_mobile/pages/news-detail.dart';
import 'package:imte_mobile/shared/theme.dart';
import 'package:imte_mobile/widget/history-card.dart';
import 'package:imte_mobile/widget/news-card.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../widget/gradient-text.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  var listNews = [];

  String lastId = '';
  String lastDate = '';
  String lastUser = '';
  String lastTitle = '';
  String lastImage = '';
  String lastContent = '';
  String tests = '';
  bool loading = true;

  // ! get News Data
  dataImage() async {
    String API_URL = 'https://adm.imte.education/api/blog/showAll';

    final response = await http.get(Uri.parse(API_URL));

    final data = await json.decode(response.body);

    for (var a = 0; a < data.length; a++) {
      listNews.add(News.fromJson(data[a]));
      var itemNews = listNews[a];

      setState(() {
        lastId = itemNews.id.toString();
        lastTitle = itemNews.title.toString();
        lastUser = itemNews.firstName.toString();
        lastDate = itemNews.createdAt;
        lastImage = itemNews.filename.toString();
        lastContent = itemNews.content.toString();
      });
      print(itemNews.createdAt);
    }
    DateTime dt = DateTime.parse(lastDate);

    print(DateFormat.yMMMd().format(dt));

    setState(() {
      loading = false;
    });
  }

  // ! Empty Page ( when no news Detected )
  emptyPart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(15),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('No Updated News',
                style: blackTextStyle.copyWith(fontSize: 16)),
          ]),
    );
  }

  // !  News List
  buildListview(index) {
    var itemNews = listNews[index];
    DateTime dt = DateTime.parse(itemNews.createdAt);

    return newsCard(
      title: itemNews.title,
      user: itemNews.firstName,
      date: DateFormat.yMMMd().format(dt),
      image: Image.network(
        'https://adm.imte.education/img/BlogImages/' + itemNews.filename,
        fit: BoxFit.fill,
      ),
      newsDate: DateFormat.yMMMd().format(dt),
      newsTitle: itemNews.title,
      newsUser: itemNews.firstName,
      newsImage:
          'https://adm.imte.education/img/BlogImages/' + itemNews.filename,
      newsContent: itemNews.content,
    );
  }

  // ! NewsPage ( when news detected)
  newsPart() {
    DateTime dt = DateTime.parse(lastDate);

    return Column(children: [
      // ! NewsPage Header
      GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewsDetailPage(
                        date: DateFormat.yMMMd().format(dt),
                        title: lastTitle,
                        user: lastUser,
                        newsImage:
                            'https://adm.imte.education/img/BlogImages/' +
                                lastImage,
                        newsTitle: lastTitle,
                        newsDate: DateFormat.yMMMd().format(dt),
                        newsUser: lastUser,
                        newsContent: lastContent,
                      )));
        },
        child: Container(
            padding: EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height * 0.5 - 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
              color: const Color(0xff7c94b6),
              image: new DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                    BlendMode.darken),
                image: new NetworkImage(
                  'https://adm.imte.education/img/BlogImages/' +
                      lastImage.toString(),
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  lastTitle,
                  textAlign: TextAlign.start,
                  style: whiteTextStyle.copyWith(
                      fontSize: 28, fontWeight: semiBold),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      'see more',
                      style: whiteTextStyle.copyWith(
                          fontSize: 16, fontWeight: semiBold),
                    ),
                    Icon(
                      Icons.arrow_right,
                      color: Colors.white,
                    )
                  ],
                ),
              ],
            )),
      ),

      // ! NewsPage body
      Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: EdgeInsets.all(15),
        child: ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: listNews.length,
            itemBuilder: (BuildContext context, int index) {
              return buildListview(index);
            }),
      )
    ]);
  }

  // ! membuat loading bar
  Widget loadingBar() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Now Loading...',
            style: greyTextStyle.copyWith(fontSize: 20),
          )
        ],
      ),
    );

    // Container(
    //   height: MediaQuery.of(context).size.height,
    //   width: MediaQuery.of(context).size.width,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       CircularProgressIndicator(
    //         strokeWidth: 5,
    //         color: Color.fromARGB(255, 70, 111, 234),
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  void initState() {
    super.initState();
    dataImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: (loading == true) ? loadingBar() : newsPart());
  }
}
