import 'package:hashtag_qna_flutter/app/data/datasource/local_datasource.dart';
import 'package:hashtag_qna_flutter/app/data/datasource/remote_datasource.dart';

class LoginRepository {
  final LocalDataSource _localDataSource = LocalDataSource();
  LocalDataSource get localDataSource => _localDataSource;

  final RemoteDatasource _remoteDatasource = RemoteDatasource();

  Future<Map<String, String>> postRequestLogin(String email, String password) {
    return _remoteDatasource.postRequestLogin(email, password);
  }
}