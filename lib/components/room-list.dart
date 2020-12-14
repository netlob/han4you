import 'package:flutter/material.dart';
import 'package:han4you/han-api/models/han-building.dart';
import 'package:han4you/han-api/models/han-room.dart';

class RoomList extends StatefulWidget {
  final HanBuilding building;

  RoomList({@required this.building});

  @override
  _RoomListState createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  Future<List<HanRoom>> _roomsFuture;

  ListView _buildList(List<HanRoom> rooms) {
    return ListView.builder(
      itemCount: rooms.length,
      itemBuilder: (BuildContext ctx, int index) {
        HanRoom room = rooms[index];
        return ListTile(
          title: Text(room.name),
          subtitle: Text('${room.available}/${room.total} kamers beschikbaar'),
        );
      },
    );
  }

  @override
  void initState() {
    _roomsFuture = widget.building.getRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HanRoom>>(
      future: _roomsFuture,
      builder: (BuildContext context, AsyncSnapshot<List<HanRoom>> snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: _buildList(snapshot.data),
        );
      },
    );
  }
}
