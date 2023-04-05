import 'package:hashtag_qna_flutter/app/data/model/member_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  String? _token;

  String? get token => _token;

  SharedPreferences? prefs;

  /// return memberInfo
  Future<MemberInfo> loadUser() async {
    prefs = await SharedPreferences.getInstance();
    _token = prefs?.getString('token');
    return MemberInfo(
      prefs?.getString('nickname'),
      prefs?.getString('email'),
      prefs?.getInt('questionCount'),
      prefs?.getInt('answerCount'),
      prefs?.getInt('commentCount'),
      prefs?.getInt('hashtagCount'),
    );
  }

  Future<void> clearPref() async {
    await prefs?.clear();
    _token = null;
  }

  Future<void> saveMemberInfo(
    String nickname,
    String email,
    int questionCount,
    int answerCount,
    int commentCount,
    int hashtagCount,
  ) async {
    prefs = await SharedPreferences.getInstance();
    prefs?.setString("nickname", nickname);
    prefs?.setString("email", email);
    prefs?.setInt("questionCount", questionCount);
    prefs?.setInt("answerCount", answerCount);
    prefs?.setInt("commentCount", commentCount);
    prefs?.setInt("hashtagCount", hashtagCount);
  }

  void saveToken(String? token) async {
    prefs = await SharedPreferences.getInstance();
    prefs?.setString("token", token ?? '');
  }

  final List<int> _hashtagColorList = [100, 200, 300];
  get hashtagColorList => _hashtagColorList;
}
