import 'package:flutter/material.dart';
import 'package:han4you/providers/settings-provider.dart';
import 'package:han4you/view/header.dart';
import 'package:han4you/view/lists/group-list.dart';
import 'package:provider/provider.dart';

class SettingsTab extends StatefulWidget {
  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(title: 'Instellingen', subtitle: 'instellingen van de app'),
        SwitchListTile(
          value: context.watch<SettingsProvider>().themeMode == ThemeMode.dark,
          title: const Text('Donker thema'),
          onChanged: (value) {
            final themeMode = value ? ThemeMode.dark : ThemeMode.light;
            context.read<SettingsProvider>().setThemeMode(themeMode);
          },
          secondary: const Icon(Icons.color_lens_outlined),
        ),
        Expanded(child: GroupList()),
      ],
    );
  }
}
