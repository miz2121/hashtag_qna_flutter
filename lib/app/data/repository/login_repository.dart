import 'package:hashtag_qna_flutter/app/data/datasource/local_datasource.dart';
import 'package:hashtag_qna_flutter/app/data/datasource/remote_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  final LocalDataSource _localDataSource = LocalDataSource();
  final RemoteDatasource _remoteDatasource = RemoteDatasource();

  Future<Map<String, String>> postRequestLogin(String email, String password) {
    return _remoteDatasource.postRequestLogin(email, password);
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
