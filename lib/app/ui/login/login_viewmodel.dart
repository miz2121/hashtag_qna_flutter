import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/data/repository/login_repository.dart';

final loginViewModelProvider =
StateNotifierProvider<LoginViewModel, LoginRepository>(
        (ref) => LoginViewModel(LoginRepository()));

class LoginViewModel extends StateNotifier<LoginRepository>{
  LoginViewModel(super.state);

  final LoginRepository _loginRepository = LoginRepository();

  LoginRepository get loginRepository => _loginRepository;
}
