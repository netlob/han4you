import 'package:flutter/material.dart';
import 'package:han4you/providers/group-provider.dart';
import 'package:han4you/providers/xedule-provider.dart';
import 'package:provider/provider.dart';

import 'header.dart';
import 'pages/auth-page.dart';
import 'pages/group-page.dart';

class AuthenticationSteps extends StatelessWidget {
  void _openPage(Widget page, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final xeduleProvider = context.watch<XeduleProvider>();
    final groupProvider = context.read<GroupProvider>();

    final authenticated = xeduleProvider.xedule.config.authenticated;
    final groupsSelected = groupProvider.selectedGroups.length > 0;

    return Column(
      children: [
        Header(title: 'Agenda', subtitle: 'volg de stappen om door te gaan'),
        FractionallySizedBox(
          widthFactor: 0.75,
          child: ElevatedButton.icon(
            label: Text('Log in met HAN sso'),
            icon: Icon(Icons.login),
            onPressed:
                !authenticated ? () => _openPage(AuthPage(), context) : null,
          ),
        ),
        FractionallySizedBox(
          widthFactor: 0.75,
          child: ElevatedButton.icon(
            label: Text('Selecteer groepen'),
            icon: Icon(Icons.group),
            onPressed: (authenticated && !groupsSelected)
                ? () => _openPage(GroupPage(), context)
                : null,
          ),
        )
      ],
    );
  }
}
