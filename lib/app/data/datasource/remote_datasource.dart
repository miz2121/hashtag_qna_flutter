import 'dart:convert';

import 'package:hashtag_qna_flutter/app/data/model/hashtag_dtos.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
import 'package:http/http.dart' as http;

class RemoteDatasource {
  String address = "http://10.0.2.2:8080";

  Future<Map<String, dynamic>> getHomeQuestions() async {
    Uri uri = Uri.parse("$address/home");
    // logger.d("$address/home");
    final response = await (http.get(uri));
    // logger.d("response.statusCode: ", response.statusCode);
    if (response.statusCode == 200) {
      // OK
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      // logger.d("data is: ", data);
      return data;
    } else {
      logger.e('ERROR: ${response.statusCode}');
      throw Exception("Error on server");
    }
  }

  Future<Map<String, String>> postLogin(String email, String password) async {
    var uri = Uri.parse("$address/login");
    var message = {"email": email, "pwd": password};
    var response = await http.post(uri,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Accept": "application/json",
        },
        encoding: Encoding.getByName("utf-8"),
        body: jsonEncode(message));

    if (response.statusCode == 200) {
      // logger.d("response.headers", response.headers);
      return response.headers;
    } else {
      logger.e('ERROR: ${response.statusCode}');
      throw Exception("Error on server");
    }
  }

  Future<Map<String, String>> postJoin(String email, String password, String nickname) async {
    var uri = Uri.parse("$address/join");
    var message = {"email": email, "pwd": password, "nickname": nickname};
    var response = await http.post(uri, headers: {"Content-Type": "application/json", "Accept": "application/json"}, encoding: Encoding.getByName("utf-8"), body: jsonEncode(message));

    if (response.statusCode == 200) {
      // logger.d("response.headers", response.headers);
      return response.headers;
    } else {
      logger.e('ERROR: ${response.statusCode}');
      throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> getMemberInfoMaps(String token) async {
    Uri uri = Uri.parse("$address/members");
    var headers = {"Authorization": "Bearer $token"};
    final response = await (http.get(uri, headers: headers));
    // logger.d("response.statusCode: ", response.statusCode);
    if (response.statusCode == 200) {
      // OK
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      // logger.d("data is: ", data);
      return data;
    } else {
      logger.e('ERROR: ${response.statusCode}');
      throw Exception("Error on server");
    }
  }

  Future<List<dynamic>> getHashtags() async {
    Uri uri = Uri.parse("$address/hashtags");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      logger.e('ERROR: ${response.statusCode}');
      throw Exception("Error on server");
    }
  }

  Future<Map<String, String>> postWriteQuestion(String? token, String title, String content, List<String> existHashtags, List<String> newHashtags) async {
    var uri = Uri.parse("$address/questions");

    List<HashtagDtos> existHashtagDtos = [];
    for (String ht in existHashtags) {
      existHashtagDtos.add(HashtagDtos(hashtagName: ht));
    }
    List<HashtagDtos> newHashtagDtos = [];
    for (String ht in newHashtags) {
      newHashtagDtos.add(HashtagDtos(hashtagName: ht));
    }

    var message = {"title": title, "content": content, "existHashtagDtos": existHashtagDtos, "newHashtagDtos": newHashtagDtos};
    var response = await http.post(uri, headers: {"Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"), body: jsonEncode(message));

    logger.d('body: ${jsonEncode(message)}');

    if (response.statusCode == 200) {
      // logger.d("response.headers", response.headers);
      return response.headers;
    } else {
      logger.e('ERROR: ${response.statusCode}');
      throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> getQuestion(String? token, int id) async {
    Uri uri = Uri.parse("$address/questions/$id");
    var headers = {"Authorization": "Bearer $token"};
    final response = await (http.get(uri, headers: headers));
    // logger.d("response.statusCode: ", response.statusCode);
    if (response.statusCode == 200) {
      // OK
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      logger.e('ERROR: ${response.statusCode}');
      throw Exception("Error on server");
    }
  }

  Future<Map<String, String>> postWriteQuComment(String? token, int questionId, String comment) async {
    var uri = Uri.parse("$address/questions/$questionId/comments");

    var message = {"content": comment};
    var response = await http.post(uri, headers: {"Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"), body: jsonEncode(message));

    logger.d('body: ${jsonEncode(message)}');

    if (response.statusCode == 200) {
      // logger.d("response.headers", response.headers);
      return response.headers;
    } else {
      logger.e('ERROR: ${response.statusCode}');
      throw Exception("Error on server");
    }
  }

  Future<Map<String, String>> postWriteAnComment(String? token, int questionId, int answerId, String comment) async {
    var uri = Uri.parse("$address/questions/$questionId/answers/$answerId/comments");

    var message = {"content": comment};
    var response = await http.post(uri, headers: {"Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"), body: jsonEncode(message));

    logger.d('body: ${jsonEncode(message)}');

    if (response.statusCode == 200) {
      // logger.d("response.headers", response.headers);
      return response.headers;
    } else {
      logger.e('ERROR: ${response.statusCode}');
      throw Exception("Error on server");
    }
  }

  Future<Map<String, String>> postWriteAnswer(String? token, int questionId, String answer) async {
    var uri = Uri.parse("$address/questions/$questionId/answers");

    var message = {"content": answer};
    var response = await http.post(uri, headers: {"Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"), body: jsonEncode(message));

    logger.d('body: ${jsonEncode(message)}');

    if (response.statusCode == 200) {
      // logger.d("response.headers", response.headers);
      return response.headers;
    } else {
      logger.e('ERROR: ${response.statusCode}');
      throw Exception("Error on server");
    }
  }

  Future<Map<String, String>> patchUpdateAnComment(String? token, int questionId, int answerId, int anCommentId, String anComment) async {
    var uri = Uri.parse("$address/questions/$questionId/answers/$answerId/comments/$anCommentId");

    var message = {"content": anComment};
    var response = await http.patch(uri, headers: {"Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"), body: jsonEncode(message));

    logger.d('body: ${jsonEncode(message)}');

    if (response.statusCode == 200) {
      // logger.d("response.headers", response.headers);
      return response.headers;
    } else {
      logger.e('ERROR: ${response.statusCode}');
      throw Exception("Error on server");
    }
  }

  Future<Map<String, String>> patchUpdateQuComment(String? token, int questionId, int quCommentId, String quComment) async {
    var uri = Uri.parse("$address/questions/$questionId/comments/$quCommentId");

    var message = {"content": quComment};
    var response = await http.patch(uri, headers: {"Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"), body: jsonEncode(message));

    logger.d('body: ${jsonEncode(message)}');

    if (response.statusCode == 200) {
      // logger.d("response.headers", response.headers);
      return response.headers;
    } else {
      logger.e('ERROR: ${response.statusCode}');
      throw Exception("Error on server");
    }
  }

  Future<Map<String, String>> postRemoveQuComment(String? token, int questionId, int quCommentId) async {
    var uri = Uri.parse("$address/questions/$questionId/comments/remove/$quCommentId");

    var response = await http.post(uri, headers: {"Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      // logger.d("response.headers", response.headers);
      return response.headers;
    } else {
      logger.e('ERROR: ${response.statusCode}');
      throw Exception("Error on server");
    }
  }

  Future<Map<String, String>> postRemoveAnComment(String? token, int questionId, int answerId, int anCommentId) async {
    var uri = Uri.parse("$address/questions/$questionId/answers/$answerId/comments/remove/$anCommentId");

    var response = await http.post(uri, headers: {"Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      // logger.d("response.headers", response.headers);
      return response.headers;
    } else {
      logger.e('ERROR: ${response.statusCode}');
      throw Exception("Error on server");
    }
  }

  Future<Map<String, String>> patchUpdateQuestion(String? token, int questionId, String title, String content) async {
    var uri = Uri.parse("$address/questions/$questionId");

    var message = {"title": title, "content": content};
    var response = await http.patch(uri, headers: {"Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"), body: jsonEncode(message));

    if (response.statusCode == 200) {
      // logger.d("response.headers", response.headers);
      return response.headers;
    } else {
      logger.e('ERROR: ${response.statusCode}');
      throw Exception("Error on server");
    }
  }

  Future<Map<String, String>> postRemoveQuestion(String? token, int questionId) async {
    var uri = Uri.parse("$address/questions/remove/$questionId");

    var response = await http.post(uri, headers: {"Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      // logger.d("response.headers", response.headers);
      return response.headers;
    } else {
      logger.e('ERROR: ${response.statusCode}');
      throw Exception("Error on server");
    }
  }

  Future<Map<String, String>> patchUpdateAnswer(String? token, int questionId, int answerId, String content) async {
    var uri = Uri.parse("$address/questions/$questionId/answers/$answerId");

    var message = {"content": content};
    var response = await http.patch(uri, headers: {"Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"), body: jsonEncode(message));

    logger.d('body: ${jsonEncode(message)}');

    if (response.statusCode == 200) {
      // logger.d("response.headers", response.headers);
      return response.headers;
    } else {
      logger.e('ERROR: ${response.statusCode}');
      throw Exception("Error on server");
    }
  }

  Future<Map<String, String>> postRemoveAnswer(String? token, int questionId, int answerId) async {
    var uri = Uri.parse("$address/questions/$questionId/answers/remove/$answerId");

    var response = await http.post(uri, headers: {"Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      // logger.d("response.headers", response.headers);
      return response.headers;
    } else {
      logger.e('ERROR: ${response.statusCode}');
      throw Exception("Error on server");
    }
  }
}
