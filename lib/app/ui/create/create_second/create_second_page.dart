import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/create/component/add_hashtag_button.dart';
import 'package:hashtag_qna_flutter/app/ui/create/create_second/fragment/selected_hashtags.dart';
import 'package:hashtag_qna_flutter/app/ui/create/create_viewmodel.dart';

class CreateSecondPage extends ConsumerStatefulWidget {
  const CreateSecondPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateSecondPage> createState() => CreateSecondPageState();
}

class CreateSecondPageState extends ConsumerState<CreateSecondPage> {
  final List<Widget> createdFormLists = [];
  final List<String> createdHashtagNameList = [];
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments as Set;
    var argsList = args.toList();
    final provider = ref.watch(createViewModelProvider.notifier);
    double displayWidth = MediaQuery.of(context).size.width;
    double buttonFontSize = displayWidth / 15;
    double buttonSize = displayWidth / 8;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '새로운 해시태그를\n생성할 수 있습니다.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: buttonFontSize,
                      color: Colors.cyan[700],
                    ),
                  ),
                  Container(height: 30),
                  Text(
                    '생성을 원하지 않거나\n작성을 완료하셨다면',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: buttonFontSize,
                      color: Colors.cyan[700],
                    ),
                  ),
                  Text(
                    '맨 밑의 "다음"을 눌러 주세요.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: buttonFontSize,
                      color: Colors.cyan[700],
                    ),
                  ),
                  Container(height: 30),
                  Text(
                    '이전 페이지에서\n선택한 해시태그 입니다. ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: buttonFontSize,
                      color: Colors.cyan[700],
                    ),
                  ),
                  Container(height: 15),

                  // 이전 페이지에서 선택한 해시태그 목록
                  SelectedHashtags(argsList: argsList, provider: provider),

                  Container(height: 30),

                  // 해시태그 추가하기 버튼
                  AddHashtagButton(
                    buttonFontSize: buttonFontSize,
                    buttonSize: buttonSize,
                    displayWidth: displayWidth,
                    createdFormLists: createdFormLists,
                    createdHashtagNameList: createdHashtagNameList,
                  ),

                  Container(height: 15),
                  for (Widget textForm in createdFormLists) textForm,
                  Container(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      formKey.currentState?.save();
                      Navigator.pushNamed(context, '/create_third', arguments: {"existHashtag": argsList, "newHashtag": createdHashtagNameList});
                    },
                    child: const Text("다음"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
