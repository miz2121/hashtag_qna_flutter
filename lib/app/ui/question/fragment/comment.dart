import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/edit_comment.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_page.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class Comment extends StatefulWidget {
  const Comment({
    super.key,
    required this.fromWhere, // "QuestionBody, AnswerBody"
    required this.token,
    required this.snapshot,
    required this.provider,
    this.answerIndex,
    required this.i,
  });

  final String fromWhere; // "QuestionBody, AnswerBody"
  final String token;
  final AsyncSnapshot<Map<String, dynamic>> snapshot;
  final QuestionViewModel provider;
  final int? answerIndex;
  final int i;

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    QuestionPageState? parent = context.findAncestorStateOfType<QuestionPageState>();
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.subdirectory_arrow_right),
            Container(
              width: widget.fromWhere == "QuestionBody" ? 100.w * (6.9 / 10) : (widget.fromWhere == "AnswerBody" ? 100.w * (6.3 / 10) : 0),
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
                        child: widget.fromWhere == "QuestionBody"
                            ? Text(
                                widget.snapshot.data!["quCommentDtos"][widget.i]["content"],
                                style: Theme.of(context).textTheme.bodyLarge!,
                              )
                            : (widget.fromWhere == "AnswerBody"
                                ? Text(
                                    widget.snapshot.data!["anCommentDtos"][widget.i]["content"],
                                    style: Theme.of(context).textTheme.bodyLarge!,
                                  )
                                : Container()),
                      ),
                      Container(width: 1.w),
                      SizedBox(
                        width: 14.w,
                        child: widget.fromWhere == "QuestionBody"
                            ? Text(
                                widget.snapshot.data!["quCommentDtos"][widget.i]["writer"],
                                textAlign: TextAlign.end,
                              )
                            : (widget.fromWhere == "AnswerBody"
                                ? Text(
                                    widget.snapshot.data!["anCommentDtos"][widget.i]["writer"],
                                    textAlign: TextAlign.end,
                                  )
                                : Container()),
                      ),
                    ],
                  ),
                  widget.fromWhere == "QuestionBody"
                      ? Text(
                          DateFormat('yy년 MM월 dd일 a:h시 mm분').format(
                            DateTime.parse(widget.snapshot.data!["quCommentDtos"][widget.i]["date"]),
                          ),
                        )
                      : (widget.fromWhere == "AnswerBody"
                          ? Text(
                              DateFormat('yy년 MM월 dd일 a:h시 mm분').format(
                                DateTime.parse(
                                  widget.snapshot.data!["anCommentDtos"][widget.i]["date"],
                                ),
                              ),
                            )
                          : Container()),
                ],
              ),
            ),
            Container(height: 5.w),
          ],
        ),
        widget.fromWhere == "QuestionBody"
            ? (widget.snapshot.data!["quCommentDtos"][widget.i]["editable"] == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.subdirectory_arrow_right),
                      EditComment(
                        fromWhere: "quComment",
                        comment: widget.snapshot.data!["quCommentDtos"][widget.i]["content"],
                        i: widget.i,
                        questionId: widget.snapshot.data!["questionDto"]["id"],
                        quCommentId: widget.snapshot.data!["quCommentDtos"][widget.i]["id"],
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
                                              widget.snapshot.data!["quCommentDtos"][widget.i]["id"],
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
                : Container())
            : widget.fromWhere == "AnswerBody"
                ? (widget.snapshot.data!["anCommentDtos"][widget.i]["editable"] == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.subdirectory_arrow_right),
                          EditComment(
                            fromWhere: "anComment",
                            comment: widget.snapshot.data!["anCommentDtos"][widget.i]["content"],
                            i: widget.i,
                            questionId: widget.snapshot.data!["questionDto"]["id"],
                            answerId: widget.snapshot.data!["answerDtos"][widget.answerIndex]["id"],
                            anCommentId: widget.snapshot.data!["anCommentDtos"][widget.i]["id"],
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
                                                await widget.provider.postDeleteAnComment(
                                                  widget.token,
                                                  widget.snapshot.data!["questionDto"]["id"],
                                                  widget.snapshot.data!["answerDtos"][widget.answerIndex]["id"],
                                                  widget.snapshot.data!["anCommentDtos"][widget.i]["id"],
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
                    : Container())
                : Container(),
        Container(height: 5.w),
      ],
    );
  }
}
