import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnswerBody extends StatelessWidget {
  const AnswerBody({
    super.key,
    required this.snapshot,
    required this.displayWidth,
    required this.buttonFontSize,
    required this.i,
  });

  final AsyncSnapshot<Map<String, dynamic>> snapshot;
  final double displayWidth;
  final double buttonFontSize;
  final int i;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: displayWidth * (9 / 10),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.subdirectory_arrow_right),
              Container(
                width: displayWidth * (8.1 / 10),
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.cyan,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 15),
                    Text(
                      '답변',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: buttonFontSize,
                        color: Colors.cyan[700],
                      ),
                    ),
                    Container(height: 15),
                    Text(
                      snapshot.data!["answerDtos"][i]["content"],
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ),
                    Container(height: 15),
                    Text(
                      DateFormat('yy년 MM월 dd일 a:h시 mm분').format(DateTime.parse(snapshot.data!["answerDtos"][i]["date"])),
                    ),
                    Text(
                      snapshot.data!["answerDtos"][i]["writer"],
                    ),
                    Text(snapshot.data!["answerDtos"][i]["answerStatus"] == 'SELECTED' ? '채택됨!' : '채택 안됨!'),
                    const Row(
                        // children: _printStar(snapshot, i),
                        ),
                    Text('댓글 수: ${snapshot.data!["answerDtos"][i]["anCommentCount"]}'),

                    Container(height: 15),
                    const Divider(thickness: 1),
                    Container(height: 15),

                    // 여기부터 답변 댓글
                    for (int c = 0; c < snapshot.data!["quCommentDtos"].length; c++)
                      Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.subdirectory_arrow_right),
                              Container(
                                width: displayWidth * (6.8 / 10),
                                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.cyan,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          snapshot.data!["anCommentDtos"][i]["content"],
                                          style: Theme.of(context).textTheme.bodyLarge!,
                                        ),
                                        Text(
                                          snapshot.data!["anCommentDtos"][i]["writer"],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      DateFormat('yy년 MM월 dd일 a:h시 mm분').format(DateTime.parse(snapshot.data!["anCommentDtos"][i]["date"])),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(height: 15),
                        ],
                      ),
                    Container(height: 15),
                    // 여기까지 답변 댓글
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
