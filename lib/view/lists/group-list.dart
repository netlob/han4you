import 'package:flutter/material.dart';
import 'package:han4you/models/xedule/group.dart';
import 'package:han4you/providers/xedule/xedule-provider.dart';
import 'package:han4you/providers/xedule/group-provider.dart';
import 'package:provider/provider.dart';

class GroupList extends StatefulWidget {
  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  String _filter = 'ita 1d';

  @override
  Widget build(BuildContext context) {
    final xedule = context.watch<XeduleProvider>().xedule;
    if (!xedule.config.authenticated) return Container(width: 0);

    final provider = context.watch<GroupProvider>();
    if (provider.loading) return Center(child: CircularProgressIndicator());

    return ListView.builder(
      itemCount: provider.groups.length,
      itemBuilder: (_, index) {
        final group = provider.groups[index];

        return ListTile(
          title: Text(group.code),
          subtitle: Text(group.orus.join(',')),
        );
      },
    );
  }
}
