import 'package:flutter/material.dart';
import 'package:han4you/main.dart';

// ignore: must_be_immutable
class TabItem extends StatelessWidget {
  final Widget tab;
  int index;

  TabItem({@required this.tab, this.index});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: AppState.activeTab == index,
      maintainState: true,
      child: tab,
    );
  }
}
