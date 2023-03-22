import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_page.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:sizer/sizer.dart';

class QuCommentInput extends StatefulWidget {
  const QuCommentInput({
    super.key,
    required this.token,
    required this.questionId,
    required this.provider,
  });

  final String token;
  final int questionId;
  final QuestionViewModel provider;

  @override
  State<QuCommentInput> createState() => _QuCommentInputState();
}

class _QuCommentInputState extends State<QuCommentInput> {
  String _commentText = '';
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  void _postWriteQuComment(
    QuestionViewModel provider,
    String token,
    int questionId,
    String comment,
  ) =>
      provider.postWriteQuComment(
        token,
        questionId,
        comment,
      );

  @override
  Widget build(BuildContext context) {
    QuestionPageState? parent = context.findAncestorStateOfType<QuestionPageState>();
    return Form(
      key: formKey,
      child: Column(
        children: [
          Container(height: 15),
          Row(
            children: [
              const Icon(Icons.subdirectory_arrow_right),
              Container(
                width: 100.w * (7.7 / 10),
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.cyan,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      maxLines: 3,
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
                        // 해야 할 것. 댓글 작성 post api 적용
                        if (formKey.currentState!.validate()) {
                          parent?.setState(() {
                            formKey.currentState?.save();
                            _postWriteQuComment(widget.provider, widget.token, widget.questionId, _commentText);
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
          Container(height: 15),
        ],
      ),
    );
  }
}
