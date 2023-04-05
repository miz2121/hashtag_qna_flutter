import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/info/fragment/info_body.dart';
import 'package:hashtag_qna_flutter/app/ui/info/fragment/info_bottom_buttons.dart';
import 'package:hashtag_qna_flutter/app/ui/info/info_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
import 'package:sizer/sizer.dart';

class InfoPage extends ConsumerStatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  ConsumerState<InfoPage> createState() => InfoPageState();
}

class InfoPageState extends ConsumerState<InfoPage> {
  String token = '';
  late InfoViewModel provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(infoViewModelProvider.notifier);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    token = (ModalRoute.of(context)!.settings.arguments as Map)['token'];
    provider = ref.watch(infoViewModelProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: FutureBuilder<Map<String, dynamic>>(
                  future: provider.getMemberInfoMaps(token),
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
                        case "NOT_MEMBER_OR_INACTIVE":
                          exceptionShowDialog(context, "회원이 아니거나 비활성화된 회원입니다.");
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
                        Container(height: 15.w),
                        Text(
                          '회원 정보를 보여드립니다.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 100.w / 15,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Container(height: 10.w),
                        InfoBody(snapshot: snapshot),
                        Container(height: 5.w),
                        InfoBottomButtons(
                          provider: provider,
                          token: token,
                          snapshot: snapshot,
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
