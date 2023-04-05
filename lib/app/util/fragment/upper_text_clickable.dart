import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CreateQuestionTextButton extends StatelessWidget {
  const CreateQuestionTextButton({
    super.key,
    required this.token,
    required this.previous,
  });

  final String? token;
  final String previous;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (token == null) {
          Navigator.pushNamed(context, '/login');
        } else {
          Navigator.pushNamed(
            context,
            '/create_first',
            arguments: {
              'token': token,
              'previous': previous,
            },
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.all(1.w),
        child: Text(
          '질문을 작성하실 수 있습니다.\n클릭해 보세요.',
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            fontSize: 5.w,
            // color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
