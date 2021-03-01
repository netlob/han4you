import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:han4you/models/xedule/group.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupProvider extends ChangeNotifier {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<Group> selectedGroups = [];

  GroupProvider() {
    _initGroupProvider();
  }

  void _initGroupProvider() async {
    SharedPreferences prefs = await _prefs;
    List<String> jsonGroups = prefs.getStringList('selectedGroups') ?? [];

    for (String jsonGroup in jsonGroups) {
      addSelectedGroup(Group.fromJson(jsonDecode(jsonGroup)));
    }
  }

  void addSelectedGroup(Group group) {
    group.selected = true;
    this.selectedGroups.add(group);
    notifyListeners();
  }

  void removeSelectedGroup(Group group) {
    group.selected = false;
    this.selectedGroups.removeWhere((g) => g.id == group.id);
    notifyListeners();
  }

  void save() async {
    SharedPreferences prefs = await _prefs;
    List<String> jsonGroups = [];

    for (Group group in selectedGroups) {
      jsonGroups.add(jsonEncode(group.toJson()));
    }

    prefs.setStringList('selectedGroups', jsonGroups);
  }
}
