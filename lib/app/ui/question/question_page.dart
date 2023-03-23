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
  String previous = ''; // "/home, /questions"
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
    previous = (ModalRoute.of(context)!.settings.arguments as Map)['previous'];
    super.didChangeDependencies();
    provider = ref.watch(questionViewModelProvider.notifier);
    provider.setPrevious(previous);
  }

  // Future<bool> _movePage(BuildContext context) {
  //   Future<bool?> result;

  //   switch (provider.previous) {
  //     case "homePage":
  //       return Navigator.pushNamedAndRemoveUntil<bool>(context, '/home', (route) => false) as Future<bool>;
  //     case "questionsPage":
  //       return Navigator.pushNamedAndRemoveUntil<bool>(context, '/questions', (route) => false) as Future<bool>;
  //     default:
  //       setState(() {});
  //       return false as Future<bool>;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          switch (provider.previous) {
            case "homePage":
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              break;
            case "questionsPage":
              Navigator.pushNamedAndRemoveUntil(context, '/questions', (route) => false);
              break;
          }
          return false;
        },
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
      ),
    );
  }
}
