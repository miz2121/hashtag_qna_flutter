import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/info/component/info_component.dart';
import 'package:sizer/sizer.dart';

class InfoBody extends StatelessWidget {
  const InfoBody({
    super.key,
    required this.snapshot,
  });

  final AsyncSnapshot<Map<String, dynamic>> snapshot;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InfoComponent(
          snapshot: snapshot,
          information: "닉네임",
        ),
        Container(height: 5.w),
        InfoComponent(
          snapshot: snapshot,
          information: "이메일",
        ),
        Container(height: 5.w),
        InfoComponent(
          snapshot: snapshot,
          information: "생성한 질문 수",
        ),
        Container(height: 5.w),
        InfoComponent(
          snapshot: snapshot,
          information: "생성한 답변 수",
        ),
        Container(height: 5.w),
        InfoComponent(
          snapshot: snapshot,
          information: "생성한 댓글 수",
        ),
        Container(height: 5.w),
        InfoComponent(
          snapshot: snapshot,
          information: "생성한 해시태그 수",
        ),
      ],
    );
  }
}
