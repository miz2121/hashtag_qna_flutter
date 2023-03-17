import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_page.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_viewmodel.dart';

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
  void _clearPref() => widget.provider.clearPref();

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
            widget.parent?.setState(() {
              if (widget.token == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("로그아웃 상태입니다."),
                  ),
                );
              } else {
                // logout
                _clearPref();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("로그아웃 되었습니다."),
                  ),
                );
              }
            });
          },
          child: const Text('로그아웃 하실 수 있습니다.'),
        ),

        // 회원 비활성화 버튼
        Container(height: 10),
        ElevatedButton(
          onPressed: () {
            // 이미 로그아웃 된 상태라면
            if (widget.token == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("로그아웃 상태입니다."),
                ),
              );
            } else {
              // logout
              // _clearPref(widget.provider);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("계정이 비활성화 되었습니다."),
                ),
              );
              widget.parent?.setState(() {
                // 해야 할 것. 비활성화 기능 넣어야 함.
              });
            }
          },
          child: const Text('회원 비활성화...하실 수도 있습니다.'),
        ),
      ],
    );
  }
}
