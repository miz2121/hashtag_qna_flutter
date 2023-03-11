import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';

import '../model/home.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class RemoteDatasource {
  String address = "http://10.0.2.2:8080";

  Future<Map<String, dynamic>> getHomeQuestions() async {
    Uri uri = Uri.parse("$address/home");
    logger.d("$address/home");
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

  Future<Map<String, String>> postRequestLogin(String email, String password) async {
    var uri = Uri.parse("$address/login");
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
    // logger.d("response.headers", response.headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      logger.d("response.headers", response.headers);
      return response.headers;
    } else {
      logger.e('ERROR: ${response.statusCode}');
      throw Exception("Error on server");
    }
  }
}
