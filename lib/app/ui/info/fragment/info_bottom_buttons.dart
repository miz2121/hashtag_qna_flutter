import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/info/component/inactive_button.dart';
import 'package:hashtag_qna_flutter/app/ui/info/component/info_nickname_edit_button.dart';
import 'package:hashtag_qna_flutter/app/ui/info/info_viewmodel.dart';
import 'package:sizer/sizer.dart';

class InfoBottomButtons extends StatelessWidget {
  const InfoBottomButtons({
    super.key,
    required this.provider,
    required this.token,
    required this.snapshot,
  });

  final InfoViewModel provider;
  final String token;
  final AsyncSnapshot<Map<String, dynamic>> snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 80.w,
          child: InfoNicknameEditButton(
            provider: provider,
            token: token,
            oldNickname: snapshot.data!['nickname'],
          ),
        ),
        SizedBox(
          width: 80.w,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/my_hashtags',
              arguments: {'token': token},
            ),
            child: const Text('내가 작성한 해시태그 모아 보기'),
          ),
        ),
        SizedBox(
          width: 80.w,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/question_list',
              arguments: {
                'token': token,
                'titleText': '작성하신 질문글을\n모아서 보여드립니다.',
                'currentPage': 1,
                'operation': 'myQuestions',
                'selectedType': '',
                'searchText': '',
                'hashtag': '',
              },
            ),
            child: const Text('내가 작성한 질문글 모아 보기'),
          ),
        ),
        SizedBox(
          width: 80.w,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/question_list',
              arguments: {
                'token': token,
                'titleText': '작성하신 답변이 담긴 질문글을\n모아서 보여드립니다.',
                'currentPage': 1,
                'operation': 'myAnswers',
                'selectedType': '',
                'searchText': '',
                'hashtag': '',
              },
            ),
            child: const Text('내가 작성한 답변이 담긴 질문글 모아 보기'),
          ),
        ),
        SizedBox(
          width: 80.w,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/question_list',
              arguments: {
                'token': token,
                'titleText': '작성하신 댓글이 담긴 질문글을\n모아서 보여드립니다.',
                'currentPage': 1,
                'operation': 'myComments',
                'selectedType': '',
                'searchText': '',
                'hashtag': '',
              },
            ),
            child: const Text('내가 작성한 댓글이 담긴 질문글 모아 보기'),
          ),
        ),
        SizedBox(
          width: 80.w,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/question_list',
              arguments: {
                'token': token,
                'titleText': '작성하신 해시태그가 담긴 질문글을\n모아서 보여드립니다.',
                'currentPage': 1,
                'operation': 'myHashtags',
                'selectedType': '',
                'searchText': '',
                'hashtag': '',
              },
            ),
            child: const Text('내가 작성한 해시태그가 담긴 질문글 모아 보기'),
          ),
        ),
        Container(height: 5.w),
        InactiveButton(
          provider: provider,
          token: token,
        ),
        Container(height: 10.w),
      ],
    );
  }
}
