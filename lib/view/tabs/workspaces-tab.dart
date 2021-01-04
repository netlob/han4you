import 'package:flutter/material.dart';
import 'package:han4you/providers/graphql/building-provider.dart';
import 'package:han4you/providers/graphql/room-provider.dart';
import 'package:han4you/view/lists/building-list.dart';
import 'package:han4you/view/header.dart';
import 'package:provider/provider.dart';

class WorkspacesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(
          title: 'Werkplekken',
          subtitle: 'beschikbare werkplekken op de HAN',
        ),
        Expanded(
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => RoomProvider()),
              ChangeNotifierProvider(create: (_) => BuildingProvider())
            ],
            child: BuildingList(),
          ),
        ),
      ],
    );
  }
}
