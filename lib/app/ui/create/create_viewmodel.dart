import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/data/repository/create_repository.dart';

final createViewModelProvider =
    StateNotifierProvider<CreateViewModel, CreateRepository>(
        (ref) => CreateViewModel(CreateRepository()));

class CreateViewModel extends StateNotifier<CreateRepository> {
  CreateViewModel(super.state);

  final CreateRepository _createRepository = CreateRepository();

  Future<List<dynamic>> getHashtags() {
    return _createRepository.getHashtags();
  }

  List<bool> isHashtagChecked = [];

  List<int> hashtagColorList = [100, 200, 300];
}
