import 'package:flutter/material.dart';
import 'package:han4you/view/lists/building-list.dart';
import 'package:han4you/view/header.dart';

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
          child: BuildingList(),
        ),
      ],
    );
  }
}
