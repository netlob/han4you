import 'package:flutter/material.dart';
import 'package:han4you/providers/settings-provider.dart';
import 'package:han4you/providers/xedule-provider.dart';
import 'package:han4you/view/header.dart';
import 'package:han4you/view/lists/following-group-list.dart';
import 'package:han4you/view/pages/group-page.dart';
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
    XeduleProvider xeduleProvider = context.watch<XeduleProvider>();
    SettingsProvider settingsProvider = context.watch<SettingsProvider>();

    return Column(
      children: [
        Header(title: 'Instellingen', subtitle: 'instellingen van de app'),
        SwitchListTile(
          value: settingsProvider.darkTheme,
          title: const Text('Donker thema'),
          onChanged: (darkTheme) {
            settingsProvider.setDarkTheme(darkTheme);
            settingsProvider.save();
          },
          secondary: const Icon(Icons.color_lens_outlined),
        ),
        ListTile(
          title: Text('Beheer groepen'),
          leading: Icon(Icons.group),
          enabled: xeduleProvider.xedule.config.authenticated,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupPage(),
              ),
            );
          },
        ),
        ListTile(
          title: Text('Log uit'),
          leading: Icon(Icons.logout),
          enabled: xeduleProvider.xedule.config.authenticated,
          onTap: () {
            xeduleProvider.resetConfig();
            xeduleProvider.save();
          },
        ),
        Divider(),
        Expanded(
          child: FollowingGroupList(),
        ),
      ],
    );
  }
}
