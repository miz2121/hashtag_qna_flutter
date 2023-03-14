import 'package:hashtag_qna_flutter/app/data/datasource/remote_datasource.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class CreateRepository {
  final RemoteDatasource _remoteDatasource = RemoteDatasource();

  Future<List<dynamic>> getHashtags() {
    return _remoteDatasource.getHashtags();
  }
}