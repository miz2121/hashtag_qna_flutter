import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_page.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_viewmodel.dart';
import 'package:sizer/sizer.dart';

class BottomButtons extends StatefulWidget {
  const BottomButtons({
    super.key,
    required this.parent,
    required this.provider,
    this.token,
  });

  final HomePageState? parent;
  final HomeViewModel provider;
  final String? token;

  @override
  State<BottomButtons> createState() => _BottomButtonsState();
}

class _BottomButtonsState extends State<BottomButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 회원가입 버튼
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/join');
          },
          child: const Text('회원가입 하실 수 있습니다.'),
        ),

        // 로그아웃 버튼
        ElevatedButton(
          onPressed: () {
            // 이미 로그아웃 된 상태라면
            if (widget.token == null) {
              Navigator.pushNamed(context, '/login');
            } else {
              // logout
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('확인해 주세요.'),
                      content: const Text('로그아웃 하시겠습니까?'),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () async {
                                await widget.provider.clearPref();
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("로그아웃 되었습니다."),
                                  ),
                                );
                                Navigator.of(context).pop();
                                widget.parent?.setState(() {});
                              },
                              child: const Text('확인'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('취소'),
                            ),
                          ],
                        ),
                      ],
                    );
                  });
            }
          },
          child: (widget.token == null) ? const Text('로그인 하실 수 있습니다.') : const Text('로그아웃 하실 수 있습니다.'),
        ),
        Container(height: 5.w),
      ],
    );
  }
}
