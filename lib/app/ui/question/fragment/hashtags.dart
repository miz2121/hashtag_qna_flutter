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
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('확인해 주세요.'),
                        content: Text("선택하신 해시태그 '${snapshot.data!['hashtagDtos'][index]['hashtagName']}'\n(이)가 붙은 질문글을 조회합니다."),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/question_list',
                                    arguments: {
                                      'token': token,
                                      'titleText': "선택한 해시태그: '${snapshot.data!['hashtagDtos'][index]['hashtagName']}'\n과 관련된 모든 질문글 입니다.",
                                      'currentPage': 1,
                                      'operation': 'hashtag',
                                      'selectedType': '',
                                      'searchText': '',
                                      'hashtag': '${snapshot.data!['hashtagDtos'][index]['hashtagName']}',
                                    },
                                  );
                                },
                                child: const Text('확인'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('취소'),
                              ),
                            ],
                          ),
                        ],
                      );
                    });
              }
            },
          ),
      ],
    );
  }
}
