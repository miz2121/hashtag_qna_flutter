import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hashtag_qna_flutter/app/ui/question/component/qu_an_edit_delete_buttons.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/comment.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/write_comment.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_page.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class AnswerBody extends StatefulWidget {
  const AnswerBody({
    super.key,
    required this.fromWhere,
    required this.token,
    required this.snapshot,
    required this.answerIndex,
    required this.provider,
  });
  final String fromWhere;
  final String token;
  final AsyncSnapshot<Map<String, dynamic>> snapshot;
  final int answerIndex;
  final QuestionViewModel provider;

  @override
  State<AnswerBody> createState() => AnswerBodyState();
}

class AnswerBodyState extends State<AnswerBody> {
  String _userRatingString = "5";
  IconData? _selectedIcon;

  @override
  Widget build(BuildContext context) {
    QuestionPageState? parent = context.findAncestorStateOfType<QuestionPageState>();
    return Center(
      child: SizedBox(
        width: 100.w * (9 / 10),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.subdirectory_arrow_right),
                Container(
                  width: 100.w * (8.35 / 10),
                  margin: EdgeInsets.fromLTRB(0, 2.w, 0, 2.w),
                  padding: EdgeInsets.fromLTRB(5.w, 2.w, 5.w, 2.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.cyan,
                      width: 2.w,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 15.w),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '답변',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 100.w / 15,
                              color: Colors.cyan[700],
                            ),
                          ),
                          (((widget.snapshot.data!["questionDto"]["editable"]) == true) && ((widget.snapshot.data!["questionDto"]["questionStatus"]) == "OPEN"))
                              ? ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                AlertDialog(
                                                  title: const Text('별점을 매길 수 있습니다.\n채택이 완료되면 해당 질문글은\n"닫힌 글" 상태가 됩니다.'),
                                                  content: Center(
                                                    child: RatingBar.builder(
                                                      minRating: 1,
                                                      maxRating: 5,
                                                      initialRating: 5,
                                                      itemCount: 5,
                                                      itemSize: 10.w,
                                                      itemBuilder: (context, _) => Icon(
                                                        _selectedIcon ?? Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate: (rating) {
                                                        setState(() {
                                                          _userRatingString = rating.toInt().toString();
                                                          logger.d("_userRatingString: $_userRatingString");
                                                        });
                                                      },
                                                      updateOnDrag: true,
                                                    ),
                                                  ),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () async {
                                                            var response = await widget.provider.patchselectAnswerAndGiveScore(
                                                              widget.token,
                                                              widget.snapshot.data!["questionDto"]["id"],
                                                              widget.snapshot.data!["answerDtos"][widget.answerIndex]["id"],
                                                              _userRatingString,
                                                            );
                                                            if (!mounted) return;
                                                            if (response['code'] != null) {
                                                              switch (response['code']) {
                                                                case "INVALID_PARAMETER":
                                                                  exceptionShowDialog(context, "INVALID_PARAMETER");
                                                                  break;
                                                                case "NOT_MEMBER_OR_INACTIVE":
                                                                  exceptionShowDialog(context, "회원이 아니거나 비활성화된 회원입니다.");
                                                                  break;
                                                                case "EDIT_QUESTION_AUTH":
                                                                  exceptionShowDialog(context, '작성자만이 수정 및 삭제가 가능합니다.');
                                                                  break;
                                                                case "CLOSED_QUESTION_AUTH":
                                                                  exceptionShowDialog(context, '닫힌 질문은 수정 및 삭제가 불가능합니다.');
                                                                  break;
                                                                case "SELECT_AUTH":
                                                                  exceptionShowDialog(context, '질문 작성자만이 채택할 수 있습니다.');
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
                                                          },
                                                          child: const Text('채택 완료'),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: const Text('채택하기!'),
                                )
                              : widget.snapshot.data!["questionDto"]["questionStatus"] == "CLOSED"
                                  ? (Row(
                                      children: [
                                        for (int i = 0; i < widget.snapshot.data!["answerDtos"][widget.answerIndex]["rating"]; i++)
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                      ],
                                    ))
                                  : Container(),
                        ],
                      ),
                      Container(height: 5.w),
                      Text(
                        widget.snapshot.data!["answerDtos"][widget.answerIndex]["content"],
                        style: Theme.of(context).textTheme.bodyLarge!,
                      ),
                      Container(height: 5.w),
                      Text(
                        DateFormat('yy년 MM월 dd일 a:h시 mm분').format(DateTime.parse(widget.snapshot.data!["answerDtos"][widget.answerIndex]["date"])),
                      ),
                      Text(
                        widget.snapshot.data!["answerDtos"][widget.answerIndex]["writer"],
                      ),
                      Text(widget.snapshot.data!["answerDtos"][widget.answerIndex]["answerStatus"] == 'SELECTED' ? '채택됨!' : '채택 안됨!'),
                      const Row(
                          // children: _printStar(snapshot, i),
                          ),
                      Text('댓글 수: ${widget.snapshot.data!["answerDtos"][widget.answerIndex]["anCommentCount"]}'),

                      (widget.snapshot.data!["answerDtos"][widget.answerIndex]["editable"] == true && widget.snapshot.data!["questionDto"]["questionStatus"] == "OPEN")
                          ?
                          // 작성자 본인이라 수정 가능하고, 질문글이 채택된 게 있어서 닫힌 상태가 아니면
                          // 수정버튼 삭제버튼을 띄움
                          QuAnEditDeleteButtons(
                              fromWhere: "AnswerBody",
                              answerIndex: widget.answerIndex,
                              token: widget.token,
                              provider: widget.provider,
                              snapshot: widget.snapshot,
                            )
                          : Container(),

                      Container(height: 5.w),
                      Divider(thickness: 1.w),
                      Container(height: 5.w),

                      // 답변 댓글창
                      for (int c = 0; c < widget.snapshot.data!["anCommentDtos"].length; c++)
                        widget.snapshot.data!["anCommentDtos"][c]["answerId"] == widget.snapshot.data!["answerDtos"][widget.answerIndex]["id"]
                            ? Comment(
                                fromWhere: "AnswerBody",
                                token: widget.token,
                                snapshot: widget.snapshot,
                                provider: widget.provider,
                                answerIndex: widget.answerIndex,
                                i: c,
                              )
                            : Container(),

                      widget.fromWhere == 'QuestionPage'
                          ? WriteComment(
                              fromWhere: "AnswerBody",
                              token: widget.token,
                              questionId: widget.snapshot.data!["questionDto"]["id"],
                              answerId: widget.snapshot.data!["answerDtos"][widget.answerIndex]["id"],
                              provider: widget.provider,
                            )
                          : widget.fromWhere == 'CreateAnswer'
                              ? Container()
                              : Container()
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
