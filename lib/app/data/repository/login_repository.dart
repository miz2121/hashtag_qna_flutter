import 'package:hashtag_qna_flutter/app/data/datasource/local_datasource.dart';
import 'package:hashtag_qna_flutter/app/data/datasource/remote_datasource.dart';

class LoginRepository {
  final LocalDataSource _localDataSource = LocalDataSource();
  final RemoteDatasource _remoteDatasource = RemoteDatasource();

  Future<Map<String, dynamic>> postLogin(String email, String password) {
    return _remoteDatasource.postLogin(email, password);
  }

  void loadUser() {
    _localDataSource.loadUser();
  }

  void clearPref() {
    _localDataSource.clearPref();
  }

  get token => _localDataSource.token;

  void saveToken(String? token) {
    _localDataSource.saveToken(token);
  }
}
