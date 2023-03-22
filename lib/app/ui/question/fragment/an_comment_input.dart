import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_page.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:sizer/sizer.dart';

class AnCommentInput extends StatefulWidget {
  const AnCommentInput({
    super.key,
    required this.token,
    required this.questionId,
    required this.answerId,
    required this.provider,
  });

  final String token;
  final int questionId;
  final int answerId;
  final QuestionViewModel provider;

  @override
  State<AnCommentInput> createState() => _AnCommentInputState();
}

class _AnCommentInputState extends State<AnCommentInput> {
  String _commentText = '';
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  void _postWriteAnComment(
    QuestionViewModel provider,
    String token,
    int questionId,
    int answerId,
    String comment,
  ) =>
      provider.postWriteAnComment(
        token,
        questionId,
        answerId,
        comment,
      );

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
                          parent?.setState(() {
                            formKey.currentState?.save();
                            _postWriteAnComment(widget.provider, widget.token, widget.questionId, widget.answerId, _commentText);
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
