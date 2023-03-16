import 'package:hashtag_qna_flutter/app/data/datasource/local_datasource.dart';
import 'package:hashtag_qna_flutter/app/data/datasource/remote_datasource.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class HomeRepository {
  final LocalDataSource _localDataSource = LocalDataSource();
  final RemoteDatasource _remoteDatasource = RemoteDatasource();

  Future<Map<String, dynamic>> getHomeQuestions() {
    return _remoteDatasource.getHomeQuestions();
  }

  Future<Map<String, dynamic>> getMemberInfoMaps() async {
    loadUser();
    Map<String, dynamic> info =
        await _remoteDatasource.getMemberInfoMaps(token);

    saveMemberInfo(info['nickname'], info['email'], info['questionCount'],
        info['answerCount'], info['commentCount'], info['hashtagCount']);
    return info;
  }

  Future<void> loadUser() async {
    await _localDataSource.loadUser();
  }

  void clearPref() {
    _localDataSource.clearPref();
  }

  get token => _localDataSource.token;

  void saveMemberInfo(
    String nickname,
    String email,
    int questionCount,
    int answerCount,
    int commentCount,
    int hashtagCount,
  ) {
    _localDataSource.saveMemberInfo(
      nickname,
      email,
      questionCount,
      answerCount,
      commentCount,
      hashtagCount,
    );
  }

  getMemberInfo() => _localDataSource.memberInfo;
}
