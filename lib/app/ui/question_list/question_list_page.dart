import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/create/create_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/ui/question_list/component/pagination.dart';
import 'package:hashtag_qna_flutter/app/ui/question_list/question_list_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/fragment/question_list.dart';
import 'package:hashtag_qna_flutter/app/util/fragment/upper_text_clickable.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
import 'package:sizer/sizer.dart';

class QuestionListPage extends ConsumerStatefulWidget {
  const QuestionListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<QuestionListPage> createState() => QuestionListPageState();
}

class QuestionListPageState extends ConsumerState<QuestionListPage> {
  late Future<Map<String, dynamic>> init;
  late QuestionListViewModel provider;
  String token = '';
  String titleText = ''; // "전체 질문을 보여드립니다."
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    provider = ref.read(questionListViewModelProvider.notifier);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    token = (ModalRoute.of(context)!.settings.arguments as Map)['token'];
    titleText = (ModalRoute.of(context)!.settings.arguments as Map)['titleText'];
    currentPage = (ModalRoute.of(context)!.settings.arguments as Map)['currentPage'];
    provider = ref.watch(questionListViewModelProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: provider.getViewQuestionsWithPagination(token, currentPage),
            builder: (BuildContext _, snapshot) {
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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(height: 10.w),
                  Text(
                    titleText, // "전체 질문을 보여드립니다."
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 100.w / 15,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Container(height: 10.w),
                  CreateQuestionTextButton(
                    token: token,
                    previous: '/question_list',
                  ),
                  Container(height: 10.w),
                  QuestionList(
                    previous: '/question_list',
                    snapshot: snapshot,
                    token: token,
                  ),
                  Pagination(
                    totalPages: snapshot.data!["totalPages"],
                    currentPage: currentPage,
                    token: token,
                  ),
                  Container(height: 10.w),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                    },
                    child: const Text('홈으로 가기'),
                  ),
                  Container(height: 10.w),
                  ElevatedButton(
                    onPressed: () async {
                      CreateViewModel p = ref.watch(createViewModelProvider.notifier);
                      for (int i = snapshot.data!['totalElements']; i < snapshot.data!['totalElements'] + 100; i++) {
                        await p.postWriteQuestion('text$i', 'text$i', ['테스트'], []);
                      }
                      setState(() {});
                    },
                    child: const Text('테스트 데이터 100개 삽입'),
                  ),
                  Container(height: 10.w),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
