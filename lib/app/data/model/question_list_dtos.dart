class QuestionListDtos{
  int? id;
  String? writer;
  String? title;
  String? questionStatus;
  int? answerCount;
  DateTime? date;

  QuestionListDtos(
      {
        this.id,
        this.writer,
        this.title,
        this.questionStatus,
        this.answerCount,
        this.date});

  QuestionListDtos.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    writer = json['writer'] as String;
    title = json['title'] as String;
    questionStatus = json['questionStatus'] as String;
    answerCount = json['answerCount'] as int;
    date = DateTime.parse(json['date']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['int'] = int;
    data['writer'] = writer;
    data['title'] = title;
    data['questionStatus'] = questionStatus;
    data['answerCount'] = answerCount;
    data['date'] = date;
    return data;
  }
}
