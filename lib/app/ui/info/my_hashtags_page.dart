import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/info/info_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/fragment/hashtags.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
import 'package:sizer/sizer.dart';

class MyHashtagsPage extends ConsumerStatefulWidget {
  const MyHashtagsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyHashtagsPage> createState() => MyHashtagsPageState();
}

class MyHashtagsPageState extends ConsumerState<MyHashtagsPage> {
  late InfoViewModel provider;
  String token = '';

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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: FutureBuilder<Map<String, dynamic>>(
                future: provider.getMyHashtags(token),
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
                        '작성하신 해시태그를\n모아서 보여드립니다.\n\n\n해시태그를 클릭하여\n해당 해시태그가 붙은 게시글을\n모아서 볼 수 있습니다.\n',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 100.w / 15,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Container(height: 5.w),
                      Hashtags(
                        infoViewModelProvider: provider,
                        snapshot: snapshot,
                        token: token,
                      )
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
