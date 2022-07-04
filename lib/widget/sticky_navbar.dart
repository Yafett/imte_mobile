import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sticky_headers/sticky_headers.dart';

class stickyHeader extends StatelessWidget {
  const stickyHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index) {
      return StickyHeader(
        header: Container(
          height: 50.0,
          color: Colors.blueGrey[700],
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.centerLeft,
          child: Text(
            'Header #$index',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        content: Container(child: Text('test')),
      );
    });
  }
}
