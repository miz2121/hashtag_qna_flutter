import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/edit_comment.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_page.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class QuComment extends StatefulWidget {
  const QuComment({
    super.key,
    required this.index,
    required this.snapshot,
    required this.token,
    required this.provider,
  });

  final int index;
  final AsyncSnapshot<Map<String, dynamic>> snapshot;
  final String token;
  final QuestionViewModel provider;

  @override
  State<QuComment> createState() => _QuCommentState();
}

class _QuCommentState extends State<QuComment> {
  @override
  Widget build(BuildContext context) {
    QuestionPageState? parent = context.findAncestorStateOfType<QuestionPageState>();
    return Column(
      children: [
        Container(height: 5.w),
        Row(
          children: [
            const Icon(Icons.subdirectory_arrow_right),
            Container(
              width: 100.w * (6.9 / 10),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 40.w,
                        child: Text(
                          widget.snapshot.data!["quCommentDtos"][widget.index]["content"],
                          style: Theme.of(context).textTheme.bodyLarge!,
                        ),
                      ),
                      Container(width: 1.w),
                      SizedBox(
                        width: 14.w,
                        child: Text(
                          widget.snapshot.data!["quCommentDtos"][widget.index]["writer"],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    DateFormat('yy년 MM월 dd일 a:h시 mm분').format(
                      DateTime.parse(widget.snapshot.data!["quCommentDtos"][widget.index]["date"]),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 5.w),
          ],
        ),
        widget.snapshot.data!["quCommentDtos"][widget.index]["editable"] == true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.subdirectory_arrow_right),
                  EditComment(
                    comment: widget.snapshot.data!["quCommentDtos"][widget.index]["content"],
                    i: widget.index,
                    questionId: widget.snapshot.data!["questionDto"]["id"],
                    quCommentId: widget.snapshot.data!["quCommentDtos"][widget.index]["id"],
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
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        await widget.provider.postDeleteQuComment(
                                          widget.token,
                                          widget.snapshot.data!["questionDto"]["id"],
                                          widget.snapshot.data!["quCommentDtos"][widget.index]["id"],
                                        );
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
              )
            : Container(),
      ],
    );
  }
}
