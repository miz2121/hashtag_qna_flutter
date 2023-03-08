
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/data/model/home.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_viewmodel.dart';
import 'package:logger/logger.dart';


var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class HomePages extends ConsumerWidget {
  const HomePages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(homeViewModelProvider.notifier);

    return Center(
      child: FutureBuilder<Map<String, dynamic>>(
        future: provider.homeRepository.getHomeQuestions(),
        builder: (_, snapshot) {
          if (snapshot.hasError) return Text('Error = ${snapshot.error}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return Column(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('질문 작성하기'),
              ),
              for(var t in snapshot.data!['questionListDtos']) Text(t.toString()),
              for(var t in snapshot.data!['hashtagDtos']) Text(t.toString()),
            ],
          );
        }
      ),
    );
  }
}
