import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/create/create_first/fragment/all_hashtags.dart';
import 'package:hashtag_qna_flutter/app/ui/create/create_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
import 'package:sizer/sizer.dart';

class CreateFirstPage extends ConsumerStatefulWidget {
  const CreateFirstPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateFirstPage> createState() => _CreateFirstPageState();
}

class _CreateFirstPageState extends ConsumerState<CreateFirstPage> {
  Set<String> hashtagNames = {};
  late CreateViewModel provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(createViewModelProvider.notifier);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = ref.watch(createViewModelProvider.notifier);
  }

  void cancelSelectAll(CreateViewModel provider) {
    for (int i = 0; i < provider.isHashtagChecked.length; i++) {
      provider.isHashtagChecked[i] = false;
    }
    hashtagNames.clear();
    logger.d("hashtagNames: $hashtagNames, isHashtagChecked: ${provider.isHashtagChecked}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(height: 15.w),
                Text(
                  '등록된 해시태그를\n전부 보여드립니다.\n\n새로 작성할 글에\n해당하는 해시태그가 있다면\n선택해 주세요.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 100.w / 15,
                    color: Colors.cyan[700],
                  ),
                ),
                Container(height: 5.w),
                ElevatedButton(
                  onPressed: () => setState(() {
                    cancelSelectAll(provider);
                  }),
                  child: const Text('해시태그 선택을 전부 취소하고 싶다면 눌러주세요.'),
                ),
                Container(height: 5.w),

                // 해야 할 것. 해시태그 접어서 간략하게 보기
                // 가운데에 선택 가능한 모든 해시태그 보여줌
                AllHashtags(provider: provider, hashtagNames: hashtagNames),
                Container(height: 15.w),
                Text(
                  '등록할 해시태그가 없거나\n선택을 완료하셨으면\n"다음" 버튼을 눌러주세요',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 100.w / 15,
                    color: Colors.cyan[700],
                  ),
                ),
                Container(height: 5.w),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/create_second', arguments: hashtagNames);
                  },
                  child: const Text("다음"),
                ),
                Container(height: 5.w),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
