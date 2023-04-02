import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class InfoComponent extends StatelessWidget {
  const InfoComponent({
    super.key,
    required this.snapshot,
    required this.information,
  });

  final AsyncSnapshot<Map<String, dynamic>> snapshot;
  final String information;

  @override
  Widget build(BuildContext context) {
    String jsonKey = '';
    double informationWidth = 0;
    switch (information) {
      case "닉네임":
        jsonKey = "nickname";
        informationWidth = 55.w;
        break;
      case "이메일":
        jsonKey = "email";
        informationWidth = 55.w;
        break;
      case "생성한 질문 수":
        jsonKey = "questionCount";
        informationWidth = 35.w;
        break;
      case "생성한 답변 수":
        jsonKey = "answerCount";
        informationWidth = 35.w;
        break;
      case "생성한 댓글 수":
        jsonKey = "commentCount";
        informationWidth = 35.w;
        break;
      case "생성한 해시태그 수":
        jsonKey = "hashtagCount";
        informationWidth = 20.w;
        break;
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$information: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 100.w / 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(
            width: informationWidth,
            child: Text(
              '${snapshot.data![jsonKey]}',
              style: TextStyle(
                fontSize: 100.w / 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
