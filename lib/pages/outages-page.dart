import 'package:flutter/material.dart';
import 'package:han4you/components/outage-list.dart';
import 'package:han4you/components/page-header.dart';
import 'package:han4you/han-api/han-api.dart';
import 'package:han4you/han-api/models/outage.dart';

class OutagesPage extends StatefulWidget {
  @override
  _OutagesPageState createState() => _OutagesPageState();
}

class _OutagesPageState extends State<OutagesPage>
    with TickerProviderStateMixin {
  TabController _tabController;
  Future<List<Outage>> _currentOutagesFuture;
  Future<List<Outage>> _fixedOutagesFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _currentOutagesFuture = HanApi.getOutages('current');
    _fixedOutagesFuture = HanApi.getOutages('fixed');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          PageHeader(
            title: 'Storingen',
            subtitle: 'storingen van HAN systemenen',
          ),
          SizedBox(
            height: 50,
          ),
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.notifications_active_outlined,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.check,
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                OutageList(
                  outageStatus: 'current',
                ),
                OutageList(
                  outageStatus: 'fixed',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
