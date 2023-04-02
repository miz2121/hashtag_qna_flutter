import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/create/component/add_hashtag_button.dart';
import 'package:hashtag_qna_flutter/app/ui/create/create_second/fragment/selected_hashtags.dart';
import 'package:hashtag_qna_flutter/app/ui/create/create_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
import 'package:sizer/sizer.dart';

class CreateSecondPage extends ConsumerStatefulWidget {
  const CreateSecondPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateSecondPage> createState() => CreateSecondPageState();
}

class CreateSecondPageState extends ConsumerState<CreateSecondPage> {
  final List<Widget> createdFormLists = [];
  final List<String> createdHashtagNameList = [];
  final formKey = GlobalKey<FormState>();
  List<dynamic> hashtagNames = [];
  List<dynamic> hashtagNamesList = [];
  String token = '';
  late CreateViewModel provider;

  @override
  void initState() {
    provider = ref.read(createViewModelProvider.notifier);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    hashtagNames = (ModalRoute.of(context)!.settings.arguments as Map)['hashtagNames'].toList();
    token = (ModalRoute.of(context)!.settings.arguments as Map)['token'];
    hashtagNamesList = hashtagNames.toList();
    provider = ref.watch(createViewModelProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(height: 15.w),
                  Text(
                    '새로운 해시태그를\n생성할 수 있습니다.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 100.w / 15,
                      color: Colors.cyan[700],
                    ),
                  ),
                  Container(height: 5.w),
                  Text(
                    '생성을 원하지 않거나\n작성을 완료하셨다면',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 100.w / 15,
                      color: Colors.cyan[700],
                    ),
                  ),
                  Text(
                    '맨 밑의 "다음"을 눌러 주세요.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 100.w / 15,
                      color: Colors.cyan[700],
                    ),
                  ),
                  Container(height: 15.w),
                  hashtagNamesList.isEmpty
                      ? (Container())
                      : Text(
                          '이전 페이지에서\n선택한 해시태그 입니다. ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 100.w / 15,
                            color: Colors.cyan[700],
                          ),
                        ),
                  Container(height: 5.w),

                  // 이전 페이지에서 선택한 해시태그 목록
                  SelectedHashtags(argsList: hashtagNamesList, provider: provider),

                  Container(height: 5.w),

                  // 해시태그 추가하기 버튼
                  AddHashtagButton(
                    createdFormLists: createdFormLists,
                    createdHashtagNameList: createdHashtagNameList,
                    provider: provider,
                  ),

                  Container(height: 5.w),
                  for (Widget textForm in createdFormLists) textForm,
                  Container(height: 5.w),
                  ElevatedButton(
                    onPressed: () {
                      formKey.currentState?.save();
                      logger.d("(hashtagNamesList.length) + (createdHashtagNameList.length): ${(hashtagNamesList.length) + (createdHashtagNameList.length)}");
                      if ((hashtagNamesList.length) + (createdHashtagNameList.length) == 0) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('확인해 주세요.'),
                                content: const Text('해시태그를 하나 이상 지정해 주세요'),
                                actions: [
                                  Center(
                                    child: TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('확인'),
                                    ),
                                  ),
                                ],
                              );
                            });
                      } else {
                        Navigator.pushNamed(
                          context,
                          '/create_third',
                          arguments: {
                            "existHashtag": hashtagNamesList,
                            "newHashtag": createdHashtagNameList,
                            'token': token,
                          },
                        );
                      }
                    },
                    child: const Text("다음"),
                  ),
                  Container(height: 15.w),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
