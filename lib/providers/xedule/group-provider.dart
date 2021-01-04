import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:han4you/api/xedule/xedule.dart';
import 'package:han4you/models/xedule/group.dart';
import 'package:han4you/providers/xedule-provider.dart';
import 'package:provider/provider.dart';

List<Group> decodeListFromBody(String body) {
  final groups = jsonDecode(body);
  return groups.map<Group>((json) => Group.fromJson(json)).toList();
}

class GroupProvider extends ChangeNotifier {
  bool loading = false;
  List<Group> groups;

  void fetchGroups(BuildContext context) async {
    loading = true;

    Xedule xedule = context.read<XeduleProvider>().xedule;
    String body = await xedule.get("group");
    groups = await compute(decodeListFromBody, body);

    loading = false;
    notifyListeners();
  }
}
