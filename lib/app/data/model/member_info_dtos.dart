class MemberInfoDtos {
  String? nickname;
  String? email;
  int? questionCount;
  int? answerCount;
  int? commentCount;
  int? hashtagCount;

  MemberInfoDtos({this.nickname, this.email, this.questionCount, this.answerCount, this.commentCount, this.hashtagCount});

  MemberInfoDtos.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'] as String;
    email = json['email'] as String;
    questionCount = json['questionCount'] as int;
    answerCount = json['answerCount'] as int;
    commentCount = json['commentCount'] as int;
    hashtagCount = json['hashtagCount'] as int;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['nickname'] = nickname;
    data['email'] = email;
    data['questionCount'] = questionCount;
    data['answerCount'] = answerCount;
    data['commentCount'] = commentCount;
    data['hashtagCount'] = hashtagCount;
    return data;
  }
}
