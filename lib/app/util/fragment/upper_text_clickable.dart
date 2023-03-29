import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class UpperTextClikable extends StatelessWidget {
  const UpperTextClikable({
    super.key,
    required this.token,
  });

  final String? token;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (token == null) {
          Navigator.pushNamed(context, '/login');
        } else {
          Navigator.pushNamed(context, '/create_first');
        }
      },
      child: Text(
        '질문을 작성하실 수 있습니다.\n클릭해 보세요.',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 100.w / 15,
        ),
      ),
    );
  }
}
