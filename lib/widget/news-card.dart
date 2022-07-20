import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class newsCard extends StatelessWidget {
  const newsCard({
    required this.title,
    required this.user,
    required this.date,
    required this.image,
  });

  final String title;
  final String user;
  final String date;
  final Image image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20), // Image border
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(48), // Image radius
                    child: image,
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  children: [
                    new Container(
                      margin: EdgeInsets.only(left: 10),
                      padding: new EdgeInsets.only(right: 13.0),
                      child: new Text(
                        title,
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
                                user,
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
                                date,
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
    ;
  }
}
