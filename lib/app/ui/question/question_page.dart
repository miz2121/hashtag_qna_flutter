import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/answer_body.dart';
import 'package:hashtag_qna_flutter/app/ui/question/fragment/question_body.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
import 'package:sizer/sizer.dart';

class QuestionPage extends ConsumerStatefulWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<QuestionPage> createState() => QuestionPageState();
}

class QuestionPageState extends ConsumerState<QuestionPage> {
  int id = 0;
  String token = '';
  String previous = ''; // "/home, /question_list"
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          switch (provider.previous) {
            case "/home":
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              break;
            case "/question_list":
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/question_list',
                (route) => false,
                arguments: {
                  'token': token,
                  'titleText': '전체 질문을 보여드립니다.',
                  'currentPage': 1,
                  'operation': 'pagination',
                  'selectedType': '',
                  'searchText': '',
                },
              );
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
                  }
                  if (snapshot.data!['code'] != null) {
                    switch (snapshot.data!['code']) {
                      case "INVALID_PARAMETER":
                        exceptionShowDialog(context, "INVALID_PARAMETER");
                        break;
                      case "NOT_MEMBER_OR_INACTIVE":
                        exceptionShowDialog(context, "회원이 아니거나 비활성화된 회원입니다.");
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

                        Container(height: 5.w),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
