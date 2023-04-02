import 'package:hashtag_qna_flutter/app/data/datasource/local_datasource.dart';
import 'package:hashtag_qna_flutter/app/data/datasource/remote_datasource.dart';

class QuestionListRepository {
  final RemoteDatasource _remoteDatasource = RemoteDatasource();
  final LocalDataSource _localDataSource = LocalDataSource();

  Future<Map<String, dynamic>> getViewQuestionsWithPagination(String token, int page) async {
    return await _remoteDatasource.getViewQuestionsWithPagination(token, page);
  }

  Future<Map<String, dynamic>> getSearch(String? token, String searchType, String searchText, int page) async {
    return await _remoteDatasource.getSearch(token, searchType, searchText, page);
  }

  Future<Map<String, dynamic>> getQuestionsByOneHashtag(String? token, String hashtag) async {
    return await _remoteDatasource.getQuestionsByOneHashtag(token, hashtag);
  }

  Future<Map<String, dynamic>> getMyQuestions(String? token) async {
    return await _remoteDatasource.getMyQuestions(token);
  }

  Future<Map<String, dynamic>> getQuestionsWithMyAnswers(String? token) async {
    return await _remoteDatasource.getQuestionsWithMyAnswers(token);
  }

  Future<Map<String, dynamic>> getQuestionsWithMyComments(String? token) async {
    return await _remoteDatasource.getQuestionsWithMyComments(token);
  }

  Future<Map<String, dynamic>> getQuestionsWithMyHashtags(String? token) async {
    return await _remoteDatasource.getQuestionsWithMyHashtags(token);
  }

  get hashtagColorList => _localDataSource.hashtagColorList;
}
