class Group {
  List<int> orus;
  String code;
  String id;

  Group({this.orus, this.code, this.id});

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
