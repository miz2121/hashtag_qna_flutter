import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/data/repository/question_list_repository.dart';

final questionListViewModelProvider = StateNotifierProvider<QuestionListViewModel, QuestionListRepository>((ref) => QuestionListViewModel(QuestionListRepository()));

class QuestionListViewModel extends StateNotifier<QuestionListRepository> {
  QuestionListViewModel(super.state);

  final QuestionListRepository _questionListRepository = QuestionListRepository();

  Future<Map<String, dynamic>> getViewQuestionsWithPagination(String token, page) async {
    return await _questionListRepository.getViewQuestionsWithPagination(token, page);
  }

  Future<Map<String, dynamic>> getSearch(String? token, String searchType, String searchText, int page) async {
    return await _questionListRepository.getSearch(token, searchType, searchText, page);
  }

  Future<Map<String, dynamic>> getQuestionsByOneHashtag(String? token, String hashtag, int page) async {
    return _questionListRepository.getQuestionsByOneHashtag(token, hashtag, page);
  }

  Future<Map<String, dynamic>> getMyQuestions(String? token, int page) async {
    return _questionListRepository.getMyQuestions(token, page);
  }

  Future<Map<String, dynamic>> getQuestionsWithMyAnswers(String? token, int page) async {
    return _questionListRepository.getQuestionsWithMyAnswers(token, page);
  }

  Future<Map<String, dynamic>> getQuestionsWithMyComments(String? token, int page) async {
    return _questionListRepository.getQuestionsWithMyComments(token, page);
  }

  Future<Map<String, dynamic>> getQuestionsWithMyHashtags(String? token, int page) async {
    return _questionListRepository.getQuestionsWithMyHashtags(token, page);
  }

  final List<String> _searchType = [
    '전체 검색',
    '제목 검색',
    '내용 검색',
    '질문 작성자 닉네임 검색',
    '답변 작성자 닉네임 검색',
    '댓글 작성자 닉네임',
  ];
  String _selectedType = '전체 검색';
  String _searchText = '';

  get getSearchType => _searchType;
  get getSelectedType => _selectedType;
  get getSearchText => _searchText;
  set setSelectedType(String type) => _selectedType = type;
  set setSearchText(String text) => _searchText = text;

  get hashtagColorList => _questionListRepository.hashtagColorList;
}
