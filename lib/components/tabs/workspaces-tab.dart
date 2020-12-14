import 'package:flutter/material.dart';
import 'package:han4you/components/building-list.dart';
import 'package:han4you/components/page-header.dart';

class WorkspacesTab extends StatefulWidget {
  @override
  _WorkspacesTabState createState() => _WorkspacesTabState();
}

class _WorkspacesTabState extends State<WorkspacesTab> {
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
