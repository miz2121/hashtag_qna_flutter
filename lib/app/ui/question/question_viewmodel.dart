import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/data/repository/question_repository.dart';

final questionViewModelProvider =
    StateNotifierProvider<QuestionViewModel, QuestionRepository>(
        (ref) => QuestionViewModel(QuestionRepository()));

class QuestionViewModel extends StateNotifier<QuestionRepository> {
  QuestionViewModel(super.state);

  final QuestionRepository _questionRepository = QuestionRepository();

  Future<Map<String, dynamic>> getQuestionMaps(int id) {
    return _questionRepository.getQuestionMaps(id);
  }
}