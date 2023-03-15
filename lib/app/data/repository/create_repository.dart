import 'package:hashtag_qna_flutter/app/data/datasource/local_datasource.dart';
import 'package:hashtag_qna_flutter/app/data/datasource/remote_datasource.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class CreateRepository {
  final RemoteDatasource _remoteDatasource = RemoteDatasource();
  final LocalDataSource _localDataSource = LocalDataSource();

  Future<List<dynamic>> getHashtags() {
    return _remoteDatasource.getHashtags();
  }

  Future<Map<String, String>> postRequestWriteQuestion(
      String title,
      String content,
      List<String> existHashtags,
      List<String> newHashtags) async {
    await _localDataSource.loadUser();
    return _remoteDatasource.postRequestWriteQuestion(
        _localDataSource.token, title, content, existHashtags, newHashtags);
  }
}
