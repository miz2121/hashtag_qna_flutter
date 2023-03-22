import 'package:hashtag_qna_flutter/app/data/datasource/local_datasource.dart';
import 'package:hashtag_qna_flutter/app/data/datasource/remote_datasource.dart';
import 'package:hashtag_qna_flutter/app/data/model/member_info.dart';

class HomeRepository {
  final LocalDataSource _localDataSource = LocalDataSource();
  final RemoteDatasource _remoteDatasource = RemoteDatasource();

  Future<Map<String, dynamic>> getHomeQuestions() {
    return _remoteDatasource.getHomeQuestions();
  }

  Future<Map<String, dynamic>> getMemberInfoMaps(String token) async {
    Map<String, dynamic> info = await _remoteDatasource.getMemberInfoMaps(token);

    await saveMemberInfo(info['nickname'], info['email'], info['questionCount'], info['answerCount'], info['commentCount'], info['hashtagCount']);
    return info;
  }

  Future<MemberInfo> loadUser() async {
    return await _localDataSource.loadUser();
  }

  void clearPref() {
    _localDataSource.clearPref();
  }

  get token => _localDataSource.token;

  Future<void> saveMemberInfo(
    String nickname,
    String email,
    int questionCount,
    int answerCount,
    int commentCount,
    int hashtagCount,
  ) async {
    await _localDataSource.saveMemberInfo(
      nickname,
      email,
      questionCount,
      answerCount,
      commentCount,
      hashtagCount,
    );
  }

  get hashtagColorList => _localDataSource.hashtagColorList;
}
