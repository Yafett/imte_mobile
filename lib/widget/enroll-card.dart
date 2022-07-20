import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imte_mobile/widget/gradient-text.dart';

class enrollCard extends StatelessWidget {
  const enrollCard({
    required this.textPeriod,
    required this.textGrade,
    required this.textCourse,
    required this.color,
  });

  final String textPeriod;
  final String textGrade;
  final String textCourse;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: MediaQuery.of(context).size.height * 0.46,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 10, left: 0),
            height: 135,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1), //color of shadow
                    spreadRadius: 5, //spread radius
                    blurRadius: 10, // blur radius
                    offset: Offset(0, 2),
                  ),
                ]),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(textPeriod,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                      Text(
                        textGrade,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Text(textCourse,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff616161),
                                  )),
                              Icon(
                                Icons.check,
                                color: color,
                                size: 30.0,
                              ),
                            ],
                          ),
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        VerticalDivider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 10,
                          endIndent: 10,
                          width: 25,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text('Phto',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff616161),
                                  )),
                              Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 30.0,
                              ),
                            ],
                          ),
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        VerticalDivider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 10,
                          endIndent: 10,
                          width: 25,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text('Pract',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff616161),
                                  )),
                              Icon(
                                Icons.check,
                                color: Colors.red,
                                size: 30.0,
                              ),
                            ],
                          ),
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        VerticalDivider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 10,
                          endIndent: 10,
                          width: 25,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text('Inst',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff616161),
                                  )),
                              Icon(
                                Icons.check,
                                color: Colors.grey,
                                size: 30.0,
                              ),
                            ],
                          ),
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        VerticalDivider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 10,
                          endIndent: 10,
                          width: 25,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text('Lurk',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff616161),
                                  )),
                              Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 30.0,
                              ),
                            ],
                          ),
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        VerticalDivider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 10,
                          endIndent: 10,
                          width: 25,
                        ),
                        Container(
                            child: Column(
                          children: [
                            Text('Prsnt',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff616161),
                                )),
                            Icon(
                              Icons.check,
                              color: Colors.red,
                              size: 30.0,
                            ),
                          ],
                        )),
                      ],
                    ),
                  )
                ])),
      ],
    );
  }
}
