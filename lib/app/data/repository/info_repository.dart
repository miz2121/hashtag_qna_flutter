import 'package:hashtag_qna_flutter/app/data/datasource/local_datasource.dart';
import 'package:hashtag_qna_flutter/app/data/datasource/remote_datasource.dart';

class InfoRepository {
  final RemoteDatasource _remoteDatasource = RemoteDatasource();
  final LocalDataSource _localDataSource = LocalDataSource();

  Future<Map<String, dynamic>> getMemberInfoMaps(String token) async {
    return _remoteDatasource.getMemberInfoMaps(token);
  }

  Future<Map<String, dynamic>> putMemberInactive(String token) async {
    return await _remoteDatasource.putMemberInactive(token);
  }

  Future<Map<String, dynamic>> patchUpdateNickname(String token, String nickname) async {
    return await _remoteDatasource.patchUpdateNickname(token, nickname);
  }

  Future<Map<String, dynamic>> getMyHashtags(String? token) async {
    return await _remoteDatasource.getMyHashtags(token);
  }

  Future<void> clearPref() async {
    await _localDataSource.clearPref();
  }

  get hashtagColorList => _localDataSource.hashtagColorList;
}
