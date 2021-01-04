import 'package:flutter/material.dart';
import 'package:han4you/providers/graphql/room-provider.dart';
import 'package:provider/provider.dart';

class RoomList extends StatefulWidget {
  final String address;

  RoomList({@required this.address});

  @override
  _RoomListState createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  @override
  void initState() {
    context.read<RoomProvider>().fetchRooms(widget.address);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoomProvider>();
    if (provider.loading) return Center(child: CircularProgressIndicator());

    return ListView.builder(
      itemCount: provider.rooms.length,
      itemBuilder: (_, index) {
        final room = provider.rooms[index];
        final available = room.available - (room.total - room.available);

        return ListTile(
          title: Text(room.name),
          subtitle: Text('$available/${room.total} beschikbaar'),
        );
      },
    );
  }
}
