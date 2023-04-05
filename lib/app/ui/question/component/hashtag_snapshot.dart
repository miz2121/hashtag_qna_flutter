import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_viewmodel.dart';

class HashtagSnapshot extends StatelessWidget {
  const HashtagSnapshot({
    super.key,
    required this.provider,
    required this.index,
    required this.snapshot,
  });

  final QuestionViewModel provider;
  final int index;
  final AsyncSnapshot<Map<String, dynamic>> snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        color: Colors.cyan[provider.hashtagColorList[index % 3]],
        borderRadius: BorderRadius.circular(80),
        border: Border.all(
          color: Colors.cyan,
          width: 2,
        ),
      ),
      child: Text(
        "# ${snapshot.data!['hashtagDtos'][index]['hashtagName']}",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.blueGrey[700]),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
