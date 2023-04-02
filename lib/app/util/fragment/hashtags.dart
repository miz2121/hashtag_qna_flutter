import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/home/component/hashtag_snapshot.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/ui/info/info_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/ui/question_list/question_list_viewmodel.dart';

class Hashtags extends StatelessWidget {
  const Hashtags({
    super.key,
    this.homeViewModelProvider,
    this.questionListViewModelProvider,
    this.infoViewModelProvider,
    required this.snapshot,
    this.token,
  });

  final HomeViewModel? homeViewModelProvider;
  final QuestionListViewModel? questionListViewModelProvider;
  final InfoViewModel? infoViewModelProvider;
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
            child: homeViewModelProvider != null
                ? HashtagSnapshot(
                    homeViewModelProvider: homeViewModelProvider,
                    index: index,
                    snapshot: snapshot,
                  )
                : questionListViewModelProvider != null
                    ? HashtagSnapshot(
                        questionListViewModelProvider: questionListViewModelProvider,
                        index: index,
                        snapshot: snapshot,
                      )
                    : infoViewModelProvider != null
                        ? HashtagSnapshot(
                            infoViewModelProvider: infoViewModelProvider,
                            index: index,
                            snapshot: snapshot,
                          )
                        : Container(),
            onTap: () async {
              if (token == null) {
                Navigator.pushNamed(context, '/login');
              } else {
                // 해야 할 것. showDialog띄워서 해당 해시태그가 붙은 질문글을 보겠냐고 물어보고
                // 해시태그별 질문을 보여주자.
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
