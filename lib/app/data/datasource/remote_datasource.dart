import 'dart:convert';

import 'package:hashtag_qna_flutter/app/data/model/hashtag_dtos.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
import 'package:http/http.dart' as http;

class RemoteDatasource {
  String address = "http://:8080";

  Future<Map<String, dynamic>> getHomeQuestions() async {
    Uri uri = Uri.parse("$address/home");
    var headers = {"Connection": "Keep-Alive"};
    final response = await (http.get(uri, headers: headers));

    switch (response.statusCode) {
      case 200:
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> postLogin(String email, String password) async {
    var uri = Uri.parse("$address/login");
    var message = {"email": email, "pwd": password};
    var response = await http.post(uri,
        headers: {
          "Connection": "Keep-Alive",
          "Content-Type": "application/x-www-form-urlencoded",
          "Accept": "application/json",
        },
        encoding: Encoding.getByName("utf-8"),
        body: jsonEncode(message));

    switch (response.statusCode) {
      case 200:
        return response.headers;
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE"
      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> postJoin(String email, String password, String nickname) async {
    var uri = Uri.parse("$address/join");
    var message = {"email": email, "pwd": password, "nickname": nickname};
    var response = await http.post(uri, headers: {"Connection": "Keep-Alive", "Content-Type": "application/json", "Accept": "application/json"}, encoding: Encoding.getByName("utf-8"), body: jsonEncode(message));

    switch (response.statusCode) {
      case 200:
        return response.headers;
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 409: // data['code'] == "INFO_ALREADY_EXISTS"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> putMemberInactive(String token) async {
    Uri uri = Uri.parse("$address/members/inactive");
    var response = await http.put(uri, headers: {"Connection": "Keep-Alive", "Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"));

    switch (response.statusCode) {
      case 200:
        return response.headers;
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE"
      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> getMemberInfoMaps(String token) async {
    Uri uri = Uri.parse("$address/members");

    var headers = {"Connection": "Keep-Alive", "Authorization": "Bearer $token"};
    final response = await (http.get(uri, headers: headers));

    switch (response.statusCode) {
      case 200:
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE"
      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> getViewQuestionsWithPagination(String token, int page) async {
    Uri uri = Uri.parse("$address/questions?page=$page");
    var headers = {"Connection": "Keep-Alive", "Authorization": "Bearer $token"};
    final response = await (http.get(uri, headers: headers));
    switch (response.statusCode) {
      case 200:
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE"
      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> getHashtags() async {
    Uri uri = Uri.parse("$address/hashtags");
    final response = await http.get(uri);

    switch (response.statusCode) {
      case 200:
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> postWriteQuestion(String? token, String title, String content, List<String> existHashtags, List<String> newHashtags) async {
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
    var response = await http.post(uri, headers: {"Connection": "Keep-Alive", "Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"), body: jsonEncode(message));

    // logger.d('body: ${jsonEncode(message)}');

    switch (response.statusCode) {
      case 200:
        return response.headers;
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE"
      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> getQuestion(String? token, int id) async {
    Uri uri = Uri.parse("$address/questions/$id");
    var headers = {"Connection": "Keep-Alive", "Authorization": "Bearer $token"};
    final response = await (http.get(uri, headers: headers));

    switch (response.statusCode) {
      case 200:
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE"
      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error");
    }
  }

  Future<Map<String, dynamic>> postWriteQuComment(String? token, int questionId, String comment) async {
    var uri = Uri.parse("$address/questions/$questionId/comments");

    var message = {"content": comment};
    var response = await http.post(uri, headers: {"Connection": "Keep-Alive", "Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"), body: jsonEncode(message));

    logger.d('body: ${jsonEncode(message)}');

    switch (response.statusCode) {
      case 200:
        return response.headers;
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE" || "EDIT_COMMENT_AUTH"

      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> postWriteAnComment(String? token, int questionId, int answerId, String comment) async {
    var uri = Uri.parse("$address/questions/$questionId/answers/$answerId/comments");

    var message = {"content": comment};
    var response = await http.post(uri, headers: {"Connection": "Keep-Alive", "Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"), body: jsonEncode(message));

    logger.d('body: ${jsonEncode(message)}');

    switch (response.statusCode) {
      case 200:
        return response.headers;
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE" || "EDIT_COMMENT_AUTH"

      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> postWriteAnswer(String? token, int questionId, String answer) async {
    var uri = Uri.parse("$address/questions/$questionId/answers");

    var message = {"content": answer};
    var response = await http.post(uri, headers: {"Connection": "Keep-Alive", "Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"), body: jsonEncode(message));

    logger.d('body: ${jsonEncode(message)}');

    switch (response.statusCode) {
      case 200:
        return response.headers;
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE" || "CLOSED_QUESTION_AUTH" || "ANSWER_AUTH"

      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> patchUpdateAnComment(String? token, int questionId, int answerId, int anCommentId, String anComment) async {
    var uri = Uri.parse("$address/questions/$questionId/answers/$answerId/comments/$anCommentId");

    var message = {"content": anComment};
    var response = await http.patch(uri, headers: {"Connection": "Keep-Alive", "Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"), body: jsonEncode(message));

    logger.d('body: ${jsonEncode(message)}');

    switch (response.statusCode) {
      case 200:
        return response.headers;
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE" || "EDIT_COMMENT_AUTH"

      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> patchUpdateQuComment(String? token, int questionId, int quCommentId, String quComment) async {
    var uri = Uri.parse("$address/questions/$questionId/comments/$quCommentId");

    var message = {"content": quComment};
    var response = await http.patch(uri, headers: {"Connection": "Keep-Alive", "Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"), body: jsonEncode(message));

    logger.d('body: ${jsonEncode(message)}');

    switch (response.statusCode) {
      case 200:
        return response.headers;
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE" || "EDIT_COMMENT_AUTH"

      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> postRemoveQuComment(String? token, int questionId, int quCommentId) async {
    var uri = Uri.parse("$address/questions/$questionId/comments/remove/$quCommentId");

    var response = await http.post(uri, headers: {"Connection": "Keep-Alive", "Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"));

    switch (response.statusCode) {
      case 200:
        return response.headers;
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE" || "EDIT_COMMENT_AUTH"

      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> postRemoveAnComment(String? token, int questionId, int answerId, int anCommentId) async {
    var uri = Uri.parse("$address/questions/$questionId/answers/$answerId/comments/remove/$anCommentId");

    var response = await http.post(uri, headers: {"Connection": "Keep-Alive", "Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"));

    switch (response.statusCode) {
      case 200:
        return response.headers;
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE" || "EDIT_COMMENT_AUTH"

      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> patchUpdateQuestion(String? token, int questionId, String title, String content) async {
    var uri = Uri.parse("$address/questions/$questionId");

    var message = {"title": title, "content": content};
    var response = await http.patch(uri, headers: {"Connection": "Keep-Alive", "Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"), body: jsonEncode(message));

    switch (response.statusCode) {
      case 200:
        return response.headers;
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE" || "EDIT_QUESTION_AUTH" || "CLOSED_QUESTION_AUTH"

      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> postRemoveQuestion(String? token, int questionId) async {
    var uri = Uri.parse("$address/questions/remove/$questionId");

    var response = await http.post(uri, headers: {"Connection": "Keep-Alive", "Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"));

    switch (response.statusCode) {
      case 200:
        return response.headers;
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE" || "EDIT_QUESTION_AUTH" || "CLOSED_QUESTION_AUTH"

      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> patchUpdateAnswer(String? token, int questionId, int answerId, String content) async {
    var uri = Uri.parse("$address/questions/$questionId/answers/$answerId");

    var message = {"content": content};
    var response = await http.patch(uri, headers: {"Connection": "Keep-Alive", "Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"), body: jsonEncode(message));

    logger.d('body: ${jsonEncode(message)}');

    switch (response.statusCode) {
      case 200:
        return response.headers;
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE" || "EDIT_ANSWER_AUTH" || "CLOSED_QUESTION_AUTH"

      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> postRemoveAnswer(String? token, int questionId, int answerId) async {
    var uri = Uri.parse("$address/questions/$questionId/answers/remove/$answerId");

    var response = await http.post(uri, headers: {"Connection": "Keep-Alive", "Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"));

    switch (response.statusCode) {
      case 200:
        return response.headers;
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE" || "EDIT_ANSWER_AUTH" || "CLOSED_QUESTION_AUTH"

      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> patchselectAnswerAndGiveScore(String? token, int questionId, int answerId, String score) async {
    var uri = Uri.parse("$address/questions/$questionId/answers/select/$answerId");
    var message = {"scoreString": score};
    var response = await http.patch(uri, headers: {"Connection": "Keep-Alive", "Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"), body: jsonEncode(message));

    switch (response.statusCode) {
      case 200:
        return response.headers;
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE" || "EDIT_QUESTION_AUTH" || "CLOSED_QUESTION_AUTH" || "SELECT_AUTH"

      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> getSearch(String? token, String searchType, String searchText, int page) async {
    switch (searchType) {
      case '전체 검색':
        searchType = 'searchAll';
        break;
      case '제목 검색':
        searchType = 'searchTitle';
        break;
      case '내용 검색':
        searchType = 'searchContent';
        break;
      case '질문 작성자 닉네임 검색':
        searchType = 'searchQuestionWriter';
        break;
      case '답변 작성자 닉네임 검색':
        searchType = 'searchAnswerWriter';
        break;
      case '댓글 작성자 닉네임':
        searchType = 'searchCommentWriter';
        break;
    }
    Uri uri = Uri.parse("$address/questions/$searchType?page=$page&text=$searchText");

    var headers = {"Connection": "Keep-Alive", "Authorization": "Bearer $token"};
    final response = await (http.get(uri, headers: headers));

    switch (response.statusCode) {
      case 200:
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE"
      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error");
    }
  }

  Future<Map<String, dynamic>> patchUpdateNickname(String token, String nickname) async {
    var uri = Uri.parse("$address/members");

    var message = {"nickname": nickname};
    var response = await http.patch(uri, headers: {"Connection": "Keep-Alive", "Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token"}, encoding: Encoding.getByName("utf-8"), body: jsonEncode(message));

    logger.d('body: ${jsonEncode(message)}');

    switch (response.statusCode) {
      case 200:
        return response.headers;
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE" || "EDIT_COMMENT_AUTH"
      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error on server");
    }
  }

  Future<Map<String, dynamic>> getMyHashtags(String? token) async {
    Uri uri = Uri.parse("$address/members/hashtags");
    var headers = {"Connection": "Keep-Alive", "Authorization": "Bearer $token"};
    final response = await (http.get(uri, headers: headers));

    switch (response.statusCode) {
      case 200:
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE"
      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error");
    }
  }

  Future<Map<String, dynamic>> getQuestionsByOneHashtag(String? token, String hashtag, int page) async {
    Uri uri = Uri.parse("$address/questions/hashtag?page=$page&text=$hashtag");
    var headers = {"Connection": "Keep-Alive", "Authorization": "Bearer $token"};
    final response = await (http.get(uri, headers: headers));

    switch (response.statusCode) {
      case 200:
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE"
      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error");
    }
  }

  Future<Map<String, dynamic>> getMyQuestions(String? token, int page) async {
    Uri uri = Uri.parse("$address/questions/myQuestions?page=$page");
    var headers = {"Connection": "Keep-Alive", "Authorization": "Bearer $token"};
    final response = await (http.get(uri, headers: headers));

    switch (response.statusCode) {
      case 200:
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE"
      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error");
    }
  }

  Future<Map<String, dynamic>> getQuestionsWithMyAnswers(String? token, int page) async {
    Uri uri = Uri.parse("$address/questions/myAnswers?page=$page");
    var headers = {"Connection": "Keep-Alive", "Authorization": "Bearer $token"};
    final response = await (http.get(uri, headers: headers));

    switch (response.statusCode) {
      case 200:
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE"
      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error");
    }
  }

  Future<Map<String, dynamic>> getQuestionsWithMyComments(String? token, int page) async {
    Uri uri = Uri.parse("$address/questions/myComments?page=$page");
    var headers = {"Connection": "Keep-Alive", "Authorization": "Bearer $token"};
    final response = await (http.get(uri, headers: headers));

    switch (response.statusCode) {
      case 200:
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE"
      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error");
    }
  }

  Future<Map<String, dynamic>> getQuestionsWithMyHashtags(String? token, int page) async {
    Uri uri = Uri.parse("$address/questions/myHashtags?page=$page");
    var headers = {"Connection": "Keep-Alive", "Authorization": "Bearer $token"};
    final response = await (http.get(uri, headers: headers));

    switch (response.statusCode) {
      case 200:
      case 400: // data['code'] == "INVALID_PARAMETER"
      case 401: // data['code'] == "NOT_MEMBER_OR_INACTIVE"
      case 404: // data['code'] == "RESOURCE_NOT_FOUND"
      case 500: // data['code'] == "INTERNAL_SERVER_ERROR"
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // logger.d("data is: ", data);
        return data;
      default:
        logger.e('ERROR: ${response.statusCode}');
        throw Exception("Error");
    }
  }
}
