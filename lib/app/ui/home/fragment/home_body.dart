import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/home/fragment/bottom_buttons.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_page.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/fragment/hashtags.dart';
import 'package:hashtag_qna_flutter/app/util/fragment/question_list.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
import 'package:sizer/sizer.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({
    super.key,
    required this.provider,
    this.token,
  });

  final HomeViewModel provider;
  final String? token;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  HomePageState? parent;
  Future<Map<String, dynamic>> _getHomeQuestions(HomeViewModel provider) => provider.getHomeQuestions();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    parent = context.findAncestorStateOfType<HomePageState>();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getHomeQuestions(widget.provider),
      builder: (_, snapshot) {
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
            QuestionList(
              snapshot: snapshot,
              token: widget.token,
              previous: '/home',
            ),

            ((snapshot.data!["questionListDtos"].length) != 0)
                ? TextButton(
                    onPressed: () async {
                      if (widget.token == null) {
                        Navigator.pushNamed(context, '/login');
                      } else {
                        Navigator.pushNamed(
                          context,
                          '/question_list',
                          arguments: {
                            'token': widget.token,
                            'titleText': '전체 질문을 보여드립니다.',
                            'currentPage': 1,
                          },
                        );
                      }
                    },
                    child: Text(
                      '>> 질문글 더 보기',
                      style: TextStyle(
                        fontSize: 5.w,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                : Container(),

            Container(height: 10.w),
            // hashtags
            widget.token == null
                ? Hashtags(
                    homeViewModelProvider: widget.provider,
                    snapshot: snapshot,
                  )
                : Hashtags(
                    homeViewModelProvider: widget.provider,
                    snapshot: snapshot,
                    token: widget.token,
                  ),

            Container(height: 10.w),
            widget.token == null
                ? BottomButtons(
                    parent: parent,
                    provider: widget.provider,
                  )
                : BottomButtons(
                    parent: parent,
                    token: widget.token,
                    provider: widget.provider,
                  ),
          ],
        );
      },
    );
  }
}
