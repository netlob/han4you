import 'package:flutter/material.dart';
import 'package:han4you/repository/graphql-repository.dart';
import 'package:han4you/repository/models/graphql/building.dart';
import 'package:han4you/view/page/room-page.dart';

import 'room-list.dart';

class BuildingList extends StatefulWidget {
  @override
  _BuildingListState createState() => _BuildingListState();
}

class _BuildingListState extends State<BuildingList> {
  final GraphQLRepository _repository = GraphQLRepository();
  Future _buildingFuture;

  @override
  void initState() {
    _buildingFuture = _repository.getBuildings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Building>>(
      future: _buildingFuture,
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
            final building = snapshot.data[index];
            final available =
                building.available - (building.total - building.available);
            return ListTile(
              title: Text(building.address),
              subtitle: Text('$available beschikbaar'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoomPage(building: building),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
