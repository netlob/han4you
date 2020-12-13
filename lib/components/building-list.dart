import 'package:flutter/material.dart';
import 'package:han4you/han-api/han-api.dart';
import 'package:han4you/han-api/models/building.dart';

class BuildingList extends StatefulWidget {
  @override
  _BuildingListState createState() => _BuildingListState();
}

class _BuildingListState extends State<BuildingList> {
  Future<List<Building>> _buildingsFuture;

  ListView _buildList(List<Building> buildings) {
    return ListView.builder(
      itemCount: buildings.length,
      itemBuilder: (BuildContext ctx, int index) {
        Building building = buildings[index];
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
    return FutureBuilder<List<Building>>(
      future: _buildingsFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Building>> snapshot) {
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
