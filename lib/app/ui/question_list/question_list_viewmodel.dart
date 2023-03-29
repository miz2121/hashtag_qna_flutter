import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/data/repository/question_list_repository.dart';

final questionListViewModelProvider = StateNotifierProvider<QuestionListViewModel, QuestionListRepository>((ref) => QuestionListViewModel(QuestionListRepository()));

class QuestionListViewModel extends StateNotifier<QuestionListRepository> {
  QuestionListViewModel(super.state);

  final QuestionListRepository _questionListRepository = QuestionListRepository();

  Future<Map<String, dynamic>> getViewQuestions(String token) async {
    return await _questionListRepository.getViewQuestions(token);
  }

  get hashtagColorList => _questionListRepository.hashtagColorList;
}
