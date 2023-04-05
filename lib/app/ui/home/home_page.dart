import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/data/model/member_info.dart';
import 'package:hashtag_qna_flutter/app/ui/home/fragment/home_body.dart';
import 'package:hashtag_qna_flutter/app/ui/home/fragment/show_nickname.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/fragment/upper_text_clickable.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
import 'package:sizer/sizer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> with WidgetsBindingObserver {
  late HomeViewModel provider;

  Future<String?> _getToken(HomeViewModel provider) async => await provider.token;
  Future<MemberInfo> _loadUser(HomeViewModel provider) async => await provider.loadUser();

  Future<String?> init() async {
    String? token;
    await _loadUser(provider);
    await _getToken(provider).then((value) {
      token = value;
    });
    logger.d("token is loaded: $token");
    return token;
  }

  @override
  void initState() {
    super.initState();
    provider = ref.read(homeViewModelProvider.notifier);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = ref.watch(homeViewModelProvider.notifier);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        logger.d('resumed');
        break;
      case AppLifecycleState.inactive:
        logger.d('inactive');
        break;
      case AppLifecycleState.detached:
        setState(() {
          provider.clearPref();
        });
        logger.d('detached');
        break;
      case AppLifecycleState.paused:
        logger.d('paused');
        break;
      default:
        break;
    }
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
                        Container(height: 10.w),
                        // 상단 닉네임
                        snapshot.data == null // 토큰이 없으면
                            ? ShowNickname(
                                provider: provider,
                              )
                            : ShowNickname(
                                token: snapshot.data,
                                provider: provider,
                              ),
                        Container(height: 5.w),
                        Text(
                          "메인 화면 입니다.\n최신 질문 최대 5개를\n보여드립니다.",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 100.w / 15,
                          ),
                        ),
                        Container(height: 5.w),
                        CreateQuestionTextButton(
                          token: snapshot.data,
                          previous: '/home',
                        ),

                        Container(height: 10.w),

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
