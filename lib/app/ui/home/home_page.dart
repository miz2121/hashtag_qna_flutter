import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/data/model/memberInfo.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_viewmodel.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? token;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final provider = ref.watch(homeViewModelProvider.notifier);
    _loadUser(provider);
    token = _getToken(provider);
  }

  void _loadUser(HomeViewModel provider) => provider.loadUser();

  String? _getToken(HomeViewModel provider) => provider.token;

  Future<Map<String, dynamic>> _getMemberInfoMaps(
      HomeViewModel provider) async {
    var map = await provider.getMemberInfoMaps();
    return map;
  }

  MemberInfo? _getMemberInfo(HomeViewModel provider) =>
      provider.getMemberInfo();

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double buttonFontSize = displayWidth / 15;
    final provider = ref.watch(homeViewModelProvider.notifier);
    logger.d("_getToken(provider): ${_getToken(provider)}");
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(height: displayWidth / 10),

                // 정보를 가져와 없으면 닉네임을 안띄울거고
                (_getToken(provider) == null)
                    ? InkWell(
                        onTap: () => Navigator.pushNamed(context, '/login'),
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80),
                            border: Border.all(
                              color: Colors.cyan,
                              width: 2,
                            ),
                          ),
                          child: const Text('로그인 정보가 없습니다.'),
                        ),
                      )
                    : // 정보를 가져와 있으면 닉네임을 띄울거임.
                    InkWell(
                        onTap: () {
                          // 해야 할 것. 회원 정보 관련된 페이지로 보내야 함.
                        },
                        child: FutureBuilder<Map<String, dynamic>>(
                            future: _getMemberInfoMaps(provider),
                            builder: (_, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error = ${snapshot.error}');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("Loading");
                              }
                              if (snapshot.data!.isEmpty) {
                                return Container();
                              } else {
                                return Container(
                                  margin: const EdgeInsets.all(5),
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(80),
                                    border: Border.all(
                                      color: Colors.cyan,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                      '${_getMemberInfo(provider)!.nickname}님께서 로그인 중입니다.'),
                                );
                              }
                            }),
                      ),
                TextButton(
                  onPressed: () {
                    _loadUser(provider);
                    if (_getToken(provider) == null) {
                      Navigator.pushNamed(context, '/login');
                    } else {
                      Navigator.pushNamed(context, '/create_first');
                    }
                  },
                  child: Text(
                    '질문을 작성하실 수 있습니다.\n클릭해 보세요.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: buttonFontSize,
                    ),
                  ),
                ),
                Container(height: displayWidth / 10),
                const HomePageFragment(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePageFragment extends ConsumerStatefulWidget {
  const HomePageFragment({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePageFragment> createState() => _HomePageFragmentState();
}

class _HomePageFragmentState extends ConsumerState<HomePageFragment> {
  Future<Map<String, dynamic>> _getHomeQuestions(HomeViewModel provider) =>
      provider.getHomeQuestions();

  Future<void> _loadUser(HomeViewModel provider) async =>
      await provider.loadUser();

  void _clearPref(HomeViewModel provider) => provider.clearPref();

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(homeViewModelProvider.notifier);
    List<int> hashtagColorList = [100, 200, 300];

    return FutureBuilder<Map<String, dynamic>>(
      future: _getHomeQuestions(provider),
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
                          //
                          //
                          // boards
                          ListTile(
                            title: Text(
                              snapshot.data!['questionListDtos'][index]
                                  ['title'],
                              style: Theme.of(context).textTheme.bodyLarge!,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              DateFormat('yy년 mm월 dd일').format(DateTime.parse(
                                  snapshot.data!['questionListDtos'][index]
                                      ['date'])),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.grey[700]),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "상태: ${snapshot.data!['questionListDtos'][index]['questionStatus']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.grey[700]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "답변 수: ${snapshot.data!['questionListDtos'][index]['answerCount']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.grey[700]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
                            child: Text(
                              snapshot.data!['questionListDtos'][index]
                                  ['writer'],
                              style: Theme.of(context).textTheme.bodyMedium!,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      await _loadUser(provider);
                      if (!mounted) return;
                      if (provider.token == null) {
                        Navigator.pushNamed(context, '/login');
                      } else {
                        logger.d(
                            "Entering the question page, token is: ${provider.token}");
                        Navigator.pushNamed(context, '/question', arguments: {
                          'id': snapshot.data!['questionListDtos'][index]['id']
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
                  await _loadUser(provider);
                  if (provider.token == null) {
                    // 해야 할 것. 토큰에 따라 다른 동작
                  } else {
                    // 해야 할 것. 토큰에 따라 다른 동작
                  }
                },
                child: const Text('>>질문글 더 보기'),
              ),
              Container(height: 30),
              //
              //
              // hashtags
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                // shrinkWrap: true,
                // itemCount: snapshot.data!['hashtagDtos'].length,
                // itemBuilder: (context, index) {
                //   return
                children: [
                  for (int index = 0;
                      index < snapshot.data!['hashtagDtos'].length;
                      index++)
                    InkWell(
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          color: Colors.cyan[hashtagColorList[index % 3]],
                          borderRadius: BorderRadius.circular(80),
                          border: Border.all(
                            color: Colors.cyan,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          "# ${snapshot.data!['hashtagDtos'][index]['hashtagName']}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.blueGrey[700]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      onTap: () async {
                        await _loadUser(provider);
                        if (!mounted) return;
                        if (provider.token == null) {
                          Navigator.pushNamed(context, '/login');
                        } else {
                          Navigator.pushNamed(context, '/questions_by_hashtag');
                        }
                      },
                    ),
                ],
              ),
              Container(
                height: 30,
              ),
              // logout button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/join');
                },
                child: const Text('회원가입 하실 수 있습니다.'),
              ),
              Container(height: 10),
              // logout button
              ElevatedButton(
                onPressed: () {
                  // 이미 로그아웃 된 상태라면
                  if (provider.token == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("로그아웃 상태입니다."),
                      ),
                    );
                  } else {
                    // logout
                    setState(() {
                      _clearPref(provider);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("로그아웃 되었습니다."),
                        ),
                      );
                    });
                  }
                },
                child: const Text('로그아웃 하실 수 있습니다.'),
              ),
              Container(height: 10),
              ElevatedButton(
                onPressed: () {
                  // 이미 로그아웃 된 상태라면
                  if (provider.token == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("로그아웃 상태입니다."),
                      ),
                    );
                  } else {
                    // logout
                    _clearPref(provider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("계정이 비활성화 되었습니다."),
                      ),
                    );
                    setState(() {
                      // 해야 할 것. 비활성화 기능 넣어야 함.
                    });
                  }
                },
                child: const Text('회원 비활성화...하실 수도 있습니다.'),
              ),
            ],
          );
        }
      },
    );
  }
}
