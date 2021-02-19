import 'dart:convert';

class Building {
  String address;
  int available;
  int total;

  Building({this.address, this.available, this.total});

  static List<Building> decodeListFromBody(String body) {
    final json = jsonDecode(body);
    final buildings = json['data']['buildings'];
    return buildings.map<Building>((json) => Building.fromJson(json)).toList();
  }

  Building.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    available = json['available'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['address'] = this.address;
    data['available'] = this.available;
    data['total'] = this.total;
    return data;
  }
}