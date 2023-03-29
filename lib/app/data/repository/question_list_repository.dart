import 'package:hashtag_qna_flutter/app/data/datasource/local_datasource.dart';
import 'package:hashtag_qna_flutter/app/data/datasource/remote_datasource.dart';

class QuestionListRepository {
  final RemoteDatasource _remoteDatasource = RemoteDatasource();
  final LocalDataSource _localDataSource = LocalDataSource();

  Future<Map<String, dynamic>> getViewQuestions(String token) async {
    return await _remoteDatasource.getViewQuestions(token);
  }

  get hashtagColorList => _localDataSource.hashtagColorList;
}
