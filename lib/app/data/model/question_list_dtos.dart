class QuestionListDtos {
  String? writer;
  String? title;
  String? questionStatus;
  int? answerCount;
  DateTime? date;

  QuestionListDtos(
      {this.writer,
        this.title,
        this.questionStatus,
        this.answerCount,
        this.date});

  QuestionListDtos.fromJson(Map<String, dynamic> json) {
    writer = json['writer'] as String;
    title = json['title'] as String;
    questionStatus = json['questionStatus'] as String;
    answerCount = json['answerCount'] as int;
    date = DateTime.parse(json['date']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['writer'] = writer;
    data['title'] = title;
    data['questionStatus'] = questionStatus;
    data['answerCount'] = answerCount;
    data['date'] = date;
    return data;
  }
}
