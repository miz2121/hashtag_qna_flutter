import 'package:hashtag_qna_flutter/app/data/datasource/local_datasource.dart';
import 'package:hashtag_qna_flutter/app/data/datasource/remote_datasource.dart';

class JoinRepository {
  final RemoteDatasource _remoteDatasource = RemoteDatasource();
  final LocalDataSource _localDataSource = LocalDataSource();

  Future<Map<String, String>> postJoin(String email, String password, String nickname) {
    return _remoteDatasource.postJoin(email, password, nickname);
  }

  void loadUser() {
    _localDataSource.loadUser();
  }

  void clearPref() {
    _localDataSource.clearPref();
  }

  get token => _localDataSource.token;
}
