import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/question/component/qu_an_edit_delete_buttons.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/comment.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/write_comment.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class AnswerBody extends StatelessWidget {
  const AnswerBody({
    super.key,
    required this.fromWhere,
    required this.token,
    required this.snapshot,
    required this.answerIndex,
    required this.provider,
  });
  final String fromWhere;
  final String token;
  final AsyncSnapshot<Map<String, dynamic>> snapshot;
  final int answerIndex;
  final QuestionViewModel provider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100.w * (9 / 10),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.subdirectory_arrow_right),
                Container(
                  width: 100.w * (8.35 / 10),
                  margin: EdgeInsets.fromLTRB(0, 2.w, 0, 2.w),
                  padding: EdgeInsets.fromLTRB(5.w, 2.w, 5.w, 2.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.cyan,
                      width: 2.w,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 15.w),
                      Text(
                        '답변',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 100.w / 15,
                          color: Colors.cyan[700],
                        ),
                      ),
                      Container(height: 5.w),
                      Text(
                        snapshot.data!["answerDtos"][answerIndex]["content"],
                        style: Theme.of(context).textTheme.bodyLarge!,
                      ),
                      Container(height: 5.w),
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

                      (snapshot.data!["answerDtos"][answerIndex]["editable"] == true && snapshot.data!["questionDto"]["questionStatus"] == "OPEN")
                          ?
                          // 작성자 본인이라 수정 가능하고, 질문글이 채택된 게 있어서 닫힌 상태가 아니면
                          // 수정버튼 삭제버튼을 띄움
                          QuAnEditDeleteButtons(
                              fromWhere: "Answerbody",
                              answerIndex: answerIndex,
                              token: token,
                              provider: provider,
                              snapshot: snapshot,
                            )
                          : Container(),

                      Container(height: 5.w),
                      Divider(thickness: 1.w),
                      Container(height: 5.w),

                      // 답변 댓글창
                      for (int c = 0; c < snapshot.data!["anCommentDtos"].length; c++)
                        snapshot.data!["anCommentDtos"][c]["answerId"] == snapshot.data!["answerDtos"][answerIndex]["id"]
                            ? Comment(
                                fromWhere: "AnswerBody",
                                token: token,
                                snapshot: snapshot,
                                provider: provider,
                                answerIndex: answerIndex,
                                i: c,
                              )
                            : Container(),

                      fromWhere == 'QuestionPage'
                          ? WriteComment(
                              fromWhere: "AnswerBody",
                              token: token,
                              questionId: snapshot.data!["questionDto"]["id"],
                              answerId: snapshot.data!["answerDtos"][answerIndex]["id"],
                              provider: provider,
                            )
                          : fromWhere == 'CreateAnswer'
                              ? Container()
                              : Container()
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
