import 'package:flutter/material.dart';
import 'package:han4you/repository/graphql-repository.dart';
import 'package:han4you/repository/models/graphql/room.dart';
import 'package:han4you/view/page/room-page.dart';

class RoomList extends StatefulWidget {
  final String address;

  RoomList({@required this.address});

  @override
  _RoomListState createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  final GraphQLRepository _repository = GraphQLRepository();
  Future _roomFuture;

  @override
  void initState() {
    _roomFuture = _repository.getRooms(widget.address);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Room>>(
      future: _roomFuture,
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (_, index) {
            final room = snapshot.data[index];
            return ListTile(
              title: Text(room.name),
              subtitle: Text(
                '${room.available}/${room.total} kamers beschikbaar',
              ),
            );
          },
        );
      },
    );
  }
}
