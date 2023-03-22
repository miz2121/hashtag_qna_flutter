import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/join/join_viewmodel.dart';
import 'package:sizer/sizer.dart';

class JoinPage extends ConsumerStatefulWidget {
  const JoinPage({Key? key}) : super(key: key);

  @override
  ConsumerState<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends ConsumerState<JoinPage> {
  final formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _nickname = '';
  late JoinViewModel provider;

  bool _validate() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("양식을 전부 채워 주세요."),
        ),
      );
      return false;
    }
  }

  void _join(JoinViewModel provider) => provider.postJoin(_email, _password, _nickname);

  @override
  void initState() {
    super.initState();
    provider = ref.read(joinViewModelProvider.notifier);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = ref.watch(joinViewModelProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    '회원가입 도와드리겠습니다.\n입력해 주세요.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 100.w / 15,
                      color: Colors.cyan[700],
                    ),
                  ),
                  Container(height: 30.w),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) => value!.isEmpty ? 'Email can not be empty' : null,
                    onSaved: (value) => _email = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) => value!.isEmpty ? 'Password can not be empty' : null,
                    onSaved: (value) => _password = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nickname'),
                    validator: (value) => value!.isEmpty ? 'Nickname can not be empty' : null,
                    onSaved: (value) => _nickname = value!,
                  ),
                  Container(height: 30.w),
                  ElevatedButton(
                    onPressed: () {
                      if (_validate()) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("확인해 주세요."),
                                content: const Text("해당 정보로 회원가입 하시겠습니까?."),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          _join(provider);
                                          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                                        },
                                        child: const Text("확인"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("취소"),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            });
                      }
                    },
                    child: const Text('회원가입 합니다.'),
                  ),
                ]),
              )),
        ),
      ),
    );
  }
}
