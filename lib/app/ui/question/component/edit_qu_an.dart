import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_page.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_page.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';

class EditQuAn extends StatefulWidget {
  const EditQuAn({
    super.key,
    required this.fromWhere, // "QuestionBody, AnswerBody"
    this.answerIndex,
    required this.token,
    required this.provider,
    required this.snapshot,
  });

  final String fromWhere;
  final int? answerIndex;
  final String token;
  final QuestionViewModel provider;
  final AsyncSnapshot<Map<String, dynamic>> snapshot;

  @override
  State<EditQuAn> createState() => _EditQuAnState();
}

class _EditQuAnState extends State<EditQuAn> {
  late final GlobalKey<FormState> formKey;
  String _title = '';
  String _content = '';

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    QuestionPageState? parent = context.findAncestorStateOfType<QuestionPageState>();
    HomePageState? gParent = context.findAncestorStateOfType<HomePageState>();
    return ElevatedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return widget.fromWhere == "QuestionBody"
                  ? Form(
                      key: formKey,
                      child: AlertDialog(
                        title: const Text('질문을 수정할 수 있습니다.'),
                        content: Column(
                          children: [
                            Expanded(
                              child: TextFormField(
                                  decoration: InputDecoration(labelText: widget.snapshot.data!["questionDto"]["title"]),
                                  validator: (value) => value!.isEmpty ? "title can not be empty" : null,
                                  onSaved: (value) {
                                    _title = value!;
                                  }),
                            ),
                            Expanded(
                              child: TextFormField(
                                  maxLines: 5,
                                  decoration: InputDecoration(labelText: widget.snapshot.data!["questionDto"]["content"]),
                                  validator: (value) => value!.isEmpty ? "content can not be empty" : null,
                                  onSaved: (value) {
                                    _content = value!;
                                  }),
                            ),
                          ],
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState?.save();

                                    var response = await widget.provider.patchUpdateQuestion(widget.token, widget.snapshot.data!["questionDto"]["id"], _title, _content);
                                    if (!mounted) return;
                                    if (response['data'] != null) {
                                      switch (response['data']) {
                                        case "INVALID_PARAMETER":
                                          exceptionShowDialog(context, "INVALID_PARAMETER");
                                          break;
                                        case "NOT_MEMBER_OR_INACTIVE":
                                          exceptionShowDialog(context, "회원이 아니거나 비활성화된 회원입니다.");
                                          break;
                                        case "EDIT_QUESTION_AUTH":
                                          exceptionShowDialog(context, '작성자만이 질문을 수정 및 삭제할 수 있습니다.');
                                          break;
                                        case "CLOSED_QUESTION_AUTH":
                                          exceptionShowDialog(context, '닫힌 글은 더 이상 수정할 수 없습니다.');
                                          break;
                                        case "RESOURCE_NOT_FOUND":
                                          exceptionShowDialog(context, "RESOURCE_NOT_FOUND");
                                          break;
                                        case "INTERNAL_SERVER_ERROR":
                                          exceptionShowDialog(context, "INTERNAL_SERVER_ERROR");
                                          break;
                                        default:
                                          logger.e('Error');
                                          throw Exception("Error");
                                      }
                                    }
                                    Navigator.of(context).pop();
                                    gParent?.setState(() {});
                                    parent?.setState(() {});
                                  }
                                },
                                child: const Text('확인'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('취소'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : widget.fromWhere == "AnswerBody"
                      ? (Form(
                          key: formKey,
                          child: AlertDialog(
                            title: const Text('답변을 수정할 수 있습니다.'),
                            content: Column(
                              children: [
                                TextFormField(
                                    maxLines: 5,
                                    decoration: InputDecoration(labelText: widget.snapshot.data!["answerDtos"][widget.answerIndex]["content"]),
                                    validator: (value) => value!.isEmpty ? "title can not be empty" : null,
                                    onSaved: (value) {
                                      _content = value!;
                                    }),
                              ],
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState?.save();

                                        await widget.provider.patchUpdateAnswer(widget.token, widget.snapshot.data!["questionDto"]["id"], widget.snapshot.data!["answerDtos"][widget.answerIndex]["id"], _content);

                                        if (!mounted) return;
                                        Navigator.of(context).pop();
                                        gParent?.setState(() {});
                                        parent?.setState(() {});
                                      }
                                    },
                                    child: const Text('확인'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('취소'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))
                      : Container();
            });
      },
      child: const Text('수정하기'),
    );
  }
}
