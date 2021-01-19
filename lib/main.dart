import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'providers/graphql-provider.dart';
import 'providers/settings-provider.dart';
import 'providers/xedule-provider.dart';

import 'view/tabs/agenda-tab.dart';
import 'view/tabs/outages-tab.dart';
import 'view/tabs/settings-tab.dart';
import 'view/tabs/workspaces-tab.dart';

import 'utils/commons.dart';

void main() async {
  await initializeDateFormatting();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GraphQLProvider()),
        ChangeNotifierProvider(create: (_) => XeduleProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: App(),
    ),
  );
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
      theme: Commons.lightTheme,
      darkTheme: Commons.darkTheme,
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
