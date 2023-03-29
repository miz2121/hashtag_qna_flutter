import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/question/component/qu_an_edit_delete_buttons.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/comment.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/hashtags.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/write_comment.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_page.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class QuestionBody extends StatefulWidget {
  const QuestionBody({
    super.key,
    required this.fromWhere,
    required this.snapshot,
    required this.token,
    required this.provider,
  });

  final String fromWhere;
  final AsyncSnapshot<Map<String, dynamic>> snapshot;
  final String token;
  final QuestionViewModel provider;

  @override
  State<QuestionBody> createState() => _QuestionBodyState();
}

class _QuestionBodyState extends State<QuestionBody> {
  @override
  Widget build(BuildContext context) {
    QuestionPageState? parent = context.findAncestorStateOfType<QuestionPageState>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 15.w),
        Text(
          '질문',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 100.w / 15,
            color: Colors.cyan[700],
          ),
        ),
        Container(height: 5.w),
        Text(
          widget.snapshot.data?["questionDto"]?["title"] ?? '',
          style: Theme.of(context).textTheme.bodyLarge!,
        ),
        Container(height: 5.w),
        Text(
          DateFormat('yy년 MM월 dd일 a:h시 mm분').format(DateTime.parse(widget.snapshot.data!["questionDto"]?["date"] ?? DateTime.now().toString())),
        ),
        Text('${widget.snapshot.data!["questionDto"]?["writer"] ?? ''}'),
        Text((widget.snapshot.data!["questionDto"]?["questionStatus"] ?? '') == "CLOSED" ? "답변 채택 완료(닫힌 글)" : "답변 채택 전(열린 글)"),
        Text(
          '댓글 수: ${widget.snapshot.data!["questionDto"]?["quCommentCount"] ?? ''}',
        ),
        Text(
          '답변 수: ${widget.snapshot.data!["questionDto"]?["answerCount"] ?? ''}',
        ),
        Container(height: 5.w),
        Text(
          widget.snapshot.data!["questionDto"]?["content"] ?? '',
          style: Theme.of(context).textTheme.bodyLarge!,
        ),
        Container(height: 5.w),

        // 해당 글 해시태그
        Hashtags(
          provider: widget.provider,
          token: widget.token,
          snapshot: widget.snapshot,
        ),

        ((widget.snapshot.data!["questionDto"]?["editable"] ?? '') == true && ((widget.snapshot.data!["questionDto"]?["questionStatus"] ?? '') == "OPEN"))
            ?
            // 작성자 본인이라 수정 가능하고, 질문글이 채택된 게 있어서 닫힌 상태가 아니면
            // 수정버튼 삭제버튼을 띄움
            QuAnEditDeleteButtons(
                fromWhere: "QuestionBody",
                provider: widget.provider,
                token: widget.token,
                snapshot: widget.snapshot,
              )
            : Container(),

        Container(height: 5.w),
        Divider(thickness: 1.w),
        Container(height: 5.w),

        // 댓글창
        for (int i = 0; i < widget.snapshot.data!["quCommentDtos"]?.length; i++)
          Comment(
            fromWhere: "QuestionBody",
            token: widget.token,
            snapshot: widget.snapshot,
            provider: widget.provider,
            i: i,
          ),
        widget.fromWhere == 'QuestionPage'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  WriteComment(
                    fromWhere: "QuestionBody",
                    token: widget.token,
                    questionId: widget.snapshot.data!["questionDto"]?["id"] ?? 0,
                    provider: widget.provider,
                  ),
                  Divider(thickness: 1.w),
                  (widget.snapshot.data!["questionDto"]?["questionStatus"] ?? '') == "CLOSED"
                      ? const ElevatedButton(
                          onPressed: null,
                          child: Text('닫힌 글은 더 이상 답변을 달 수 없습니다.'),
                        )
                      : (widget.snapshot.data!["questionDto"]?["editable"]) == true
                          ? // 질문 글을 수정할 수 있다면 본인의 질문 글이므로, 본인이 본인 질문 글에 답변 달 수 없도록.
                          const ElevatedButton(
                              onPressed: null,
                              child: Text('답변 작성'),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                await Navigator.pushNamed(context, '/create_answer', arguments: {
                                  'id': widget.snapshot.data!["questionDto"]?["id"] ?? 0,
                                  'token': widget.token,
                                }).then((_) => {parent?.setState(() {})});
                              },
                              child: const Text('답변 작성'),
                            ),
                ],
              )
            : widget.fromWhere == 'CreateAnswer'
                ? Container()
                : Container()
      ],
    );
  }
}
