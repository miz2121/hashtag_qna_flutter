import 'package:flutter/material.dart';

class QuestionsByHashtag extends StatelessWidget {
  const QuestionsByHashtag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('해시태그로 조회한 게시글 목록'),
      ),
    );
  }
}