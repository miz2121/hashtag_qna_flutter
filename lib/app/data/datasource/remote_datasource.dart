

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';

import '../model/home.dart';

class RemoteDatasource {
  var logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  Future<Map<String, dynamic>> getHomeQuestions() async {
    var uri = Uri.parse("http://10.0.2.2:8080/home");
    final uriResponse = await (http.get(uri));
    // logger.d("uriResponse.statusCode: ", uriResponse.statusCode);
    if (uriResponse.statusCode == 200) {  // OK
      var data = jsonDecode(utf8.decode(uriResponse.bodyBytes));
      logger.d("data is: ", data);
      return data;
    } else {
      logger.e('ERROR: ${uriResponse.statusCode}');
      throw Exception("Error on server");
    }
  }
}
