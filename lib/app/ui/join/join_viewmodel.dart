import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/data/repository/join_repository.dart';

final joinViewModelProvider = StateNotifierProvider<JoinViewModel, JoinRepository>((ref) => JoinViewModel(JoinRepository()));

class JoinViewModel extends StateNotifier<JoinRepository> {
  JoinViewModel(super.state);

  final JoinRepository _joinRepository = JoinRepository();

  Future<Map<String, String>> postJoin(String email, String password, String nickname) {
    return _joinRepository.postJoin(email, password, nickname);
  }

  void loadUser() {
    _joinRepository.loadUser();
  }

  void clearPref() {
    _joinRepository.clearPref();
  }

  get token => _joinRepository.token;
}
