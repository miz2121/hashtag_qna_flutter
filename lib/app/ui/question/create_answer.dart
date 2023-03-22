import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/answer_body.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/question_body.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:sizer/sizer.dart';

class CreateAnswer extends ConsumerStatefulWidget {
  const CreateAnswer({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateAnswer> createState() => _CreateAnswerState();
}

class _CreateAnswerState extends ConsumerState<CreateAnswer> {
  final formKey = GlobalKey<FormState>();
  int id = 0;
  String token = '';
  late QuestionViewModel provider;
  String _answer = '';

  @override
  void initState() {
    super.initState();
    provider = ref.read(questionViewModelProvider.notifier);
  }

  @override
  void didChangeDependencies() {
    id = (ModalRoute.of(context)!.settings.arguments as Map)['id'];
    token = (ModalRoute.of(context)!.settings.arguments as Map)['token'];
    super.didChangeDependencies();
    provider = ref.watch(questionViewModelProvider.notifier);
  }

  FutureOr onGoBack(dynamic _) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                        width: 100.w * (9 / 10),
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.cyan,
                            width: 2,
                          ),
                        ),
                        // 질문 내용
                        child: QuestionBody(
                          fromWhere: 'CreateAnswer',
                          snapshot: snapshot,
                          token: token,
                          provider: provider,
                        ),
                      ),
                      Container(height: 15.w),
                      SizedBox(
                        width: 100.w * (9 / 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.subdirectory_arrow_right),
                                Container(
                                  width: 100.w * (8.1 / 10),
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
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Container(height: 15.w),
                                      Text(
                                        '답변 작성',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 100.w / 15,
                                          color: Colors.cyan[700],
                                        ),
                                      ),
                                      Container(height: 15.w),
                                      Form(
                                        key: formKey,
                                        child: TextFormField(
                                          maxLines: 10,
                                          decoration: const InputDecoration(
                                            labelText: '답변을 입력해 주세요',
                                          ),
                                          validator: (value) => value!.isEmpty ? '답변을 입력해 주세요.' : null,
                                          onSaved: (value) {
                                            _answer = value!;
                                          },
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (formKey.currentState!.validate()) {
                                            formKey.currentState?.save();
                                            await provider.postWriteAnswer(token, id, _answer);
                                            if (!mounted) return;
                                            Navigator.pop(context, true);
                                          }
                                        },
                                        child: const Text('답변 작성'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // 답변 내용
                      for (int answerIndex = 0; answerIndex < snapshot.data!["answerDtos"].length; answerIndex++)
                        AnswerBody(
                          fromWhere: 'CreateAnswer',
                          token: token,
                          snapshot: snapshot,
                          answerIndex: answerIndex,
                          provider: provider,
                        ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
