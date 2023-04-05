import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NoData extends StatelessWidget {
  const NoData({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1.w),
      padding: EdgeInsets.fromLTRB(2.w, 1.w, 2.w, 1.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      width: 60.w,
      height: 40.w,
      child: Center(
        child: Text(
          '데이터가 없습니다.\n새로운 데이터를\n추가해 주세요.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
