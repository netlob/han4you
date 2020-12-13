import 'package:flutter/material.dart';
import 'package:han4you/components/page-header.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
