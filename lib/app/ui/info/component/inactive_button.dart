import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_page.dart';
import 'package:hashtag_qna_flutter/app/ui/info/info_viewmodel.dart';

class InactiveButton extends StatefulWidget {
  const InactiveButton({
    super.key,
    required this.provider,
    required this.token,
  });

  final InfoViewModel provider;
  final String? token;

  @override
  State<InactiveButton> createState() => _InactiveButtonState();
}

class _InactiveButtonState extends State<InactiveButton> {
  @override
  Widget build(BuildContext context) {
    HomePageState? parent = context.findAncestorStateOfType<HomePageState>();
// 회원 비활성화 버튼
    return ElevatedButton(
      onPressed: () {
        // 이미 로그아웃 된 상태라면
        if (widget.token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("로그인 정보가 없습니다."),
            ),
          );
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('확인해 주세요.'),
                  content: const Text('되돌릴 수 없습니다.\n비활성화 회원이 되시겠습니까?'),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () async {
                            await widget.provider.clearPref();
                            await widget.provider.putMemberInactive((widget.token)!);
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("비활성화 회원이 되었습니다.\n홈 화면으로 이동합니다."),
                              ),
                            );
                            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                            parent?.setState(() {});
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
      child: const Text('회원 비활성화!! 하실 수도 있습니다.'),
    );
  }
}
