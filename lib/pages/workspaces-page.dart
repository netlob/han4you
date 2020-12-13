import 'package:flutter/material.dart';
import 'package:han4you/components/building-list.dart';
import 'package:han4you/components/page-header.dart';

class WorkspacesPage extends StatefulWidget {
  @override
  _WorkspacesPageState createState() => _WorkspacesPageState();
}

class _WorkspacesPageState extends State<WorkspacesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          PageHeader(
            title: 'Werkplekken',
            subtitle: 'beschikbare werkplekken op de HAN',
          ),
          SizedBox(
            height: 50,
          ),
          Expanded(
            child: BuildingList(),
          ),
        ],
      ),
    );
  }
}
