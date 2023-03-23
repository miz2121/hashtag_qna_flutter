import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/home/fragment/bottom_buttons.dart';
import 'package:hashtag_qna_flutter/app/ui/home/fragment/hashtags.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_page.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_viewmodel.dart';
import 'package:intl/intl.dart';
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
        } else {
          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!['questionListDtos'].length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // boards
                          ListTile(
                            title: Text(
                              snapshot.data!['questionListDtos'][index]['title'],
                              style: Theme.of(context).textTheme.bodyLarge!,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              DateFormat('yy년 MM월 dd일 a:h시 mm분').format(DateTime.parse(snapshot.data!['questionListDtos'][index]['date'])),
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[700]),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "상태: ${snapshot.data!['questionListDtos'][index]['questionStatus']}",
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[700]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "답변 수: ${snapshot.data!['questionListDtos'][index]['answerCount']}",
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[700]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
                            child: Text(
                              snapshot.data!['questionListDtos'][index]['writer'],
                              style: Theme.of(context).textTheme.bodyMedium!,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      if (!mounted) return;
                      if (widget.token == null) {
                        Navigator.pushNamed(context, '/login');
                      } else {
                        // logger.d("Entering the question page, token is: ${widget.token}");
                        Navigator.pushNamed(context, '/question', arguments: {
                          'id': snapshot.data!['questionListDtos'][index]['id'],
                          'token': widget.token,
                          'previous': 'homePage',
                        });
                      }
                    },
                  );
                },
              ),
              //
              // boards
              //
              TextButton(
                onPressed: () async {
                  // 해야 할 것. 전체 질문글 목록 받아와야 함.
                  // await _loadUser(provider);
                  if (widget.token == null) {
                    // 해야 할 것. 토큰에 따라 다른 동작
                  } else {
                    // 해야 할 것. 토큰에 따라 다른 동작
                  }
                },
                child: const Text('>>질문글 더 보기'),
              ),

              // hashtags
              widget.token == null
                  ? Hashtags(
                      provider: widget.provider,
                      snapshot: snapshot,
                    )
                  : Hashtags(
                      provider: widget.provider,
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
        }
      },
    );
  }
}
