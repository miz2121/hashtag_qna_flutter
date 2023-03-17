import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';

class UpperTextClikable extends StatelessWidget {
  const UpperTextClikable({
    super.key,
    required this.buttonFontSize,
    required this.snapshot,
    required this.text,
  });

  final double buttonFontSize;
  final AsyncSnapshot<String?> snapshot;
  final String text;

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
          fontSize: buttonFontSize,
        ),
      ),
    );
  }
}
