import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/create/create_viewmodel.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class CreateFirstPage extends ConsumerStatefulWidget {
  const CreateFirstPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateFirstPage> createState() => _CreateFirstPageState();
}

class _CreateFirstPageState extends ConsumerState<CreateFirstPage> {
  Set<String> hashtagNames = {};

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double buttonFontSize = displayWidth / 15;
    final provider = ref.watch(createViewModelProvider.notifier);

    void checkHashtagNamesEmpty(snapshot) {
      if (provider.isHashtagChecked.isNotEmpty) {
        for (int i = 0; i < provider.isHashtagChecked.length; i++) {
          if (provider.isHashtagChecked[i] == true) {
            hashtagNames.add(snapshot.data![i]['hashtagName']);
          }
        }
      }
      // logger.d("hashtagNames: $hashtagNames");
    }

    void cancelSelectAll(CreateViewModel provider) {
      for (int i = 0; i < provider.isHashtagChecked.length; i++) {
        provider.isHashtagChecked[i] = false;
      }
      hashtagNames.clear();
      logger.d(
          "hashtagNames: $hashtagNames, isHashtagChecked: ${provider.isHashtagChecked}");
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '등록된 해시태그를\n전부 보여드립니다.\n\n새로 작성할 글에\n해당하는 해시태그가 있다면\n선택해 주세요.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: buttonFontSize,
                    color: Colors.cyan[700],
                  ),
                ),
                Container(height: 15),
                ElevatedButton(
                  onPressed: () => setState(() {
                    cancelSelectAll(provider);
                  }),
                  child: const Text('해시태그 선택을 전부 취소하고 싶다면 눌러주세요.'),
                ),
                Container(height: 15),
                FutureBuilder<List<dynamic>>(
                  future: provider.getHashtags(),
                  builder: (_, snapshot) {
                    checkHashtagNamesEmpty(snapshot);
                    if (snapshot.hasError) {
                      return Text('Error = ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }
                    if (snapshot.data!.isEmpty) {
                      return Container();
                    } else {
                      logger
                          .d("isHashtagChecked: ${provider.isHashtagChecked}");
                      return Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        children: [
                          for (int index = 0;
                              index < snapshot.data!.length;
                              index++)
                            InkWell(
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                decoration: BoxDecoration(
                                  color:
                                      Colors.cyan[provider.hashtagColorList[index % 3]],
                                  borderRadius: BorderRadius.circular(80),
                                  border: Border.all(
                                    color: Colors.cyan,
                                    width: 2,
                                  ),
                                ),
                                child: (provider.isHashtagChecked.isEmpty)
                                    ? (Text(
                                        " # ${snapshot.data![index]['hashtagName']}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                color: Colors.blueGrey[700]),
                                        overflow: TextOverflow.ellipsis,
                                      ))
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          provider.isHashtagChecked[index] ==
                                                  false
                                              ? Text(
                                                  " # ${snapshot.data![index]['hashtagName']}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          color: Colors
                                                              .blueGrey[700]),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              : Row(
                                                  children: [
                                                    Text(
                                                      " # ${snapshot.data![index]['hashtagName']} ",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                              color: Colors
                                                                      .blueGrey[
                                                                  700]),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const Icon(
                                                      Icons.done,
                                                      color:
                                                          Colors.orangeAccent,
                                                      size: 50,
                                                    )
                                                  ],
                                                ),
                                        ],
                                      ),
                              ),
                              onTap: () {
                                setState(() {
                                  String name =
                                      snapshot.data![index]['hashtagName'];
                                  if (hashtagNames.contains(name)) {
                                    hashtagNames.remove(name);
                                  } else {
                                    hashtagNames.add(name);
                                  }
                                  logger.d(
                                      "index: $index, hashtagNames: $hashtagNames");

                                  if (provider.isHashtagChecked.isEmpty) {
                                    provider.isHashtagChecked = List.filled(
                                        snapshot.data!.length, false);
                                  }
                                  provider.isHashtagChecked[index] =
                                      !provider.isHashtagChecked[index];
                                });
                              },
                            ),
                        ],
                      );
                    }
                  },
                ),
                Container(height: 15),
                Text(
                  '등록할 해시태그가 없거나\n선택을 완료하셨으면\n"다음" 버튼을 눌러주세요',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: buttonFontSize,
                    color: Colors.cyan[700],
                  ),
                ),
                Container(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/create_second',
                        arguments: hashtagNames);
                  },
                  child: const Text("다음"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
