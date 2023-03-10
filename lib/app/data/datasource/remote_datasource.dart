import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';

import '../model/home.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class RemoteDatasource {
  String api = "http://10.0.2.2:8080";

  Future<Map<String, dynamic>> getHomeQuestions() async {
    Uri uri = Uri.parse("$api/home");
    logger.d("$api/home");
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

  Future<http.Response> postRequestLogin(String email, String password) async {
    var uri = Uri.parse("$api/login");
    var message = {"email" : email, "pwd" : password};
    var response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Accept": "application/json"
        },
        encoding: Encoding.getByName("utf-8"),
        body: jsonEncode(message)
    );
    // "Content-Type": "application/x-www-form-urlencoded",
    // "Accept": "application/json"
    // "Content-Type": "application/json"
    // encoding: Encoding.getByName("utf-8")

    logger.d(jsonDecode(utf8.decode(response.bodyBytes)));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      logger.d(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      logger.e('ERROR: ${response.statusCode}');
      throw Exception("Error on server");
    }
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}
