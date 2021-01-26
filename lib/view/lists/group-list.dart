import 'package:flutter/material.dart';
import 'package:han4you/api/xedule/xedule.dart';
import 'package:han4you/models/xedule/group.dart';
import 'package:han4you/providers/settings-provider.dart';
import 'package:han4you/providers/xedule-provider.dart';
import 'package:han4you/view/generic-future-builder.dart';
import 'package:provider/provider.dart';

class GroupList extends StatefulWidget {
  final String filter;

  GroupList({Key key, @required this.filter}) : super(key: key);

  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  List<Group> _filteredGroups = [];
  Future<List<Group>> _groupFuture;

  bool _groupFilter(Group group) {
    return group.code.toLowerCase().contains(widget.filter.toLowerCase());
  }

  bool _checkedFilter(Group group) {
    return group.checked;
  }

  @override
  void initState() {
    Xedule xedule = context.read<XeduleProvider>().xedule;
    _groupFuture = xedule.fetchGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = context.watch<SettingsProvider>();

    return GenericFutureBuilder<List<Group>>(
      future: _groupFuture,
      builder: (groups) {
        _filteredGroups = groups.where(_groupFilter).toList();

        return ListView.builder(
          itemCount: _filteredGroups.length,
          itemBuilder: (_, index) {
            Group group = _filteredGroups[index];

            //TODO: yucky eww code fix pls
            group.checked = settingsProvider.followingGroups.where((grp) => grp.code == group.code).length != 0;

            return CheckboxListTile(
              title: Text(group.code),
              subtitle: Text(
                'id: ${group.id} - orus: ${group.orus.join(',')}',
              ),
              value: group.checked,
              onChanged: (bool value) {
                setState(() {
                  group.checked = value;
                });

                List<Group> selected =
                    _filteredGroups.where(_checkedFilter).toList();
                settingsProvider.updateFollowingGroups(selected);
              },
            );
          },
        );
      },
    );
  }
}
