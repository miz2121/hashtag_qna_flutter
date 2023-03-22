import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/edit_comment.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class QuComment extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                          snapshot.data!["quCommentDtos"][index]["content"],
                          style: Theme.of(context).textTheme.bodyLarge!,
                        ),
                      ),
                      Container(width: 1.w),
                      SizedBox(
                        width: 14.w,
                        child: Text(
                          snapshot.data!["quCommentDtos"][index]["writer"],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    DateFormat('yy년 MM월 dd일 a:h시 mm분').format(
                      DateTime.parse(snapshot.data!["quCommentDtos"][index]["date"]),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 5.w),
          ],
        ),
        snapshot.data!["quCommentDtos"][index]["editable"] == true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.subdirectory_arrow_right),
                  EditComment(
                    comment: snapshot.data!["quCommentDtos"][index]["content"],
                    i: index,
                    questionId: snapshot.data!["questionDto"]["id"],
                    quCommentId: snapshot.data!["quCommentDtos"][index]["id"],
                    token: token,
                    provider: provider,
                  ),
                  Container(width: 1.w),
                  ElevatedButton(
                    onPressed: () => {},
                    child: const Text('삭제하기'),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
