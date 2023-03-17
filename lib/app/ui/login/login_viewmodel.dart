import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/data/repository/login_repository.dart';

final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginRepository>((ref) => LoginViewModel(LoginRepository()));

class LoginViewModel extends StateNotifier<LoginRepository> {
  LoginViewModel(super.state);

  final LoginRepository _loginRepository = LoginRepository();

  Future<Map<String, String>> postLogin(String email, String password) {
    return _loginRepository.postLogin(email, password);
  }

  void loadUser() {
    _loginRepository.loadUser();
  }

  void clearPref() {
    _loginRepository.clearPref();
  }

  get token => _loginRepository.token;

  void saveToken(String? token) async {
    _loginRepository.saveToken(token);
  }
}
