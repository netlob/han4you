import 'package:flutter/material.dart';
import 'package:han4you/providers/graphql/building-provider.dart';
import 'package:han4you/providers/graphql/room-provider.dart';
import 'package:han4you/providers/xedule-provider.dart';
import 'package:han4you/view/pages/room-page.dart';
import 'package:provider/provider.dart';

class BuildingList extends StatefulWidget {
  @override
  _BuildingListState createState() => _BuildingListState();
}

class _BuildingListState extends State<BuildingList> {
  RoomProvider _provider = RoomProvider();

  @override
  void initState() {
    context.read<BuildingProvider>().fetchBuildings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BuildingProvider>();
    if (provider.loading) return Center(child: CircularProgressIndicator());

    return ListView.builder(
      itemCount: provider.buildings.length,
      itemBuilder: (_, index) {
        final building = provider.buildings[index];
        final available =
            building.available - (building.total - building.available);

        return ListTile(
          title: Text(building.address),
          subtitle: Text('$available beschikbaar'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: _provider,
                  child: RoomPage(building: building),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
