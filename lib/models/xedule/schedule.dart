class Schedule {
  String name;
  List<int> ids;

  Schedule({this.name, this.ids});

  Schedule.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    ids = json['ids'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['ids'] = this.ids;
    return data;
  }
}