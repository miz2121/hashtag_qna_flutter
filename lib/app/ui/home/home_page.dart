import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/data/model/member_info.dart';
import 'package:hashtag_qna_flutter/app/ui/home/fragment/home_body.dart';
import 'package:hashtag_qna_flutter/app/ui/home/fragment/show_nickname.dart';
import 'package:hashtag_qna_flutter/app/ui/home/fragment/upper_text_clickable.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_viewmodel.dart';
import 'package:sizer/sizer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  late HomeViewModel provider;

  Future<String?> _getToken(HomeViewModel provider) async => await provider.token;
  Future<MemberInfo> _loadUser(HomeViewModel provider) async => await provider.loadUser();

  Future<String?> init() async {
    String? token;
    await _loadUser(provider);
    await _getToken(provider).then((value) {
      token = value;
    });
    return token;
  }

  @override
  void initState() {
    super.initState();
    provider = ref.read(homeViewModelProvider.notifier);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = ref.watch(homeViewModelProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: FutureBuilder(
                future: init(),
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
                        Container(height: 100.w / 10),
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
                          snapshot: snapshot,
                          text: '질문을 작성하실 수 있습니다.\n클릭해 보세요.',
                          provider: provider,
                        ),

                        Container(height: 100.w / 10),

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
