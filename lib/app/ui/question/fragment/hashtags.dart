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
                Navigator.pushNamed(context, '/questions');
              }
            },
          ),
      ],
    );
  }
}
