import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/qu_comment.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/qu_comment_input.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class QuestionBody extends StatelessWidget {
  const QuestionBody({
    super.key,
    required this.snapshot,
    required this.token,
    required this.provider,
  });

  final AsyncSnapshot<Map<String, dynamic>> snapshot;
  final String token;
  final QuestionViewModel provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 15),
        Text(
          '질문',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 100.w / 15,
            color: Colors.cyan[700],
          ),
        ),
        Container(height: 15),
        Text(
          snapshot.data!["questionDto"]["title"],
          style: Theme.of(context).textTheme.bodyLarge!,
        ),
        Container(height: 15),
        Text(
          DateFormat('yy년 MM월 dd일 a:h시 mm분').format(DateTime.parse(snapshot.data!["questionDto"]["date"])),
        ),
        Text('${snapshot.data!["questionDto"]["writer"]}'),
        Text(snapshot.data!["questionDto"]["questionStatus"] == "CLOSED" ? "답변 채택 완료(닫힌 글)" : "답변 채택 전(열린 글)"),
        Text(
          '댓글 수: ${snapshot.data!["questionDto"]["quCommentCount"]}',
        ),
        Text(
          '답변 수: ${snapshot.data!["questionDto"]["answerCount"]}',
        ),
        Container(height: 15),
        Text(
          snapshot.data!["questionDto"]["content"],
          style: Theme.of(context).textTheme.bodyLarge!,
        ),
        Container(height: 15),
        const Divider(thickness: 1),
        // 댓글창
        for (int i = 0; i < snapshot.data!["quCommentDtos"].length; i++)
          QuComment(
            index: i,
            snapshot: snapshot,
          ),
        // 댓글 작성 창
        QuCommentInput(
          token: token,
          questionId: snapshot.data!["questionDto"]["id"],
          provider: provider,
        ),
      ],
    );
  }
}
