import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:han4you/providers/appointment-provider.dart';
import 'package:han4you/providers/date-provider.dart';
import 'package:han4you/providers/facility-provider.dart';
import 'package:han4you/providers/group-provider.dart';
import 'package:han4you/providers/period-provider.dart';
import 'package:han4you/view/tabs/auth-tab.dart';
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

import 'commons.dart';

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
  XeduleProvider _xeduleProvider;
  GroupProvider _groupProvider;
  AppointmentProvider _appointmentProvider;

  int _index = 0;
  final _tabs = [
    WorkspacesTab(),
    AuthTab(),
    OutagesTab(),
    SettingsTab(),
  ];

  _replaceTab(Widget oldTab, Widget newTab, int index) {
    if (_tabs.firstWhere((t) => t.runtimeType == newTab.runtimeType, orElse: () => null) != null) {
      return;
    }

    setState(() {
      _tabs.removeWhere((t) => t.runtimeType == oldTab.runtimeType);
      _tabs.insert(index, newTab);
    });
  }

  _checkAuthenticated() {
    bool authenticated = _xeduleProvider.xedule.config.authenticated;
    bool groupsSelected = _groupProvider.selectedGroups.length > 0;

    if (authenticated && groupsSelected) {
      _replaceTab(AuthTab(), AgendaTab(), 1);
    } else {
      _replaceTab(AgendaTab(), AuthTab(), 1);
    }
  }

  @override
  void initState() {
    _xeduleProvider = context.read<XeduleProvider>();
    _appointmentProvider = context.read<AppointmentProvider>();
    _groupProvider = context.read<GroupProvider>();

    _xeduleProvider.addListener(_checkAuthenticated);
    _groupProvider.addListener(_checkAuthenticated);
    _checkAuthenticated();
    super.initState();
  }

  @override
  void dispose() {
    _xeduleProvider.removeListener(_checkAuthenticated);
    _groupProvider.removeListener(_checkAuthenticated);
    _appointmentProvider.eventStream.close();
    super.dispose();
  }

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
