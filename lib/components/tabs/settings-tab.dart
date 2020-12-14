import 'package:flutter/material.dart';
import 'package:han4you/components/page-header.dart';

class SettingsTab extends StatefulWidget {
  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          PageHeader(
            title: 'Instellingen',
            subtitle: 'instellingen van de app',
          ),
          SizedBox()
        ],
      ),
    );
  }
}
