import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/data/repository/question_repository.dart';

final questionViewModelProvider = StateNotifierProvider<QuestionViewModel, QuestionRepository>((ref) => QuestionViewModel(QuestionRepository()));

class QuestionViewModel extends StateNotifier<QuestionRepository> {
  QuestionViewModel(super.state);

  final QuestionRepository _questionRepository = QuestionRepository();

  Future<Map<String, dynamic>> getQuestionMaps(int id) {
    return _questionRepository.getQuestionMaps(id);
  }

  Future<Map<String, String>> postWriteQuComment(String? token, int questionId, String comment) async {
    return _questionRepository.postWriteQuComment(token, questionId, comment);
  }

  Future<Map<String, String>> postWriteAnComment(String? token, int questionId, int answerId, String comment) async {
    return _questionRepository.postWriteAnComment(token, questionId, answerId, comment);
  }

  Future<Map<String, String>> postWriteAnswer(String? token, int questionId, String answer) async {
    return _questionRepository.postWriteAnswer(token, questionId, answer);
  }

  Future<Map<String, String>> patchUpdateAnComment(String? token, int questionId, int answerId, int anCommentId, String anComment) async {
    return _questionRepository.patchUpdateAnComment(token, questionId, answerId, anCommentId, anComment);
  }

  Future<Map<String, String>> patchUpdateQuComment(String? token, int questionId, int quCommentId, String quComment) async {
    return _questionRepository.patchUpdateQuComment(token, questionId, quCommentId, quComment);
  }

  Future<Map<String, String>> postRemoveQuComment(String? token, int questionId, int quCommentId) async {
    return _questionRepository.postRemoveQuComment(token, questionId, quCommentId);
  }

  Future<Map<String, String>> postRemoveAnComment(String? token, int questionId, int answerId, int anCommentId) async {
    return _questionRepository.postRemoveAnComment(token, questionId, answerId, anCommentId);
  }

  Future<Map<String, String>> patchUpdateQuestion(String? token, int questionId, String title, String content) async {
    return _questionRepository.patchUpdateQuestion(token, questionId, title, content);
  }

  Future<Map<String, String>> postRemoveQuestion(String? token, int questionId) async {
    return _questionRepository.postRemoveQuestion(token, questionId);
  }

  Future<Map<String, String>> patchUpdateAnswer(String? token, int questionId, int answerId, String content) async {
    return _questionRepository.patchUpdateAnswer(token, questionId, answerId, content);
  }

  Future<Map<String, String>> postRemoveAnswer(String? token, int questionId, int answerId) async {
    return _questionRepository.postRemoveAnswer(token, questionId, answerId);
  }

  get hashtagColorList => _questionRepository.hashtagColorList;

  String _previous = ''; // "homePage, questionsPage"
  get previous => _previous;
  setPrevious(String page) {
    _previous = page;
  }
}
