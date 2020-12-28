import 'package:flutter/material.dart';
import 'package:han4you/providers/settings-provider.dart';
import 'package:han4you/view/header.dart';
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
            Provider.of<SettingsProvider>(context, listen: false)
                .setThemeMode(themeMode);
          },
          secondary: const Icon(Icons.color_lens_outlined),
        )
      ],
    );
  }
}
