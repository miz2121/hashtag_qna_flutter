import 'package:hashtag_qna_flutter/app/data/datasource/remote_datasource.dart';
import 'package:http/http.dart' as http;

class LoginRepository {
  final RemoteDatasource _remoteDatasource = RemoteDatasource();

  Future<http.Response> postRequestLogin(String email, String password) {
    return _remoteDatasource.postRequestLogin(email, password);
  }
}