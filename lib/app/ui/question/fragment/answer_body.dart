import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/an_comment.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/an_comment_input.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class AnswerBody extends StatelessWidget {
  const AnswerBody({
    super.key,
    required this.token,
    required this.snapshot,
    required this.answerIndex,
    required this.provider,
  });

  final String token;
  final AsyncSnapshot<Map<String, dynamic>> snapshot;
  final int answerIndex;
  final QuestionViewModel provider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w * (9 / 10),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.subdirectory_arrow_right),
              Container(
                width: 100.w * (8.1 / 10),
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.cyan,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 15),
                    Text(
                      '답변',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 100.w / 15,
                        color: Colors.cyan[700],
                      ),
                    ),
                    Container(height: 15),
                    Text(
                      snapshot.data!["answerDtos"][answerIndex]["content"],
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ),
                    Container(height: 15),
                    Text(
                      DateFormat('yy년 MM월 dd일 a:h시 mm분').format(DateTime.parse(snapshot.data!["answerDtos"][answerIndex]["date"])),
                    ),
                    Text(
                      snapshot.data!["answerDtos"][answerIndex]["writer"],
                    ),
                    Text(snapshot.data!["answerDtos"][answerIndex]["answerStatus"] == 'SELECTED' ? '채택됨!' : '채택 안됨!'),
                    const Row(
                        // children: _printStar(snapshot, i),
                        ),
                    Text('댓글 수: ${snapshot.data!["answerDtos"][answerIndex]["anCommentCount"]}'),

                    Container(height: 15),
                    const Divider(thickness: 1),
                    Container(height: 15),

                    // 답변 댓글창
                    for (int c = 0; c < snapshot.data!["anCommentDtos"].length; c++)
                      AnComment(
                        snapshot: snapshot,
                        i: c,
                      ),

                    // 답변 댓글 작성 창
                    AnCommentInput(
                      token: token,
                      questionId: snapshot.data!["questionDto"]["id"],
                      answerId: snapshot.data!["answerDtos"][answerIndex]["id"],
                      provider: provider,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
