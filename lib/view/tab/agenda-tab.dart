import 'package:flutter/material.dart';
import 'package:han4you/view/calendar.dart';

class AgendaTab extends StatefulWidget {
  @override
  _AgendaTabState createState() => _AgendaTabState();
}

class _AgendaTabState extends State<AgendaTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Calendar(onDaySelected: (index) {}),
      ],
    );
  }
}
