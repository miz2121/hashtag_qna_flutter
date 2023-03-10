class HashtagDtos {
  String? hashtagName;

  HashtagDtos({this.hashtagName});

  HashtagDtos.fromJson(Map<String, dynamic> json) {
    hashtagName = json['hashtagName'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hashtagName'] = this.hashtagName;
    return data;
  }
}
