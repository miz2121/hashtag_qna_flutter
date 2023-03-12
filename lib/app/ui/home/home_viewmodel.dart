import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/data/model/memberInfo.dart';
import 'package:hashtag_qna_flutter/app/data/repository/home_repository.dart';

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeRepository>(
        (ref) => HomeViewModel(HomeRepository()));

class HomeViewModel extends StateNotifier<HomeRepository> {
  HomeViewModel(super.state);

  final HomeRepository _homeRepository = HomeRepository();

  Future<Map<String, dynamic>> getHomeQuestions() {
    return _homeRepository.getHomeQuestions();
  }

  Future<Map<String, dynamic>> getMemberInfoMaps() {
    return _homeRepository.getMemberInfoMaps();
  }

  void loadUser() {
    _homeRepository.loadUser();
  }

  void clearPref() {
    _homeRepository.clearPref();
  }

  get token => _homeRepository.token;

  getMemberInfo() => _homeRepository.getMemberInfo();

  MemberInfo clearMemberInfo() {
    _homeRepository.saveMemberInfo('', '', 0, 0, 0, 0);
    return getMemberInfo();
  }
}
