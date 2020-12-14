import 'package:flutter/material.dart';
import 'package:han4you/components/design/color-design.dart';
import 'package:han4you/components/tab-item.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'components/tabs/agenda-tab.dart';
import 'components/tabs/outages-tab.dart';
import 'components/tabs/settings-tab.dart';
import 'components/tabs/workspaces-tab.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(Han4You()));
}

class Han4You extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return App();
  }
}

class App extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  static int activeTab = 0;

  List<Widget> _pages = [
    TabItem(tab: WorkspacesTab()),
    TabItem(tab: AgendaTab()),
    TabItem(tab: OutagesTab()),
    TabItem(tab: SettingsTab()),
  ];

  void _onTap(int index) {
    setState(() {
      activeTab = index;
    });
  }

  @override
  void initState() {
    int index = 0;
    for (TabItem page in _pages) {
      page.index = index;
      index++;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'han4you',
      theme: ThemeData(
        primaryColor: ColorDesign.primaryColor,
        accentColor: HSLColor.fromColor(ColorDesign.primaryColor)
            .withLightness(0.55)
            .toColor(),
      ),
      home: Scaffold(
        body: _pages[activeTab],
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
          currentIndex: activeTab,
          onTap: _onTap,
        ),
      ),
    );
  }
}
