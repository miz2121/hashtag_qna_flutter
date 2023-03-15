import 'package:hashtag_qna_flutter/app/data/model/memberInfo.dart';
import 'package:hashtag_qna_flutter/app/data/model/memberInfoDtos.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class LocalDataSource {
  String? _token;

  String? get token => _token;

  MemberInfo? _memberInfo;

  MemberInfo? get memberInfo => _memberInfo;

  SharedPreferences? prefs;

  Future<void> loadUser() async {
    prefs = await SharedPreferences.getInstance();
    _token = prefs?.getString('token');
    _memberInfo = MemberInfo(
      prefs?.getString('nickname'),
      prefs?.getString('email'),
      prefs?.getInt('questionCount'),
      prefs?.getInt('answerCount'),
      prefs?.getInt('commentCount'),
      prefs?.getInt('hashtagCount'),
    );
  }

  void clearPref() {
    prefs?.clear();
    _token = null;
  }

  void saveMemberInfo(
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
}
