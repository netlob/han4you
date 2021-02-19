import 'package:flutter/foundation.dart';
import 'package:han4you/models/xedule/group.dart';

class GroupProvider extends ChangeNotifier {
  List<Group> selectedGroups = [];

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
}
