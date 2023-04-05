import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/info/info_page.dart';
import 'package:hashtag_qna_flutter/app/ui/info/info_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';

class InfoNicknameEditButton extends StatefulWidget {
  const InfoNicknameEditButton({
    super.key,
    required this.provider,
    required this.token,
    required this.oldNickname,
  });

  final InfoViewModel provider;
  final String? token;
  final String? oldNickname;

  @override
  State<InfoNicknameEditButton> createState() => _InfoNicknameEditButtonState();
}

class _InfoNicknameEditButtonState extends State<InfoNicknameEditButton> {
  late final GlobalKey<FormState> formKey;
  String _nickname = '';

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    InfoPageState? parent = context.findAncestorStateOfType<InfoPageState>();
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
                return Form(
                  key: formKey,
                  child: AlertDialog(
                    title: const Text('변경할 닉네임을 입력해 주세요.'),
                    content: TextFormField(
                      maxLines: 1,
                      decoration: InputDecoration(labelText: widget.oldNickname ?? 'null'),
                      validator: (value) => value!.isEmpty ? 'nickname can not be empty' : null,
                      onSaved: (value) {
                        _nickname = value!;
                      },
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState?.save();
                                await widget.provider.clearPref();
                                var response = await widget.provider.patchUpdateNickname(widget.token!, _nickname);
                                if (!mounted) return;
                                if (response['code'] != null) {
                                  switch (response['code']) {
                                    case "INVALID_PARAMETER":
                                      exceptionShowDialog(context, "INVALID_PARAMETER");
                                      break;
                                    case "NOT_MEMBER_OR_INACTIVE":
                                      exceptionShowDialog(context, "회원이 아니거나 비활성화된 회원입니다.");
                                      break;
                                    case "RESOURCE_NOT_FOUND":
                                      exceptionShowDialog(context, "RESOURCE_NOT_FOUND");
                                      break;
                                    case "INTERNAL_SERVER_ERROR":
                                      exceptionShowDialog(context, "INTERNAL_SERVER_ERROR");
                                      break;
                                    default:
                                      logger.e("Error");
                                      throw Exception('Error');
                                  }
                                }
                                Navigator.of(context).pop();
                                parent?.setState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("닉네임이 수정되었습니다."),
                                  ),
                                );
                              }
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
                  ),
                );
              });
        }
      },
      child: const Text('닉네임을 변경하실 수 있습니다.'),
    );
  }
}
