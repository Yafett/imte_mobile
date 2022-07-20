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
  });

  final String textScore;
  final String textResult;
  final String textPeriod;
  final String textTeacher;
  final String textDate;
  final ImageProvider image;
  final String textGrade;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Container(
          height: 100,
          width: 100,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textScore,
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  color: Color(0xff4CAF50),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                textResult,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Color(0xff4CAF50),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          // height: 100,
          width: MediaQuery.of(context).size.height * 0.32,
          margin: EdgeInsets.only(left: 5),
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
          child: Column(children: [
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
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(textTeacher),
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
                      borderRadius: BorderRadius.circular(20)),
                ),
                // ColorFiltered(
                //   colorFilter: ColorFilter.mode(
                //     Colors.grey,
                //     BlendMode.saturation,
                //   ),
                //   child: Container(
                //     margin: EdgeInsets.only(bottom: 5),
                //     height: 50,
                //     width: 50,
                //     decoration: BoxDecoration(
                //       border: Border.all(),
                //         image: DecorationImage(
                //           image: AssetImage(
                //             'assets/image/1.png',
                //           ),
                //           fit: BoxFit.fill,
                //         ),
                //         borderRadius: BorderRadius.circular(20)),
                //   ),
                // )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(textDate),
                Text(textGrade),
              ],
            )
          ]),
        ),
      ]),
    );
  }
}
