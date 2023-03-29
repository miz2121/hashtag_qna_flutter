import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/home/component/hashtag_snapshot.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/ui/question_list/question_list_viewmodel.dart';

class Hashtags extends StatelessWidget {
  const Hashtags({
    super.key,
    this.homeViewModelProvider,
    this.questionListViewModelProvider,
    required this.snapshot,
    this.token,
  });

  final HomeViewModel? homeViewModelProvider;
  final QuestionListViewModel? questionListViewModelProvider;
  final AsyncSnapshot<Map<String, dynamic>> snapshot;
  final String? token;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      children: [
        for (int index = 0; index < snapshot.data!['hashtagDtos'].length; index++)
          InkWell(
            child: HashtagSnapshot(
              questionListViewModelProvider: homeViewModelProvider == null ? questionListViewModelProvider : null,
              homeViewModelProvider: questionListViewModelProvider == null ? homeViewModelProvider : null,
              index: index,
              snapshot: snapshot,
            ),
            onTap: () async {
              // await _loadUser(provider);
              if (token == null) {
                Navigator.pushNamed(context, '/login');
              } else {
                Navigator.pushNamed(
                  context,
                  '/question_list',
                  arguments: {'token': token},
                );
              }
            },
          ),
      ],
    );
  }
}
