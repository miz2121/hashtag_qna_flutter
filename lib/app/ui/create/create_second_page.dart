import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/data/model/hashtag_dtos.dart';
import 'package:logger/logger.dart';

import 'create_viewmodel.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class CreateSecondPage extends ConsumerStatefulWidget {
  const CreateSecondPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateSecondPage> createState() => _CreateSecondPageState();
}

class _CreateSecondPageState extends ConsumerState<CreateSecondPage> {
  List<Widget> _createdFormLists = [];
  List<String> _createdHashtagNameList = [];
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
                    '생성을 원하지 않거나\n작성을 완료하셨다면\n맨 밑의 "다음"을 눌러 주세요.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: buttonFontSize,
                      color: Colors.cyan[700],
                    ),
                  ),
                  Container(height: 30),
                  Text(
                    '이전 페이지에서\n선택한 해시태그: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: buttonFontSize,
                      color: Colors.cyan[700],
                    ),
                  ),
                  Container(height: 15),
                  Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.start,
                    children: [
                      for (int index = 0; index < argsList.length; index++)
                        Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: Colors
                                .cyan[provider.hashtagColorList[index % 3]],
                            borderRadius: BorderRadius.circular(80),
                            border: Border.all(
                              color: Colors.cyan,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            " # ${argsList[index]}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.blueGrey[700]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                  Container(height: 30),
                  InkWell(
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                        color: Colors.cyan[100],
                        borderRadius: BorderRadius.circular(80),
                        border: Border.all(
                          color: Colors.cyan,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '해시태그 추가하기',
                            style: TextStyle(fontSize: buttonFontSize / 1.3),
                          ),
                          Icon(Icons.add_circle,
                              color: Colors.lightBlue, size: buttonSize),
                        ],
                      ),
                    ),
                    onTap: () {
                      _createdFormLists.add(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: displayWidth * (7 / 10),
                              child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: '해시태그 이름을 입력해 주세요.',
                                  ),
                                  validator: (value) => value!.isEmpty
                                      ? '해시태그 이름을 입력해 주세요.'
                                      : null,
                                  onSaved: (value) {
                                    if (!_createdHashtagNameList
                                        .contains(value)) {
                                      _createdHashtagNameList.add(value!);
                                    }
                                  }),
                            ),
                            InkWell(
                              child: Icon(
                                Icons.delete_forever,
                                color: Colors.lightBlue,
                                size: buttonSize * 0.9,
                              ),
                              onTap: () {
                                _createdFormLists.removeLast();
                                if (_createdFormLists.isEmpty) {
                                  _createdHashtagNameList.clear();
                                }
                                setState(() {
                                });
                              },
                            ),
                          ],
                        ),
                      );
                      logger.d("_createdFormLists: $_createdFormLists");
                      setState(() {});
                    },
                  ),
                  Container(height: 15),
                  for (Widget textForm in _createdFormLists) textForm,
                  Container(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      formKey.currentState?.save();
                      Navigator.pushNamed(context, '/create_third',
                          arguments: {"existHashtag": argsList, "newHashtag": _createdHashtagNameList});
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
