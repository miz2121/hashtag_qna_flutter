import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/data/repository/info_repository.dart';

final infoViewModelProvider = StateNotifierProvider<InfoViewModel, InfoRepository>((ref) => InfoViewModel(InfoRepository()));

class InfoViewModel extends StateNotifier<InfoRepository> {
  InfoViewModel(super.state);

  final InfoRepository _infoRepository = InfoRepository();

  Future<Map<String, dynamic>> getMemberInfoMaps(String token) async {
    return await _infoRepository.getMemberInfoMaps(token);
  }

  Future<Map<String, dynamic>> putMemberInactive(String token) async {
    return await _infoRepository.putMemberInactive(token);
  }

  Future<Map<String, dynamic>> patchUpdateNickname(String token, String nickname) async {
    return await _infoRepository.patchUpdateNickname(token, nickname);
  }

  Future<void> clearPref() async {
    await _infoRepository.clearPref();
  }

  get hashtagColorList => _infoRepository.hashtagColorList;
}
