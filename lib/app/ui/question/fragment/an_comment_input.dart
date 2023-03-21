import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:sizer/sizer.dart';

class AnCommentInput extends StatefulWidget {
  const AnCommentInput({
    super.key,
    required this.formKey,
    required this.token,
    required this.questionId,
    required this.answerId,
    required this.provider,
  });

  final GlobalKey<FormState> formKey;
  final String token;
  final int questionId;
  final int answerId;
  final QuestionViewModel provider;

  @override
  State<AnCommentInput> createState() => _AnCommentInputState();
}

class _AnCommentInputState extends State<AnCommentInput> {
  String _commentText = '';

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
    return Column(
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
                      if (widget.formKey.currentState!.validate()) {
                        widget.formKey.currentState?.save();
                      }
                      _postWriteAnComment(widget.provider, widget.token, widget.questionId, widget.answerId, _commentText);
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
    );
  }
}
