import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_page.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';

class EditComment extends ConsumerStatefulWidget {
  const EditComment({
    super.key,
    required this.comment,
    required this.i,
    required this.questionId,
    this.answerId,
    this.anCommentId,
    this.quCommentId,
    required this.token,
    required this.provider,
  });

  final String comment;
  final int i;
  final int questionId;
  final int? answerId;
  final int? anCommentId;
  final int? quCommentId;
  final String token;
  final QuestionViewModel provider;

  @override
  ConsumerState<EditComment> createState() => _EditCommentState();
}

class _EditCommentState extends ConsumerState<EditComment> {
  String _commentText = '';
  late final GlobalKey<FormState> formKey;
  late int aid;
  late int acid;
  late int qcid;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    super.initState();
    if (widget.answerId != null && widget.anCommentId != null) {
      // 답변 댓글에서 넘어온 위젯이면
      aid = widget.answerId!;
      acid = widget.anCommentId!;
    } else if (widget.quCommentId != null) {
      // 질문 댓글에서 넘어온 위젯이면
      qcid = widget.quCommentId!;
    }
  }

  @override
  Widget build(BuildContext context) {
    QuestionPageState? parent = context.findAncestorStateOfType<QuestionPageState>();
    return ElevatedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Form(
                key: formKey,
                child: AlertDialog(
                  title: const Text('댓글을 수정할 수 있습니다.'),
                  content: TextFormField(
                      maxLines: 5,
                      decoration: InputDecoration(labelText: widget.comment),
                      validator: (value) => value!.isEmpty ? 'comment can not be empty' : null,
                      onSaved: (value) {
                        _commentText = value!;
                      }),
                  actions: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState?.save();

                              if (widget.answerId == null && widget.anCommentId == null) {
                                // 질문 댓글에서 넘어온 위젯이므로
                                await widget.provider.patchUpdateQuComment(widget.token, widget.questionId, qcid, _commentText);
                              } else if (widget.quCommentId == null) {
                                // 답변 댓글에서 넘어온 위젯이므로
                                await widget.provider.patchUpdateAnComment(widget.token, widget.questionId, aid, acid, _commentText);
                              }

                              if (!mounted) return;
                              Navigator.of(context).pop();
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
              );
            });
      },
      child: const Text('수정하기'),
    );
  }
}
