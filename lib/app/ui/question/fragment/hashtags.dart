import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/question/component/hashtag_snapshot.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';

class Hashtags extends StatelessWidget {
  const Hashtags({
    super.key,
    required this.provider,
    required this.snapshot,
    this.token,
  });

  final QuestionViewModel provider;
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
              provider: provider,
              index: index,
              snapshot: snapshot,
            ),
            onTap: () {
              if (token == null) {
                Navigator.pushNamed(context, '/login');
              } else {
                Navigator.pushNamed(
                  context,
                  '/question_list',
                  arguments: {
                    'token': token,
                    'titleText': '전체 질문을 보여드립니다.',
                    'currentPage': 1,
                    'operation': 'pagination',
                    'selectedType': '',
                    'searchText': '',
                    'hashtag': '',
                  },
                );
              }
            },
          ),
      ],
    );
  }
}
