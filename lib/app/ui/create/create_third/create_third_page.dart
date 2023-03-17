import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/create/create_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/component/hashtag.dart';

class CreateThirdPage extends ConsumerStatefulWidget {
  const CreateThirdPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateThirdPage> createState() => _CreateThirdPageState();
}

class _CreateThirdPageState extends ConsumerState<CreateThirdPage> {
  final formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';

  Future<void> _postWriteQuestion(CreateViewModel provider, String title, String content, List<String> existHashtags, List<String> newHashtags) async {
    await provider.postWriteQuestion(title, content, existHashtags, newHashtags);
  }

  @override
  Widget build(BuildContext context) {
    var existHashtags = (ModalRoute.of(context)!.settings.arguments as Map)['existHashtag'];
    var newHashtags = (ModalRoute.of(context)!.settings.arguments as Map)['newHashtag'];
    List<String> myHashtags = existHashtags + newHashtags;

    final provider = ref.watch(createViewModelProvider.notifier);
    double displayWidth = MediaQuery.of(context).size.width;
    double buttonFontSize = displayWidth / 15;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    '제목과 내용을 작성해 주세요.\n아래의 해시태그와 함께\n글이 작성 됩니다.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: buttonFontSize,
                      color: Colors.cyan[700],
                    ),
                  ),
                  Container(height: 15),
                  Container(
                    width: displayWidth * (9 / 10),
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.cyan,
                        width: 2,
                      ),
                    ),
                    child: TextFormField(
                      // maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: '제목을 입력해 주세요',
                      ),
                      validator: (value) => value!.isEmpty ? '제목을 입력해 주세요.' : null,
                      onSaved: (value) {
                        _title = value!;
                      },
                    ),
                  ),
                  Container(height: 10),
                  Container(
                    width: displayWidth * (9 / 10),
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.cyan,
                        width: 2,
                      ),
                    ),
                    child: TextFormField(
                      maxLines: 10,
                      decoration: const InputDecoration(
                        labelText: '내용을 입력해 주세요',
                      ),
                      validator: (value) => value!.isEmpty ? '내용을 입력해 주세요.' : null,
                      onSaved: (value) {
                        _content = value!;
                      },
                    ),
                  ),
                  Container(height: 15),
                  Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.start,
                    children: [
                      for (int index = 0; index < myHashtags.length; index++)
                        Hashtag(
                          provider: provider,
                          index: index,
                          argsList: myHashtags,
                        )
                    ],
                  ),
                  Container(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      formKey.currentState?.save();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("작성을 완료하시겠습니까?"),
                              content: const Text("포스팅 합니다."),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        formKey.currentState?.save();
                                        await _postWriteQuestion(provider, _title, _content, existHashtags, newHashtags);
                                        if (!mounted) return;
                                        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                                      },
                                      child: const Text("확인"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("취소"),
                                    ),
                                  ],
                                )
                              ],
                            );
                          });
                    },
                    child: const Text("완료"),
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
