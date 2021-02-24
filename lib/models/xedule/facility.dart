import 'dart:convert';

class Facility {
  List<int> orus;
  String code;
  String id;

  Facility({this.orus, this.code, this.id});

  static List<Facility> decodeListFromBody(String body) {
    final facilities = jsonDecode(body);
    return facilities.map<Facility>((json) => Facility.fromJson(json)).toList();
  }

  Facility.fromJson(Map<String, dynamic> json) {
    orus = json['orus'].cast<int>();
    code = json['code'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orus'] = this.orus;
    data['code'] = this.code;
    data['id'] = this.id;
    return data;
  }
}