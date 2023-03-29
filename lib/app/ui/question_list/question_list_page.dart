import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/question_list/question_list_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/fragment/question_list.dart';
import 'package:hashtag_qna_flutter/app/util/fragment/upper_text_clickable.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
import 'package:sizer/sizer.dart';

class QuestionListPage extends ConsumerStatefulWidget {
  const QuestionListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<QuestionListPage> createState() => _QuestionListPageState();
}

class _QuestionListPageState extends ConsumerState<QuestionListPage> {
  late QuestionListViewModel provider;
  String token = '';

  @override
  void initState() {
    super.initState();
    provider = ref.read(questionListViewModelProvider.notifier);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    token = (ModalRoute.of(context)!.settings.arguments as Map)['token'];
    provider = ref.watch(questionListViewModelProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: provider.getViewQuestions(token),
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
                children: [
                  Container(height: 10.w),
                  UpperTextClikable(
                    token: token,
                  ),
                  Container(height: 10.w),
                  QuestionList(
                    previous: '/question_list',
                    snapshot: snapshot,
                    token: token,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
