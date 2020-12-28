import 'package:flutter/material.dart';
import 'package:han4you/providers/settings-provider.dart';
import 'package:han4you/view/tab/agenda-tab.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'view/tab/outages-tab.dart';
import 'view/tab/settings-tab.dart';
import 'view/tab/workspaces-tab.dart';

void main() async {
  await initializeDateFormatting();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SettingsProvider())],
      child: Han4You(),
    ),
  );
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
  int _index = 0;
  final _tabs = [
    WorkspacesTab(),
    AgendaTab(),
    OutagesTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'han4you',
      theme: AppConfig.lightTheme,
      darkTheme: AppConfig.darkTheme,
      themeMode: context.watch<SettingsProvider>().themeMode,
      home: Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: _index,
            children: _tabs,
          ),
        ),
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
          currentIndex: _index,
          onTap: (int index) {
            setState(() {
              _index = index;
            });
          },
        ),
      ),
    );
  }
}
