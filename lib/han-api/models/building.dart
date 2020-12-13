import 'package:han4you/han-api/han-api.dart';
import 'package:han4you/han-api/models/room.dart';

class Building {
  String address;
  int available;
  int total;

  Building({this.address, this.available, this.total});

  Future<List<Room>> getRooms() async {
    var res = await HanApi.graphQl.query(
      'query (\$code: String!) { rooms(building: \$code) { available id name total }}',
      {
        'code': this.address,
      },
    );
    List<Room> rooms = List<Room>();

    for (var room in res['data']['rooms']) {
      rooms.add(Room.fromJson(room));
    }

    return rooms;
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
