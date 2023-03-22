import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/answer_body.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/question_body.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:sizer/sizer.dart';

class QuestionPage extends ConsumerStatefulWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<QuestionPage> createState() => QuestionPageState();
}

class QuestionPageState extends ConsumerState<QuestionPage> {
  int id = 0;
  String token = '';
  bool refresh = false;
  late QuestionViewModel provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(questionViewModelProvider.notifier);
  }

  @override
  void didChangeDependencies() {
    id = (ModalRoute.of(context)!.settings.arguments as Map)['id'];
    token = (ModalRoute.of(context)!.settings.arguments as Map)['token'];
    refresh = (ModalRoute.of(context)!.settings.arguments as Map)['refresh'];
    super.didChangeDependencies();
    provider = ref.watch(questionViewModelProvider.notifier);
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
                            fromWhere: 'QuestionPage',
                            snapshot: snapshot,
                            token: token,
                            provider: provider,
                          ),
                        ),

                        // 답변 내용
                        for (int answerIndex = 0; answerIndex < snapshot.data!["answerDtos"].length; answerIndex++)
                          AnswerBody(
                            fromWhere: 'QuestionPage',
                            token: token,
                            snapshot: snapshot,
                            answerIndex: answerIndex,
                            provider: provider,
                          ),
                      ],
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
