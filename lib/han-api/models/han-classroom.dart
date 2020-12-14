class HanClassroom {
  String naam;

  HanClassroom({this.naam});

  HanClassroom.fromJson(Map<String, dynamic> json) {
    naam = json['naam'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['naam'] = this.naam;
    return data;
  }
}
