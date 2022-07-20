import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 100, left: 150),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'on development',
            style: TextStyle(color: Colors.grey),
          )
        ]),
      ),
    );
  }
}
