import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_viewmodel.dart';

class ShowNickname extends ConsumerStatefulWidget {
  ShowNickname({
    super.key,
    this.token,
    required this.provider,
  });
  String? token;
  final HomeViewModel provider;

  @override
  ConsumerState<ShowNickname> createState() => _ShowNicknameState();
}

class _ShowNicknameState extends ConsumerState<ShowNickname> {
  Future<Map<String, dynamic>> _getMemberInfoMaps(HomeViewModel provider) async {
    Map<String, dynamic> map = {};
    if (widget.token != null) {
      map = await provider.getMemberInfoMaps(widget.token!);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          // 토큰이 없다면 닉네임을 안띄울거고
          (widget.token == null)
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
              : // 토큰이 있다면 닉네임을 띄울거임.
              InkWell(
                  onTap: () {
                    // 해야 할 것. 회원 정보 관련된 페이지로 보내야 함.
                  },
                  child: FutureBuilder<Map<String, dynamic>>(
                      future: _getMemberInfoMaps(widget.provider),
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
                          return Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                              border: Border.all(
                                color: Colors.cyan,
                                width: 2,
                              ),
                            ),
                            child: Text('${snapshot.data!['nickname']}님께서 로그인 중입니다.'),
                          );
                        }
                      }),
                ),
    );
  }
}
