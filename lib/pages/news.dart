import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imte_mobile/pages/news_detail.dart';
import 'package:imte_mobile/widget/history-card.dart';
import 'package:imte_mobile/widget/news-card.dart';

import '../widget/gradient-text.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  newsPart() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewsDeatilPage()));
          },
          child: Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image/image.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "'V.I.P Imunization' fot the powerful and Their Cronies Ratles South America",
                    style: GoogleFonts.poppins(
                        fontSize: 28,
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
                              fontWeight: FontWeight.w400,
                              color: Colors.white)),
                      Icon(
                        Icons.arrow_right,
                        color: Colors.white,
                      )
                    ],
                  ),
                ],
              )),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
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
            ],
          ),
        )
      ],
    );
  }

  emptyPart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(15),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'No Updated News',
              style: GoogleFonts.poppins(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: SingleChildScrollView(
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 350) {
          return emptyPart();
        }
        // ! Small screens
        return Column(
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                  padding: EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/image/image.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12))),
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
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(10),
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
                ],
              ),
            )
          ],
        );
      }),
    )));
  }
}
