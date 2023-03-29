import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/answer_body.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/question_body.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_page.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
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
    QuestionPageState? parent = context.findAncestorStateOfType<QuestionPageState>();

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
              }
              if (snapshot.data!['code'] != null) {
                switch (snapshot.data!['code']) {
                  case "INVALID_PARAMETER":
                    exceptionShowDialog(context, "INVALID_PARAMETER");
                    break;
                  case "NOT_MEMBER":
                    exceptionShowDialog(context, "NOT_MEMBER");
                    break;
                  case "INACTIVE_MEMBER":
                    exceptionShowDialog(context, "INACTIVE_MEMBER");
                    break;
                  case "RESOURCE_NOT_FOUND":
                    exceptionShowDialog(context, "RESOURCE_NOT_FOUND");
                    break;
                  case "INTERNAL_SERVER_ERROR":
                    exceptionShowDialog(context, "INTERNAL_SERVER_ERROR");
                    break;
                  default:
                    logger.e('ERROR');
                    throw Exception("Error");
                }
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100.w * (9 / 10),
                      margin: EdgeInsets.all(5.w),
                      padding: EdgeInsets.fromLTRB(5.w, 2.w, 5.w, 2.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.cyan,
                          width: 2.w,
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
                    Container(height: 5.w),
                    SizedBox(
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
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: const Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Center(child: Text('답변을 제출합니다.')),
                                                  ],
                                                ),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          if (formKey.currentState!.validate()) {
                                                            formKey.currentState?.save();
                                                            var response = await provider.postWriteAnswer(token, id, _answer);
                                                            if (!mounted) return;
                                                            if (response['code'] != null) {
                                                              switch (response['code']) {
                                                                case "INVALID_PARAMETER":
                                                                  exceptionShowDialog(context, "INVALID_PARAMETER");
                                                                  break;
                                                                case "NOT_MEMBER":
                                                                  exceptionShowDialog(context, '등록된 회원 정보가 없습니다.');
                                                                  break;
                                                                case "CLOSED_QUESTION_AUTH":
                                                                  exceptionShowDialog(context, '닫힌 글에는 더 이상 답변을 달거나 수정 및 삭제할 수 없습니다.');
                                                                  break;
                                                                case "ANSWER_AUTH":
                                                                  exceptionShowDialog(context, '질문 작성자는 답변을 달 수 없습니다.');
                                                                  break;
                                                                case "INACTIVE_MEMBER":
                                                                  exceptionShowDialog(context, '비활성화 된 회원입니다.');
                                                                  break;
                                                                case "RESOURCE_NOT_FOUND":
                                                                  exceptionShowDialog(context, "RESOURCE_NOT_FOUND");
                                                                  break;
                                                                case "INTERNAL_SERVER_ERROR":
                                                                  exceptionShowDialog(context, "INTERNAL_SERVER_ERROR");
                                                                  break;
                                                                default:
                                                                  logger.e('Error');
                                                                  throw Exception("Error");
                                                              }
                                                            }

                                                            Navigator.of(context).popUntil(ModalRoute.withName("/question"));
                                                            WidgetsBinding.instance.addPostFrameCallback((_) => parent?.setState(() {}));
                                                          }
                                                        },
                                                        child: const Text('확인'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () => Navigator.of(context).pop(),
                                                        child: const Text('취소'),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            });
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
            },
          ),
        ),
      ),
    );
  }
}
