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

  get hashtagColorList => _localDataSource.hashtagColorList;
}
