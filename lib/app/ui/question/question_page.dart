import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class QuestionPage extends ConsumerStatefulWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends ConsumerState<QuestionPage> {
  late final GlobalKey<FormState> formKey;
  String _comment = '';
  double displayWidth = 0;
  double buttonFontSize = 0;
  int id = 0;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    formKey = GlobalKey<FormState>();
    displayWidth = MediaQuery.of(context).size.width;
    buttonFontSize = displayWidth / 15;
    id = (ModalRoute.of(context)!.settings.arguments as Map)['id'];
  }

  List<Icon> _printStar(AsyncSnapshot<dynamic> snapshot, int i) {
    List<Icon> star = [];
    int rating = 0;
    switch (snapshot.data!["answerDtos"][i]["rating"]) {
      case "1":
        rating = 1;
        break;
      case "2":
        rating = 2;
        break;
      case "3":
        rating = 3;
        break;
      case "4":
        rating = 4;
        break;
      case "5":
        rating = 5;
        break;
    }
    for (int s = 0; s < rating; s++) {
      star.add(const Icon(Icons.star));
    }
    if (star.length < 6) {
      while (star.length != 5) {
        star.add(const Icon(Icons.star_border));
      }
    }
    return star;
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(questionViewModelProvider.notifier);

    return Scaffold(
      body: Form(
        key: formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: FutureBuilder<Map<String, dynamic>>(
                future: provider.getQuestionMaps(id),
                builder: (_, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error = ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }
                  if (snapshot.data!.isEmpty) {
                    return Container();
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: displayWidth * (9 / 10),
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
                                  '질문',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: buttonFontSize,
                                    color: Colors.cyan[700],
                                  ),
                                ),
                                Container(height: 15),
                                Text(
                                  snapshot.data!["questionDto"]["title"],
                                  style: Theme.of(context).textTheme.bodyLarge!,
                                ),
                                Container(height: 15),
                                Text(
                                  DateFormat('yy년 MM월 dd일 a:h시 mm분').format(
                                      DateTime.parse(snapshot
                                          .data!["questionDto"]["date"])),
                                ),
                                Text(
                                    '${snapshot.data!["questionDto"]["writer"]}'),
                                Text(snapshot.data!["questionDto"]
                                            ["questionStatus"] ==
                                        "CLOSED"
                                    ? "답변 채택 완료(닫힌 글)"
                                    : "답변 채택 전(열린 글)"),
                                Text(
                                  '댓글 수: ${snapshot.data!["questionDto"]["quCommentCount"]}',
                                ),
                                Text(
                                  '답변 수: ${snapshot.data!["questionDto"]["answerCount"]}',
                                ),
                                Container(height: 15),
                                Text(
                                  snapshot.data!["questionDto"]["content"],
                                  style: Theme.of(context).textTheme.bodyLarge!,
                                ),
                                Container(height: 15),
                                const Divider(thickness: 1),
                                Container(height: 15),
                                // 여기부터 댓글
                                for (int i = 0;
                                    i < snapshot.data!["quCommentDtos"].length;
                                    i++)
                                  Row(
                                    children: [
                                      const Icon(
                                          Icons.subdirectory_arrow_right),
                                      Container(
                                        width: displayWidth * (7.7 / 10),
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 10, 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.cyan,
                                            width: 2,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data![
                                                          "quCommentDtos"][i]
                                                      ["content"],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!,
                                                ),
                                                Text(
                                                  snapshot.data![
                                                          "quCommentDtos"][i]
                                                      ["writer"],
                                                ),
                                              ],
                                            ),
                                            Text(
                                              DateFormat(
                                                      'yy년 MM월 dd일 a:h시 mm분')
                                                  .format(DateTime.parse(
                                                      snapshot.data![
                                                              "quCommentDtos"]
                                                          [i]["date"])),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(height: 15),
                                    ],
                                  ),
                                Container(height: 15),
                                // 여기까지 댓글
                                // 여기부터 댓글 작성 창
                                Row(
                                  children: [
                                    const Icon(Icons.subdirectory_arrow_right),
                                    Container(
                                      width: displayWidth * (7.7 / 10),
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.cyan,
                                          width: 2,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          TextFormField(
                                            maxLines: 3,
                                            decoration: const InputDecoration(
                                              labelText: '댓글을 입력해 주세요',
                                            ),
                                            validator: (value) => value!.isEmpty
                                                ? 'comment can not be empty'
                                                : null,
                                            onSaved: (value) {
                                              _comment = value!;
                                            },
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              // 해야 할 것. 댓글 작성 post api 적용
                                              if (formKey.currentState!
                                                  .validate()) {
                                                formKey.currentState?.save();
                                              }
                                            },
                                            child: const Text('댓글 작성'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // 여기까지 댓글 작성 창
                                Container(height: 15),
                              ],
                            ),
                          ),
                          Container(height: 15),

                          // 여기부터 답변
                          for (int i = 0;
                              i < snapshot.data!["answerDtos"].length;
                              i++)
                            Container(
                              width: displayWidth * (9 / 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                          Icons.subdirectory_arrow_right),
                                      Container(
                                        width: displayWidth * (8.1 / 10),
                                        margin: const EdgeInsets.all(5),
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 10, 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.cyan,
                                            width: 2,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              snapshot.data!["answerDtos"][i]
                                                  ["content"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!,
                                            ),
                                            Container(height: 15),
                                            Text(
                                              DateFormat(
                                                      'yy년 MM월 dd일 a:h시 mm분')
                                                  .format(DateTime.parse(
                                                      snapshot.data![
                                                              "answerDtos"][i]
                                                          ["date"])),
                                            ),
                                            Text(
                                              snapshot.data!["answerDtos"][i]
                                                  ["writer"],
                                            ),
                                            Text(snapshot.data!["answerDtos"][i]
                                                        ["answerStatus"] ==
                                                    'SELECTED'
                                                ? '채택됨!'
                                                : '채택 안됨!'),
                                            Row(
                                              children: _printStar(snapshot, i),
                                            ),
                                            Text(
                                                '댓글 수: ${snapshot.data!["answerDtos"][i]["anCommentCount"]}'),

                                            Container(height: 15),
                                            const Divider(thickness: 1),
                                            Container(height: 15),

                                            // 여기부터 답변 댓글
                                            for (int c = 0;
                                                c <
                                                    snapshot
                                                        .data!["quCommentDtos"]
                                                        .length;
                                                c++)
                                              Row(
                                                children: [
                                                  const Icon(Icons
                                                      .subdirectory_arrow_right),
                                                  Container(
                                                    width: displayWidth *
                                                        (6.8 / 10),
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 5, 10, 5),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: Colors.cyan,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              snapshot.data![
                                                                      "anCommentDtos"]
                                                                  [
                                                                  i]["content"],
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge!,
                                                            ),
                                                            Text(
                                                              snapshot.data![
                                                                      "anCommentDtos"]
                                                                  [i]["writer"],
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          DateFormat(
                                                                  'yy년 MM월 dd일 a:h시 mm분')
                                                              .format(DateTime.parse(
                                                                  snapshot.data![
                                                                          "anCommentDtos"][i]
                                                                      [
                                                                      "date"])),
                                                        ),
                                                      ],
                                                    ),
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
                            ), // 여기까지 답변
                        ],
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}
