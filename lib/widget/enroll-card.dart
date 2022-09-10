import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';

class enrollCard extends StatefulWidget {
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
  State<enrollCard> createState() => _enrollCardState();
}

class _enrollCardState extends State<enrollCard> {
  String? scanResult;

  Future scanBarcode() async {
    String scanResult;

    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      scanResult = 'Failed to scan';
    }

    if (!mounted) return;

    setState(() => this.scanResult = scanResult);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // pickImage();
          scanBarcode();
        },
        child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 10, left: 0),
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
                      Text(widget.textPeriod,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                      Text(
                        widget.textGrade,
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
                              Text(widget.textCourse,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff616161),
                                  )),
                              Icon(
                                Icons.check,
                                color: widget.color,
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
                            Text('Live',
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
                ])));
  }
}
