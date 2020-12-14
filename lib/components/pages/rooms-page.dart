import 'package:flutter/material.dart';
import 'package:han4you/components/page-header.dart';
import 'package:han4you/components/room-list.dart';
import 'package:han4you/han-api/models/han-building.dart';

class RoomsPage extends StatelessWidget {
  final HanBuilding building;

  RoomsPage({@required this.building});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          PageHeader(
            title: 'Kamers',
            subtitle: 'op locatie ${building.address}',
          ),
          SizedBox(
            height: 50,
          ),
          Expanded(
            child: RoomList(building: building),
          ),
        ],
      ),
    );
  }
}
