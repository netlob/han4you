import 'package:flutter/material.dart';
import 'package:han4you/api/xedule/xedule.dart';
import 'package:han4you/models/xedule/group.dart';
import 'package:han4you/providers/settings-provider.dart';
import 'package:han4you/providers/xedule-provider.dart';
import 'package:han4you/view/generic-future-builder.dart';
import 'package:provider/provider.dart';

class GroupList extends StatefulWidget {
  final String filter;

  const GroupList({Key key, @required this.filter}) : super(key: key);

  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  Future<List<Group>> _groupsFuture;

  @override
  void initState() {
    Xedule xedule = context.read<XeduleProvider>().xedule;
    _groupsFuture = xedule.fetchGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GenericFutureBuilder<List<Group>>(
      future: _groupsFuture,
      builder: (groups) {
        return ListView.builder(
          itemCount: groups.length,
          itemBuilder: (_, index) {
            Group group = groups[index];

            return CheckboxListTile(
              title: Text(group.code),
              subtitle: Text('id: ${group.id} - orus: ${group.orus.join(',')}'),
              value: group.checked,
              onChanged: (bool value) {
                group.checked = value;

                // context.read<SettingsProvider>().updateFollowingGroups(
                //     groups.where((group) => group.checked).toList());

                setState(() {});
              },
            );
          },
        );
      },
    );
  }
}
