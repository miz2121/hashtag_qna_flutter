import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/edit_comment.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_page.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class AnComment extends StatefulWidget {
  const AnComment({
    super.key,
    required this.token,
    required this.snapshot,
    required this.provider,
    required this.answerIndex,
    required this.i,
  });

  final String token;
  final AsyncSnapshot<Map<String, dynamic>> snapshot;
  final QuestionViewModel provider;
  final int answerIndex;
  final int i;

  @override
  State<AnComment> createState() => _AnCommentState();
}

class _AnCommentState extends State<AnComment> {
  @override
  Widget build(BuildContext context) {
    QuestionPageState? parent = context.findAncestorStateOfType<QuestionPageState>();
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.subdirectory_arrow_right),
            Container(
              width: 100.w * (6.3 / 10),
              padding: EdgeInsets.fromLTRB(2.w, 1.w, 2.w, 1.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.cyan,
                  width: 1.w,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 40.w,
                        child: Text(
                          widget.snapshot.data!["anCommentDtos"][widget.i]["content"],
                          style: Theme.of(context).textTheme.bodyLarge!,
                        ),
                      ),
                      Container(width: 1.w),
                      SizedBox(
                        width: 14.w,
                        child: Text(
                          widget.snapshot.data!["anCommentDtos"][widget.i]["writer"],
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    DateFormat('yy년 MM월 dd일 a:h시 mm분').format(
                      DateTime.parse(
                        widget.snapshot.data!["anCommentDtos"][widget.i]["date"],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        widget.snapshot.data!["anCommentDtos"][widget.i]["editable"] == true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.subdirectory_arrow_right),
                  EditComment(
                    comment: widget.snapshot.data!["anCommentDtos"][widget.i]["content"],
                    i: widget.i,
                    questionId: widget.snapshot.data!["questionDto"]["id"],
                    answerId: widget.snapshot.data!["answerDtos"][widget.answerIndex]["id"],
                    anCommentId: widget.snapshot.data!["anCommentDtos"][widget.i]["id"],
                    token: widget.token,
                    provider: widget.provider,
                  ),
                  Container(width: 1.w),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('삭제 확인'),
                              content: const Text('댓글을 삭제하시겠습니까?'),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        await widget.provider.postDeleteAnComment(
                                          widget.token,
                                          widget.snapshot.data!["questionDto"]["id"],
                                          widget.snapshot.data!["answerDtos"][widget.answerIndex]["id"],
                                          widget.snapshot.data!["anCommentDtos"][widget.i]["id"],
                                        );
                                        parent?.setState(() {});
                                      },
                                      child: const Text('확인'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('취소'),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          });
                    },
                    child: const Text('삭제하기'),
                  ),
                ],
              )
            : Container(),
        Container(height: 5.w),
      ],
    );
  }
}
