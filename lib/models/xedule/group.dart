import 'dart:convert';

class Group {
  List<int> orus;
  String code;
  String id;

  bool checked = false;

  Group({this.orus, this.code, this.id});

  static List<Group> decodeListFromBody(String body) {
    final groups = jsonDecode(body);
    return groups.map<Group>((json) => Group.fromJson(json)).toList();
  }

  Group.fromJson(Map<String, dynamic> json) {
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
