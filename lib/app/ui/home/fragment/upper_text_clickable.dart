import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
import 'package:sizer/sizer.dart';

class UpperTextClikable extends StatelessWidget {
  const UpperTextClikable({
    super.key,
    required this.snapshot,
    required this.text,
    required this.provider,
  });

  final AsyncSnapshot<String?> snapshot;
  final String text;
  final HomeViewModel provider;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        logger.d("test");
        if (snapshot.data == null) {
          Navigator.pushNamed(context, '/login');
        } else {
          Navigator.pushNamed(context, '/create_first');
        }
      },
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 100.w / 15,
        ),
      ),
    );
  }
}
