import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/ui/info/info_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/ui/question_list/question_list_viewmodel.dart';
import 'package:sizer/sizer.dart';

class HashtagSnapshot extends StatelessWidget {
  const HashtagSnapshot({
    super.key,
    this.homeViewModelProvider,
    this.questionListViewModelProvider,
    this.infoViewModelProvider,
    required this.index,
    required this.snapshot,
  });

  final HomeViewModel? homeViewModelProvider;
  final QuestionListViewModel? questionListViewModelProvider;
  final InfoViewModel? infoViewModelProvider;
  final int index;
  final AsyncSnapshot<Map<String, dynamic>> snapshot;

  @override
  Widget build(BuildContext context) {
    Color? hashtagColor;
    if (homeViewModelProvider != null) {
      hashtagColor = Colors.cyan[homeViewModelProvider!.hashtagColorList[index % 3]];
    } else if (questionListViewModelProvider != null) {
      hashtagColor = Colors.cyan[questionListViewModelProvider!.hashtagColorList[index % 3]];
    } else if (infoViewModelProvider != null) {
      hashtagColor = Colors.cyan[infoViewModelProvider!.hashtagColorList[index % 3]];
    } else {
      hashtagColor = Colors.cyan;
    }
    return Container(
      margin: EdgeInsets.all(1.w),
      padding: EdgeInsets.fromLTRB(2.w, 1.w, 2.w, 1.w),
      decoration: BoxDecoration(
        color: hashtagColor,
        borderRadius: BorderRadius.circular(80),
        border: Border.all(
          color: Colors.cyan,
          width: 0.5.w,
        ),
      ),
      child: homeViewModelProvider != null
          ? Text(
              "# ${snapshot.data!['homeHashtagListDto']['hashtagListDtoList'][index]['hashtagName']}",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.blueGrey[700]),
              overflow: TextOverflow.ellipsis,
            )
          : questionListViewModelProvider != null
              ? Text(
                  "# ${snapshot.data!['hashtagDtos'][index]['hashtagName']}",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.blueGrey[700]),
                  overflow: TextOverflow.ellipsis,
                )
              : infoViewModelProvider != null
                  ? Text(
                      "# ${snapshot.data!['hashtagDtoList'][index]['hashtagName']}",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.blueGrey[700]),
                      overflow: TextOverflow.ellipsis,
                    )
                  : Container(),
    );
  }
}
