import 'package:flutter/material.dart';
import 'package:han4you/api/graphql/graphql.dart';
import 'package:han4you/models/graphql/room.dart';
import 'package:han4you/providers/graphql-provider.dart';
import 'package:han4you/view/generic-future-builder.dart';
import 'package:provider/provider.dart';

class RoomList extends StatefulWidget {
  final String address;

  RoomList({@required this.address});

  @override
  _RoomListState createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  Future<List<Room>> _roomsFuture;

  @override
  void initState() {
    GraphQL graphql = context.read<GraphQLProvider>().graphql;
    _roomsFuture = graphql.fetchRooms(widget.address);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GenericFutureBuilder<List<Room>>(
      future: _roomsFuture,
      builder: (rooms) {
        return ListView.builder(
          itemCount: rooms.length,
          itemBuilder: (_, index) {
            final room = rooms[index];
            final available = room.available - (room.total - room.available);

            return ListTile(
              title: Text(room.name),
              subtitle: Text('$available/${room.total} beschikbaar'),
            );
          },
        );
      },
    );
  }
}
