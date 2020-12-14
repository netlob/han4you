import 'package:flutter/material.dart';
import 'package:han4you/han-api/han-api.dart';
import 'package:han4you/han-api/models/han-building.dart';

import 'pages/rooms-page.dart';

class BuildingList extends StatefulWidget {
  @override
  _BuildingListState createState() => _BuildingListState();
}

class _BuildingListState extends State<BuildingList> {
  Future<List<HanBuilding>> _buildingsFuture;

  ListView _buildList(List<HanBuilding> buildings) {
    return ListView.builder(
      itemCount: buildings.length,
      itemBuilder: (BuildContext ctx, int index) {
        HanBuilding building = buildings[index];
        int available =
            building.available - (building.total - building.available);
        return ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.home_work_outlined),
            ],
          ),
          title: Text(building.address),
          subtitle: Text('$available beschikbaar'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RoomsPage(building: building),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    _buildingsFuture = HanApi.getBuildings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HanBuilding>>(
      future: _buildingsFuture,
      builder:
          (BuildContext context, AsyncSnapshot<List<HanBuilding>> snapshot) {
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
