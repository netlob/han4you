import 'dart:convert';

class Room {
  String address;
  int available;
  String id;
  String name;
  int total;

  Room({this.address, this.available, this.id, this.name, this.total});

  static List<Room> decodeListFromBody(String body) {
    final json = jsonDecode(body);
    final rooms = json['data']['rooms'];
    return rooms.map<Room>((json) => Room.fromJson(json)).toList();
  }

  Room.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    available = json['available'];
    id = json['id'];
    name = json['name'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['address'] = this.address;
    data['available'] = this.available;
    data['id'] = this.id;
    data['name'] = this.name;
    data['total'] = this.total;
    return data;
  }
}