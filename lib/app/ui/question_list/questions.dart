import 'package:flutter/material.dart';

class Questions extends StatelessWidget {
  const Questions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Text('질문 글 목록'),
      ),
    );
  }
}
