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

  Future<Map<String, String>> postWriteAnswer(String? token, int questionId, String answer) async {
    return _remoteDatasource.postWriteAnswer(token, questionId, answer);
  }

  Future<Map<String, String>> patchUpdateAnComment(String? token, int questionId, int answerId, int anCommentId, String anComment) async {
    return _remoteDatasource.patchUpdateAnComment(token, questionId, answerId, anCommentId, anComment);
  }

  Future<Map<String, String>> patchUpdateQuComment(String? token, int questionId, int quCommentId, String quComment) async {
    return _remoteDatasource.patchUpdateQuComment(token, questionId, quCommentId, quComment);
  }

  get hashtagColorList => _localDataSource.hashtagColorList;
}
