import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/data/repository/create_repository.dart';

final createViewModelProvider = StateNotifierProvider<CreateViewModel, CreateRepository>((ref) => CreateViewModel(CreateRepository()));

class CreateViewModel extends StateNotifier<CreateRepository> {
  CreateViewModel(super.state);

  final CreateRepository _createRepository = CreateRepository();

  Future<Map<String, dynamic>> getHashtags() {
    return _createRepository.getHashtags();
  }

  List<bool> isHashtagChecked = List.empty(growable: true);

  Future<Map<String, dynamic>> postWriteQuestion(String title, String content, List<String> existHashtags, List<String> newHashtags) async {
    return _createRepository.postWriteQuestion(title, content, existHashtags, newHashtags);
  }

  get hashtagColorList => _createRepository.hashtagColorList;

  String _previous = '';
  get getPrevious => _previous;
  set setPrevious(String prev) => _previous = prev;
}
