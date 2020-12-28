import 'package:flutter/material.dart';
import 'package:han4you/repository/models/graphql/building.dart';
import 'package:han4you/view/header.dart';
import 'package:han4you/view/list/room-list.dart';

class RoomPage extends StatelessWidget {
  final Building building;

  RoomPage({@required this.building});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Header(
              title: 'Kamers',
              subtitle: building.address,
            ),
            Expanded(
              child: RoomList(
                address: building.address,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
