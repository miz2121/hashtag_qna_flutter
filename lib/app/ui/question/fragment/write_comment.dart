import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_page.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
import 'package:sizer/sizer.dart';

class WriteComment extends StatefulWidget {
  const WriteComment({
    super.key,
    required this.fromWhere, // "QuestionBody, AnswerBody"
    required this.token,
    required this.questionId,
    this.answerId,
    required this.provider,
  });

  final String fromWhere; // "QuestionBody, AnswerBody"
  final String token;
  final int questionId;
  final int? answerId;
  final QuestionViewModel provider;

  @override
  State<WriteComment> createState() => _WriteCommentState();
}

class _WriteCommentState extends State<WriteComment> {
  String _commentText = '';
  int aid = 0;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    super.initState();
    if (widget.answerId != null) {
      // "fromWhere == AnswerBody"
      aid = widget.answerId!;
    }
  }

  @override
  Widget build(BuildContext context) {
    QuestionPageState? parent = context.findAncestorStateOfType<QuestionPageState>();
    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.subdirectory_arrow_right),
              Container(
                width: (widget.fromWhere == "AnswerBody" ? 100.w * (6.3 / 10) : (widget.fromWhere == "QuestionBody" ? 100.w * (6.9 / 10) : 0)),
                padding: EdgeInsets.fromLTRB(2.w, 1.w, 2.w, 1.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.cyan,
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: '댓글을 입력해 주세요',
                      ),
                      validator: (value) => value!.isEmpty ? 'comment can not be empty' : null,
                      onSaved: (value) {
                        _commentText = value!;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('확인해 주세요.'),
                                  content: const Text('댓글을 등록할까요?'),
                                  actions: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                            onPressed: () async {
                                              formKey.currentState?.save();

                                              switch (widget.fromWhere) {
                                                case "AnswerBody":
                                                  var response = await widget.provider.postWriteAnComment(widget.token, widget.questionId, aid, _commentText);
                                                  if (!mounted) return;
                                                  if (response['code'] != null) {
                                                    switch (response['code']) {
                                                      case "INVALID_PARAMETER":
                                                        exceptionShowDialog(context, "INVALID_PARAMETER");
                                                        break;
                                                      case "NOT_MEMBER":
                                                        exceptionShowDialog(context, "회원 정보가 없습니다.");
                                                        break;
                                                      case "EDIT_COMMENT_AUTH":
                                                        exceptionShowDialog(context, "작성자만이 수정 및 삭제가 가능합니다.");
                                                        break;
                                                      case "INACTIVE_MEMBER":
                                                        exceptionShowDialog(context, "비활성화된 회원입니다.");
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
                                                  Navigator.of(context).pop();
                                                  parent?.setState(() {});
                                                  break;
                                                case "QuestionBody":
                                                  var response = await widget.provider.postWriteQuComment(widget.token, widget.questionId, _commentText);
                                                  if (!mounted) return;
                                                  if (response['code'] != null) {
                                                    switch (response['code']) {
                                                      case "INVALID_PARAMETER":
                                                        exceptionShowDialog(context, "INVALID_PARAMETER");
                                                        break;
                                                      case "NOT_MEMBER":
                                                        exceptionShowDialog(context, "회원 정보가 없습니다.");
                                                        break;
                                                      case "EDIT_COMMENT_AUTH":
                                                        exceptionShowDialog(context, "작성자만이 수정 및 삭제가 가능합니다.");
                                                        break;
                                                      case "INACTIVE_MEMBER":
                                                        exceptionShowDialog(context, "비활성화된 회원입니다.");
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
                                                  Navigator.of(context).pop();
                                                  parent?.setState(() {});
                                                  break;
                                              }
                                            },
                                            child: const Text('확인')),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('취소')),
                                      ],
                                    ),
                                  ],
                                );
                              });
                        }
                      },
                      child: const Text('댓글 작성'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(height: 5.w),
        ],
      ),
    );
  }
}
