import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_viewmodel.dart';
import 'package:sizer/sizer.dart';

class HashtagSnapshot extends StatelessWidget {
  const HashtagSnapshot({
    super.key,
    required this.provider,
    required this.index,
    required this.snapshot,
  });

  final HomeViewModel provider;
  final int index;
  final AsyncSnapshot<Map<String, dynamic>> snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1.w),
      padding: EdgeInsets.fromLTRB(2.w, 1.w, 2.w, 1.w),
      decoration: BoxDecoration(
        color: Colors.cyan[provider.hashtagColorList[index % 3]],
        borderRadius: BorderRadius.circular(80),
        border: Border.all(
          color: Colors.cyan,
          width: 0.5.w,
        ),
      ),
      child: Text(
        "# ${snapshot.data!['hashtagDtos'][index]['hashtagName']}",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.blueGrey[700]),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
