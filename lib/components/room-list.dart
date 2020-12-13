import 'package:flutter/material.dart';
import 'package:han4you/han-api/han-api.dart';
import 'package:han4you/han-api/models/building.dart';
import 'package:han4you/han-api/models/room.dart';

class RoomList extends StatefulWidget {
  Building building;

  RoomList({@required this.building});

  @override
  _RoomListState createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  Future<List<Room>> _roomsFuture;

  ListView _buildList(List<Room> rooms) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: rooms.length,
      itemBuilder: (BuildContext ctx, int index) {
        Room room = rooms[index];
        return ListTile(
          dense: true,
          title: Text(room.name),
          subtitle: Text('${room.available} / ${room.total} beschikbaar'),
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
    return FutureBuilder<List<Room>>(
      future: _roomsFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Room>> snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return _buildList(snapshot.data);
      },
    );
  }
}
