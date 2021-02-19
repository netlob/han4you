import 'package:flutter/material.dart';
import 'package:han4you/api/graphql/graphql.dart';
import 'package:han4you/models/graphql/building.dart';
import 'package:han4you/providers/graphql-provider.dart';
import 'package:han4you/view/generic-future-builder.dart';
import 'package:han4you/view/pages/room-page.dart';
import 'package:provider/provider.dart';

class BuildingList extends StatefulWidget {
  @override
  _BuildingListState createState() => _BuildingListState();
}

class _BuildingListState extends State<BuildingList> {
  Future<List<Building>> _buildingsFuture;

  @override
  void initState() {
    GraphQL graphql = context.read<GraphQLProvider>().graphql;
    _buildingsFuture = graphql.fetchBuildings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GenericFutureBuilder<List<Building>>(
      future: _buildingsFuture,
      builder: (buildings) {
        return ListView.builder(
          itemCount: buildings.length,
          itemBuilder: (_, index) {
            final building = buildings[index];
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
