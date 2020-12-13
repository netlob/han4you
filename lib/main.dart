import 'package:flutter/material.dart';
import 'package:han4you/pages/agenda-page.dart';
import 'package:han4you/pages/outages-page.dart';
import 'package:han4you/pages/settings-page.dart';

import 'pages/workspaces-page.dart';

void main() {
  runApp(Han4You());
}

class Han4You extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Router();
  }
}

class Router extends StatefulWidget {
  @override
  _RouterState createState() => _RouterState();
}

class _RouterState extends State<Router> {
  int _selectedIndex = 0;
  List<Widget> _pages = [
    WorkspacesPage(),
    AgendaPage(),
    OutagesPage(),
    SettingsPage()
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'han4you',
      theme: ThemeData(
        primaryColor: Color(0xFFE5005B),
        accentColor: Color(0xFFE5005A),
      ),
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              label: 'Werkplekken',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Agenda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.error_outline),
              label: 'Storingen',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'Instellingen',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onTap,
        ),
      ),
    );
  }
}
