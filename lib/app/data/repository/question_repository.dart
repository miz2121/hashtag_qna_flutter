import 'package:hashtag_qna_flutter/app/data/datasource/local_datasource.dart';
import 'package:hashtag_qna_flutter/app/data/datasource/remote_datasource.dart';

class QuestionRepository {
  final RemoteDatasource _remoteDatasource = RemoteDatasource();
  final LocalDataSource _localDataSource = LocalDataSource();

  Future<Map<String, dynamic>> getQuestionMaps(int id) async {
    await _localDataSource.loadUser();
    return await _remoteDatasource.getQuestion(_localDataSource.token, id);
  }

  Future<Map<String, String>> postWriteQuComment(String? token, int questionId, String comment) async {
    return _remoteDatasource.postWriteQuComment(token, questionId, comment);
  }

  Future<Map<String, String>> postWriteAnComment(String? token, int questionId, int answerId, String comment) async {
    return _remoteDatasource.postWriteAnComment(token, questionId, answerId, comment);
  }
}
