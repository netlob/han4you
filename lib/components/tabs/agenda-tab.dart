import 'package:flutter/material.dart';
import 'package:han4you/components/agenda-calendar.dart';
import 'package:han4you/components/auth-view.dart';
import 'package:han4you/han-api/han-api.dart';
import 'package:han4you/han-api/xedule/xedule-auth.dart';

class AgendaTab extends StatefulWidget {
  @override
  _AgendaTabState createState() => _AgendaTabState();
}

class _AgendaTabState extends State<AgendaTab> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    if (!HanApi.xedule.authenticated) {
      return SafeArea(
        child: AuthView(
          onAuthenticated: (XeduleAuth auth) {
            setState(() {
              HanApi.xedule.auth = auth;
            });
          },
        ),
      );
    }

    return SafeArea(
      child: Column(
        children: [
          AgendaCalendar(
            onDaySelected: (date) {
              print(date.toString());
              setState(() {
                _selectedDate = date;
              });
            },
          ),
        ],
      ),
    );
  }
}
