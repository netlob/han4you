import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:han4you/providers/appointment-provider.dart';
import 'package:han4you/providers/date-provider.dart';
import 'package:han4you/providers/event-provider.dart';
import 'package:han4you/providers/facility-provider.dart';
import 'package:han4you/providers/group-provider.dart';
import 'package:han4you/providers/period-provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:time_machine/time_machine.dart';

import 'providers/graphql-provider.dart';
import 'providers/settings-provider.dart';
import 'providers/xedule-provider.dart';

import 'view/tabs/agenda-tab.dart';
import 'view/tabs/outages-tab.dart';
import 'view/tabs/settings-tab.dart';
import 'view/tabs/workspaces-tab.dart';

import 'utils/commons.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TimeMachine.initialize({'rootBundle': rootBundle});
  await initializeDateFormatting();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GraphQLProvider()),
        ChangeNotifierProvider(create: (_) => XeduleProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => PeriodProvider()),
        ChangeNotifierProvider(create: (_) => GroupProvider()),
        ChangeNotifierProvider(create: (_) => FacilityProvider()),
        ChangeNotifierProvider(create: (_) => DateProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
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
    bool darkTheme = context.watch<SettingsProvider>().darkTheme;

    return MaterialApp(
      title: 'han4you',
      theme: Commons.lightTheme,
      darkTheme: Commons.darkTheme,
      themeMode: darkTheme ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        body: SafeArea(child: _tabs[_index]),
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
