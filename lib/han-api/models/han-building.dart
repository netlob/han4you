import 'package:han4you/han-api/han-api.dart';
import 'package:han4you/han-api/models/han-room.dart';

class HanBuilding {
  String address;
  int available;
  int total;

  HanBuilding({this.address, this.available, this.total});

  Future<List<HanRoom>> getRooms() async {
    var res = await HanApi.graphQl.query(
      'query (\$code: String!) { rooms(building: \$code) { available id name total }}',
      {
        'code': this.address,
      },
    );
    List<HanRoom> rooms = List<HanRoom>();

    for (var room in res['data']['rooms']) {
      rooms.add(HanRoom.fromJson(room));
    }

    return rooms;
  }

  HanBuilding.fromJson(Map<String, dynamic> json) {
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
