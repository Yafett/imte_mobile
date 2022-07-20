import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsDeatilPage extends StatelessWidget {
  const NewsDeatilPage({Key? key}) : super(key: key);

  headerImage() {
    return Container(
        padding: EdgeInsets.all(20),
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/nw1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [],
        ));
  }

  headerText() {
    return Container(
      padding: EdgeInsets.all(15),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thursday, 20 December 2022',
            style: GoogleFonts.poppins(
              color: Color(0xffA5A5A5),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Shinzo Abe death: shock in Japan at killing of former PM during election campaign',
            style: GoogleFonts.poppins(
              color: Color(0xff24253D),
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  content() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Text(
        'Sorrow and disbelief descended on Japan after Shinzo Abe – the former prime minister and a towering political figure – was shot dead while giving a campaign speech on Friday morning \n\nAbe, 67, was pronounced dead early in the evening, prompting a flood of tributes from current and former world leaders, and anger that a politician could be gunned down in broad daylight in one of the world’s safest societies two days before an election. \n\nA man looks at a screen broadcasting the news of the shooting of Shinzo Abe in Nara Abe shooting: why gun violence is so rare in zero-tolerance Japa Read more  Abe, the country’s longest-serving prime minister, who resigned in 2020, was flown to hospital by helicopter after the attack outside Yamato Saidaiji railway station in Nara, an ancient capital in the country’s west known for its Buddhist temples and free-roaming deer. \n\nAs the light faded on Friday, supporters and local residents visited the scene of the attack – a pedestrian crossing next to a white guardrail – where Abe had been calling on voters to re-elect his Liberal Democratic party (LDP) colleague Kei Sato in this Sunday’s upper house elections when he was shot.',
        style: GoogleFonts.poppins(
          fontSize: 17,
        ),
      ),
    );
  }

  newsCard() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Image border
                child: SizedBox.fromSize(
                  size: Size.fromRadius(48), // Image radius
                  child: Image.asset('assets/image/nw1.jpg', fit: BoxFit.cover),
                ),
              ),
              Flexible(
                child: Column(
                  children: [
                    new Container(
                      margin: EdgeInsets.only(left: 10),
                      padding: new EdgeInsets.only(right: 13.0),
                      child: new Text(
                        'Shinzo Abe death: shock in Japan at killing of former PM during election campaign',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: new TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF212121),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            child: Row(children: [
                              Icon(
                                Icons.perm_identity,
                                color: Color(0xff9D9D9D),
                                size: 18.0,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                'Pak Juned',
                                style: GoogleFonts.poppins(
                                  color: Color(0xff9D9D9D),
                                  fontSize: 12,
                                ),
                              ),
                            ]),
                          ),
                          Container(
                            child: Row(children: [
                              Icon(
                                Icons.watch_later_outlined,
                                color: Color(0xff9D9D9D),
                                size: 18.0,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                '20 - 12 - 2022',
                                style: GoogleFonts.poppins(
                                  color: Color(0xff9D9D9D),
                                  fontSize: 12,
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
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
            child: const DecoratedBox(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 22, 20, 20)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(children: [
            Column(
              children: [
                headerImage(),
                headerText(),
                content(),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Color.fromARGB(255, 255, 255, 255),
                  size: 40.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
