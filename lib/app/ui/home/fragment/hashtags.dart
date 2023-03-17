import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/home/component/hashtag_snapshot.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_viewmodel.dart';

class Hashtags extends StatelessWidget {
  const Hashtags({
    super.key,
    required this.provider,
    required this.snapshot,
    this.token,
  });

  final HomeViewModel provider;
  final AsyncSnapshot<Map<String, dynamic>> snapshot;
  final String? token;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      // shrinkWrap: true,
      // itemCount: snapshot.data!['hashtagDtos'].length,
      // itemBuilder: (context, index) {
      //   return
      children: [
        for (int index = 0; index < snapshot.data!['hashtagDtos'].length; index++)
          InkWell(
            child: HashtagSnapshot(
              provider: provider,
              index: index,
              snapshot: snapshot,
            ),
            onTap: () async {
              // await _loadUser(provider);
              if (token == null) {
                Navigator.pushNamed(context, '/login');
              } else {
                Navigator.pushNamed(context, '/questions_by_hashtag');
              }
            },
          ),
      ],
    );
  }
}
