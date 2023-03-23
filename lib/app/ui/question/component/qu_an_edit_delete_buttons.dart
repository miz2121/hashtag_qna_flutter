import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_page.dart';
import 'package:hashtag_qna_flutter/app/ui/question/component/edit_qu_an.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_page.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:sizer/sizer.dart';

class QuAnEditDeleteButtons extends StatefulWidget {
  const QuAnEditDeleteButtons({
    super.key,
    required this.fromWhere, // "QuestionBody, AnswerBody"
    required this.provider,
    required this.token,
    required this.snapshot,
    this.answerIndex,
  });

  final String fromWhere; // "QuestionBody, AnswerBody"
  final QuestionViewModel provider;
  final String token;
  final AsyncSnapshot<Map<String, dynamic>> snapshot;
  final int? answerIndex;

  @override
  State<QuAnEditDeleteButtons> createState() => _QuAnEditDeleteButtonsState();
}

class _QuAnEditDeleteButtonsState extends State<QuAnEditDeleteButtons> {
  @override
  Widget build(BuildContext context) {
    QuestionPageState? parent = context.findAncestorStateOfType<QuestionPageState>();
    HomePageState? gParent = context.findAncestorStateOfType<HomePageState>();
    return Column(
      children: [
        Container(height: 5.w),
        Row(
          // 수정하기, 삭제하기 버튼
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // 수정하기
            widget.fromWhere == "QuestionBody"
                ? EditQuAn(
                    fromWhere: "QuestionBody",
                    token: widget.token,
                    provider: widget.provider,
                    snapshot: widget.snapshot,
                  )
                : widget.fromWhere == "AnswerBody"
                    ? EditQuAn(
                        fromWhere: "AnswerBody",
                        answerIndex: widget.answerIndex,
                        token: widget.token,
                        provider: widget.provider,
                        snapshot: widget.snapshot,
                      )
                    : Container(),
            Container(width: 1.w),

            // 삭제하기
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('삭제 확인'),
                        content: const Text('질문을 삭제하시겠습니까?\n댓글과 답변이 모두 사라집니다.'),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  switch (widget.fromWhere) {
                                    case "QuestionBody":
                                      await widget.provider.postRemoveQuestion(widget.token, widget.snapshot.data!["questionDto"]["id"]);
                                      break;
                                    case "AnswerBody":
                                      await widget.provider.postRemoveAnswer(widget.token, widget.snapshot.data!["questionDto"]["id"], widget.snapshot.data!["answerDtos"][widget.answerIndex]["id"]);
                                      break;
                                  }
                                  if (!mounted) return;

                                  switch (widget.provider.previous) {
                                    case "homePage":
                                      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                                      break;
                                    case "questionsPage":
                                      Navigator.pushNamedAndRemoveUntil(context, '/questions', (route) => false);
                                      break;
                                  }
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
        ),
      ],
    );
  }
}
