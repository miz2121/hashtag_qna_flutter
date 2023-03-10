import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class CreatePage extends StatelessWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Text('해시태그를 만드시겠습니까?'),
        ),
      ),
    );
  }
}
