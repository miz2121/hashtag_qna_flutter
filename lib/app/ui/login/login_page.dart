import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/login/login_viewmodel.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  SharedPreferences? prefs;
  String? token;

  Future<Map<String, String>?> _postRequestLogin(LoginViewModel provider) async {
    final form = formKey.currentState;
    Map<String, String> map = {};
    if (form!.validate()) {
      form.save();
      map = await provider.postRequestLogin(_email, _password);
      token = map['authorization']?.replaceAll("Bearer ", "");
      _saveToken(provider, token);
    }
    return map;
  }

  void _loadUser(LoginViewModel provider){
    provider.loadUser();
  }

  void _saveToken(LoginViewModel provider, String? token) {
    provider.saveToken(token);
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double buttonFontSize = displayWidth / 15;
    final provider = ref.watch(loginViewModelProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '로그인 페이지 입니다.\n입력해 주세요.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: buttonFontSize,
                      color: Colors.cyan[700],
                    ),
                  ),
                  Container(height: 30),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) =>
                        value!.isEmpty ? 'Email can not be empty' : null,
                    onSaved: (value) => _email = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) =>
                        value!.isEmpty ? 'Password can not be empty' : null,
                    onSaved: (value) => _password = value!,
                  ),
                  Container(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      var headers = await _postRequestLogin(provider);
                      if (!mounted) return;
                      _loadUser(provider);
                      if (headers == null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("확인해 주세요."),
                                content: const Text("로그인 정보가 정확하지 않습니다."),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("확인"),
                                  )
                                ],
                              );
                            });
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("로그인 성공"),
                                content: const Text("홈 화면으로 이동합니다."),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, '/home', (route) => false),
                                    child: const Text("확인"),
                                  )
                                ],
                              );
                            });
                      }
                    },
                    child: const Text('로그인 합니다.'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
