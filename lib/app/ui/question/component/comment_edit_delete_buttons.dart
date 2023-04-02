import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/edit_comment.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_page.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
import 'package:sizer/sizer.dart';

class CommentEditDeleteButtons extends StatefulWidget {
  const CommentEditDeleteButtons({
    super.key,
    required this.fromWhere, // "QuestionBody, AnswerBody"
    required this.snapshot,
    required this.i,
    required this.token,
    required this.provider,
    this.answerIndex,
  });

  final String fromWhere; // "QuestionBody, AnswerBody"
  final AsyncSnapshot<Map<String, dynamic>> snapshot;
  final int i;
  final String token;
  final QuestionViewModel provider;
  final int? answerIndex;

  @override
  State<CommentEditDeleteButtons> createState() => _CommentEditDeleteButtonsState();
}

class _CommentEditDeleteButtonsState extends State<CommentEditDeleteButtons> {
  @override
  Widget build(BuildContext context) {
    QuestionPageState? parent = context.findAncestorStateOfType<QuestionPageState>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(Icons.subdirectory_arrow_right),
        widget.fromWhere == "QuestionBody"
            ? EditComment(
                fromWhere: "quComment",
                comment: widget.snapshot.data!["quCommentDtos"][widget.i]["content"],
                i: widget.i,
                questionId: widget.snapshot.data!["questionDto"]["id"],
                quCommentId: widget.snapshot.data!["quCommentDtos"][widget.i]["id"],
                token: widget.token,
                provider: widget.provider,
              )
            : (widget.fromWhere == "AnswerBody"
                ? EditComment(
                    fromWhere: "anComment",
                    comment: widget.snapshot.data!["anCommentDtos"][widget.i]["content"],
                    i: widget.i,
                    questionId: widget.snapshot.data!["questionDto"]["id"],
                    answerId: widget.snapshot.data!["answerDtos"][widget.answerIndex]["id"],
                    anCommentId: widget.snapshot.data!["anCommentDtos"][widget.i]["id"],
                    token: widget.token,
                    provider: widget.provider,
                  )
                : Container()),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () async {
                              switch (widget.fromWhere) {
                                case "QuestionBody":
                                  var response = await widget.provider.postRemoveQuComment(
                                    widget.token,
                                    widget.snapshot.data!["questionDto"]["id"],
                                    widget.snapshot.data!["quCommentDtos"][widget.i]["id"],
                                  );
                                  if (!mounted) return;
                                  if (response['data'] != null) {
                                    switch (response['data']) {
                                      case "INVALID_PARAMETER":
                                        exceptionShowDialog(context, "INVALID_PARAMETER");
                                        break;
                                      case "NOT_MEMBER_OR_INACTIVE":
                                        exceptionShowDialog(context, "회원이 아니거나 비활성화된 회원입니다.");
                                        break;
                                      case "EDIT_COMMENT_AUTH":
                                        exceptionShowDialog(context, '작성자만이 댓글을 수정 및 삭제할 수 있습니다.');
                                        break;
                                      case "RESOURCE_NOT_FOUND":
                                        exceptionShowDialog(context, "RESOURCE_NOT_FOUND");
                                        break;
                                      case "INTERNAL_SERVER_ERROR":
                                        exceptionShowDialog(context, "INTERNAL_SERVER_ERROR");
                                        break;
                                      default:
                                        logger.e("Error");
                                        throw Exception('Error');
                                    }
                                  }
                                  break;
                                case "AnswerBody":
                                  var response = await widget.provider.postRemoveAnComment(
                                    widget.token,
                                    widget.snapshot.data!["questionDto"]["id"],
                                    widget.snapshot.data!["answerDtos"][widget.answerIndex]["id"],
                                    widget.snapshot.data!["anCommentDtos"][widget.i]["id"],
                                  );
                                  if (!mounted) return;
                                  if (response['data'] != null) {
                                    switch (response['data']) {
                                      case "INVALID_PARAMETER":
                                        exceptionShowDialog(context, "INVALID_PARAMETER");
                                        break;
                                      case "NOT_MEMBER_OR_INACTIVE":
                                        exceptionShowDialog(context, "회원이 아니거나 비활성화된 회원입니다.");
                                        break;
                                      case "EDIT_COMMENT_AUTH":
                                        exceptionShowDialog(context, '작성자만이 댓글을 수정 및 삭제할 수 있습니다.');
                                        break;
                                      case "RESOURCE_NOT_FOUND":
                                        exceptionShowDialog(context, "RESOURCE_NOT_FOUND");
                                        break;
                                      case "INTERNAL_SERVER_ERROR":
                                        exceptionShowDialog(context, "INTERNAL_SERVER_ERROR");
                                        break;
                                      default:
                                        logger.e("Error");
                                        throw Exception('Error');
                                    }
                                  }
                                  break;
                              }

                              if (!mounted) return;
                              Navigator.of(context).pop();
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
    );
  }
}
