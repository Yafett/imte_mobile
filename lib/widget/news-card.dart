import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imte_mobile/pages/news_detail.dart';

class newsCard extends StatelessWidget {
  const newsCard({
    required this.title,
    required this.user,
    required this.date,
    required this.image,
    required this.onTap,
  });

  final String title;
  final String user;
  final String date;
  final Image image;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NewsDeatilPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12), // Image border
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
                          style: GoogleFonts.poppins(
                            fontSize: 18.0,
                            color: new Color(0xFF212121),
                            fontWeight: FontWeight.w600,
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
      ),
    );
    ;
  }
}
