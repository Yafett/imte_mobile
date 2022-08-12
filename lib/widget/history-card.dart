import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imte_mobile/widget/gradient-text.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    required this.textScore,
    required this.textResult,
    required this.textPeriod,
    required this.textDate,
    required this.image,
    required this.textGrade,
    required this.textTeacher,
    required this.color,
    required this.textColor,
  });

  final String textScore;
  final String textResult;
  final String textPeriod;
  final String textTeacher;
  final String textDate;
  final ImageProvider image;
  final String textGrade;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Container(
          height: MediaQuery.of(context).size.width * 0.3,
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1), //color of shadow
                  spreadRadius: 5, //spread radius
                  blurRadius: 10, // blur radius
                  offset: Offset(0, 2),
                ),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textScore,
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                textResult,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // !
        Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.width * 0.3,
          width: MediaQuery.of(context).size.width * 0.6,
          margin: EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          textPeriod,
                          style: GoogleFonts.poppins(
                            color: Color(0xff505050),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Text(
                            textTeacher,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              fontSize: 12.0,
                              color: new Color(0xFF212121),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: image,
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      textDate,
                      style: GoogleFonts.poppins(),
                    ),
                    Text(
                      textGrade,
                      style: GoogleFonts.poppins(),
                    ),
                  ],
                )
              ]),
        ),
      ]),
    );
  }
}
