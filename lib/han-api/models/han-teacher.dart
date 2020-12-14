class HanTeacher {
  String naam;

  HanTeacher({this.naam});

  HanTeacher.fromJson(Map<String, dynamic> json) {
    naam = json['naam'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['naam'] = this.naam;
    return data;
  }
}
