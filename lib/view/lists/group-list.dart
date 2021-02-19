import 'package:flutter/material.dart';
import 'package:han4you/models/xedule/group.dart';
import 'package:han4you/providers/group-provider.dart';
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

  @override
  void initState() {
    XeduleProvider xeduleProvider = context.read<XeduleProvider>();
    _groupFuture = xeduleProvider.xedule.fetchGroups();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GroupProvider groupProvider = context.watch<GroupProvider>();
    List<Group> selectedGroups = groupProvider.selectedGroups;

    return GenericFutureBuilder<List<Group>>(
      future: _groupFuture,
      builder: (groups) {
        _filteredGroups = groups.where(_groupFilter).toList();

        return ListView.builder(
          itemCount: _filteredGroups.length,
          itemBuilder: (_, index) {
            Group group = _filteredGroups[index];
            bool selected =
                selectedGroups.where((g) => g.id == group.id).length != 0;

            return CheckboxListTile(
              title: Text(group.code),
              subtitle: Text(
                'id: ${group.id} - orus: ${group.orus.join(',')}',
              ),
              value: selected,
              onChanged: (bool selected) {
                if (selected) {
                  groupProvider.addSelectedGroup(group);
                } else {
                  groupProvider.removeSelectedGroup(group);
                }
              },
            );
          },
        );
      },
    );
  }
}
