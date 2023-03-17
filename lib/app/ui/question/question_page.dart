import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/answer_body.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/question_body.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';

class QuestionPage extends ConsumerStatefulWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends ConsumerState<QuestionPage> {
  late GlobalKey<FormState> formKey;
  double displayWidth = 0;
  double buttonFontSize = 0;
  int id = 0;
  String token = '';
  late QuestionViewModel provider;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    formKey = GlobalKey<FormState>();
    displayWidth = MediaQuery.of(context).size.width;
    buttonFontSize = displayWidth / 15;
    id = (ModalRoute.of(context)!.settings.arguments as Map)['id'];
    token = (ModalRoute.of(context)!.settings.arguments as Map)['token'];
    provider = ref.watch(questionViewModelProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
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
                            // 질문 내용
                            child: QuestionBody(
                              snapshot: snapshot,
                              buttonFontSize: buttonFontSize,
                              displayWidth: displayWidth,
                              formKey: formKey,
                              token: token,
                              provider: provider,
                            ),
                          ),
                          Container(height: 15),

                          // 답변 내용
                          for (int i = 0; i < snapshot.data!["answerDtos"].length; i++)
                            AnswerBody(
                              snapshot: snapshot,
                              displayWidth: displayWidth,
                              buttonFontSize: buttonFontSize,
                              i: i,
                            ),
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
