import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/question/component/edit_qu_an.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_page.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
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
                        content: widget.fromWhere == "QuestionBody" ? const Text('질문을 삭제하시겠습니까?\n댓글과 답변이 모두 사라집니다.') : (widget.fromWhere == "AnswerBody" ? const Text('답변을 삭제하시겠습니까?\n댓글이 모두 사라집니다.') : Container()),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  switch (widget.fromWhere) {
                                    case "QuestionBody":
                                      var response = await widget.provider.postRemoveQuestion(widget.token, widget.snapshot.data!["questionDto"]["id"]);
                                      if (!mounted) return;
                                      if (response['data'] != null) {
                                        switch (response['data']) {
                                          case "INVALID_PARAMETER":
                                            exceptionShowDialog(context, "INVALID_PARAMETER");
                                            break;
                                          case "NOT_MEMBER":
                                            exceptionShowDialog(context, '등록된 회원 정보가 없습니다.');
                                            break;
                                          case "EDIT_QUESTION_AUTH":
                                            exceptionShowDialog(context, '작성자만이 질문을 수정 및 삭제할 수 있습니다.');
                                            break;
                                          case "CLOSED_QUESTION_AUTH":
                                            exceptionShowDialog(context, '닫힌 글은 더 이상 수정할 수 없습니다.');
                                            break;
                                          case "INACTIVE_MEMBER":
                                            exceptionShowDialog(context, '비활성화된 회원입니다.');
                                            break;
                                          case "RESOURCE_NOT_FOUND":
                                            exceptionShowDialog(context, "RESOURCE_NOT_FOUND");
                                            break;
                                          case "INTERNAL_SERVER_ERROR":
                                            exceptionShowDialog(context, "INTERNAL_SERVER_ERROR");
                                            break;
                                          default:
                                            logger.e("Error");
                                            throw Exception("Error");
                                        }
                                      }
                                      break;
                                    case "AnswerBody":
                                      var response = await widget.provider.postRemoveAnswer(widget.token, widget.snapshot.data!["questionDto"]["id"], widget.snapshot.data!["answerDtos"][widget.answerIndex]["id"]);
                                      if (!mounted) return;
                                      if (response['data'] != null) {
                                        switch (response['data']) {
                                          case "INVALID_PARAMETER":
                                            exceptionShowDialog(context, "INVALID_PARAMETER");
                                            break;
                                          case "NOT_MEMBER":
                                            exceptionShowDialog(context, '등록된 회원 정보가 없습니다.');
                                            break;
                                          case "EDIT_ANSWER_AUTH":
                                            exceptionShowDialog(context, '작성자만이 답변을 수정 및 삭제할 수 있습니다.');
                                            break;
                                          case "CLOSED_QUESTION_AUTH":
                                            exceptionShowDialog(context, '닫힌 글의 답변은 더 이상 수정 및 삭제할 수 없습니다.');
                                            break;
                                          case "INACTIVE_MEMBER":
                                            exceptionShowDialog(context, '비활성화된 회원입니다.');
                                            break;
                                          case "RESOURCE_NOT_FOUND":
                                            exceptionShowDialog(context, "RESOURCE_NOT_FOUND");
                                            break;
                                          case "INTERNAL_SERVER_ERROR":
                                            exceptionShowDialog(context, "INTERNAL_SERVER_ERROR");
                                            break;
                                          default:
                                            logger.e("Error");
                                            throw Exception("Error");
                                        }
                                      }
                                      break;
                                  }
                                  if (!mounted) return;
                                  switch (widget.fromWhere) {
                                    case "QuestionBody": // 질문의 삭제 버튼이면
                                      switch (widget.provider.previous) {
                                        case "/home":
                                          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                                          break;
                                        case "/question_list":
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/question_list',
                                            (route) => false,
                                            arguments: {
                                              'token': widget.token,
                                              'titleText': '전체 질문을 보여드립니다.',
                                              'currentPage': 1,
                                            },
                                          );
                                          break;
                                      }
                                      break;
                                    case "AnswerBody": // 답변의 삭제 버튼이면
                                      Navigator.of(context).pop();
                                      parent?.setState(() {});
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
