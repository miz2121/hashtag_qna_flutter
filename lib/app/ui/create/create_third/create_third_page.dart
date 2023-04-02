import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/create/create_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/component/hashtag.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
import 'package:sizer/sizer.dart';

class CreateThirdPage extends ConsumerStatefulWidget {
  const CreateThirdPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateThirdPage> createState() => _CreateThirdPageState();
}

class _CreateThirdPageState extends ConsumerState<CreateThirdPage> {
  final formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  List<String> existHashtags = [];
  List<String> newHashtags = [];
  List<String> myHashtags = [];
  String token = '';
  late CreateViewModel provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(createViewModelProvider.notifier);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    existHashtags = (ModalRoute.of(context)!.settings.arguments as Map)['existHashtag'];
    newHashtags = (ModalRoute.of(context)!.settings.arguments as Map)['newHashtag'];
    myHashtags = existHashtags + newHashtags;
    token = (ModalRoute.of(context)!.settings.arguments as Map)['token'];
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
                children: [
                  Container(height: 5.w),
                  Text(
                    '제목과 질문을 작성해 주세요.\n아래의 해시태그와 함께\n글이 작성 됩니다.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 100.w / 15,
                      color: Colors.cyan[700],
                    ),
                  ),
                  Container(height: 5.w),
                  Container(
                    width: 100.w * (9 / 10),
                    margin: EdgeInsets.all(1.w),
                    padding: EdgeInsets.fromLTRB(2.w, 1.w, 2.w, 1.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.cyan,
                        width: 1.w,
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
                  Container(height: 10.w),
                  Container(
                    width: 100.w * (9 / 10),
                    margin: EdgeInsets.all(1.w),
                    padding: EdgeInsets.fromLTRB(2.w, 1.w, 2.w, 1.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.cyan,
                        width: 1.w,
                      ),
                    ),
                    child: TextFormField(
                      maxLines: 10,
                      decoration: const InputDecoration(
                        labelText: '질문을 입력해 주세요',
                      ),
                      validator: (value) => value!.isEmpty ? '질문을 입력해 주세요.' : null,
                      onSaved: (value) {
                        _content = value!;
                      },
                    ),
                  ),
                  Container(height: 5.w),
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
                  Container(height: 5.w),
                  ElevatedButton(
                    onPressed: () {
                      formKey.currentState?.save();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("작성을 완료하시겠습니까?"),
                              content: const Text("질문을 등록 합니다."),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        formKey.currentState?.save();
                                        var response = await provider.postWriteQuestion(_title, _content, existHashtags, newHashtags);
                                        if (!mounted) return;
                                        if (response['code'] != null) {
                                          switch (response['code']) {
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
                                              logger.e("Error");
                                              throw Exception("Error");
                                          }
                                        }
                                        if (provider.getPrevious == '/home') {
                                          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                                        } else if (provider.getPrevious == '/question_list') {
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/question_list',
                                            (route) => false,
                                            arguments: {
                                              'token': token,
                                              'titleText': "전체 질문을 보여드립니다.",
                                              'currentPage': 1,
                                              'operation': 'pagination',
                                              'selectedType': '',
                                              'searchText': '',
                                            },
                                          );
                                        }
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
