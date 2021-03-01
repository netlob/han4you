import 'package:flutter/material.dart';
import 'package:han4you/models/xedule/group.dart';
import 'package:han4you/providers/group-provider.dart';
import 'package:han4you/providers/xedule-provider.dart';
import 'package:provider/provider.dart';

class FollowingGroupList extends StatefulWidget {
  @override
  _FollowingGroupListState createState() => _FollowingGroupListState();
}

class _FollowingGroupListState extends State<FollowingGroupList> {
  @override
  Widget build(BuildContext context) {
    final xeduleProvider = context.watch<XeduleProvider>();
    final groupProvider = context.watch<GroupProvider>();
    final groups = groupProvider.selectedGroups;

    if (!xeduleProvider.xedule.config.authenticated) return SizedBox.shrink();

    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (_, index) {
        Group group = groups[index];

        return Dismissible(
          key: Key(group.code),
          onDismissed: (_) {
            setState(() {
              groupProvider.removeSelectedGroup(group);
            });
          },
          child: ListTile(
            title: Text(group.code),
            subtitle: Text('id: ${group.id} - orus: ${group.orus.join(',')}'),
            dense: true,
          ),
          background: Container(
            alignment: AlignmentDirectional.centerStart,
            color: Colors.red,
            child: Padding(
              padding: EdgeInsets.only(left: 25),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          direction: DismissDirection.startToEnd,
        );
      },
    );
  }
}
