import 'package:hashtag_qna_flutter/app/data/model/hashtag_dtos.dart';
import 'package:hashtag_qna_flutter/app/data/model/question_list_dtos.dart';

class Home {

  List<QuestionListDtos>? questionListDtos;
  List<HashtagDtos>? hashtagDtos;

  Home({this.questionListDtos, this.hashtagDtos});

  Home.fromJson(Map<String, dynamic> json) {
    if (json['questionListDtos'] != null) {
      questionListDtos = <QuestionListDtos>[];
      json['questionListDtos'].forEach((v) {
        questionListDtos!.add(QuestionListDtos.fromJson(v));
      });
    }
    if (json['hashtagDtos'] != null) {
      hashtagDtos = <HashtagDtos>[];
      json['hashtagDtos'].forEach((v) {
        hashtagDtos!.add(HashtagDtos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (questionListDtos != null) {
      data['questionListDtos'] =
          questionListDtos!.map((v) => v.toJson()).toList();
    }
    if (hashtagDtos != null) {
      data['hashtagDtos'] = hashtagDtos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
