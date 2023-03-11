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

  void _postRequestLogin(LoginViewModel provider) async {
    prefs = await SharedPreferences.getInstance();
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      Map<String, String> map =
          await provider.loginRepository.postRequestLogin(_email, _password);
      token = map['authorization']?.replaceAll("Bearer ", "");
      // logger.d("token: $token");
      prefs?.setString("token", token!);
    }
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
                    '로그인 하셔야 합니다.\n입력해 주세요.',
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
                  ElevatedButton(
                    onPressed: () {
                      _postRequestLogin(provider);
                      provider.loginRepository.localDataSource.loadUser();
                      if (provider.loginRepository.localDataSource.token == ' ') {
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
