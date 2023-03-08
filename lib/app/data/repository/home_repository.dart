import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/data/datasource/remote_datasource.dart';

import '../model/home.dart';

class HomeRepository {
  final RemoteDatasource _remoteDatasource = RemoteDatasource();

  Future<Map<String, dynamic>> getHomeQuestions() {
    return _remoteDatasource.getHomeQuestions();
  }
}

