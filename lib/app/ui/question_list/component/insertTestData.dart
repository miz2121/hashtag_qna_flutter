import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/create/create_viewmodel.dart';

class InsertTestData extends ConsumerStatefulWidget {
  const InsertTestData({
    super.key,
    required this.snapshot,
  });

  final AsyncSnapshot<Map<String, dynamic>> snapshot;

  @override
  ConsumerState<InsertTestData> createState() => _InsertTestDataState();
}

class _InsertTestDataState extends ConsumerState<InsertTestData> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('확인해 주세요'),
                content: const Text('데이터가 등록되는 데 시간이 걸립니다.\n화면이 갱신될 때까지 기다려 주세요.'),
                actions: [
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('확인'),
                    ),
                  )
                ],
              );
            });
        CreateViewModel p = ref.watch(createViewModelProvider.notifier);
        for (int i = (widget.snapshot.data!['totalElements']); i < ((widget.snapshot.data!['totalElements']) + 100); i++) {
          await p.postWriteQuestion('테스트$i', '테스트$i', ['테스트'], []);
        }

        setState(() {});
      },
      child: const Text('테스트 데이터 100개 삽입'),
    );
  }
}
