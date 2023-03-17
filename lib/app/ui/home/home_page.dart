import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/data/model/member_info.dart';
import 'package:hashtag_qna_flutter/app/ui/home/fragment/home_body.dart';
import 'package:hashtag_qna_flutter/app/ui/home/fragment/show_nickname.dart';
import 'package:hashtag_qna_flutter/app/ui/home/fragment/upper_text_clickable.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_viewmodel.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  double displayWidth = 0;
  double buttonFontSize = 0;
  late HomeViewModel provider;

  Future<String?> _getToken(HomeViewModel provider) async => await provider.token;
  Future<MemberInfo> _loadUser(HomeViewModel provider) async => await provider.loadUser();

  Future<String?> initial() async {
    String? token;
    provider = ref.watch(homeViewModelProvider.notifier);
    displayWidth = MediaQuery.of(context).size.width;
    buttonFontSize = displayWidth / 15;

    await _loadUser(provider);
    await _getToken(provider).then((value) {
      token = value;
    });
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: FutureBuilder(
                future: initial(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error = ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(height: displayWidth / 10),
                        // 상단 닉네임
                        snapshot.data == null // 토큰이 없으면
                            ? ShowNickname(
                                provider: provider,
                              )
                            : ShowNickname(
                                token: snapshot.data,
                                provider: provider,
                              ),

                        UpperTextClikable(
                          buttonFontSize: buttonFontSize,
                          snapshot: snapshot,
                          text: '질문을 작성하실 수 있습니다.\n클릭해 보세요.',
                        ),

                        Container(height: displayWidth / 10),

                        snapshot.data == null // 토큰이 없으면
                            ? HomeBody(provider: provider)
                            : HomeBody(
                                provider: provider,
                                token: snapshot.data,
                              ),
                      ],
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}
