class MemberInfo {
  final String? _nickname;

  String? get nickname => _nickname;

  final String? _email;

  String? get email => _email;

  final int? _questionCount;

  int? get questionCount => _questionCount;

  final int? _answerCount;

  int? get answerCount => _answerCount;

  final int? _commentCount;

  int? get commentCount => _commentCount;

  final int? _hashtagCount;

  int? get hashtagCount => _hashtagCount;

  MemberInfo(this._nickname, this._email, this._questionCount,
      this._answerCount, this._commentCount, this._hashtagCount);
}
