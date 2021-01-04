import 'package:flutter/material.dart';
import 'package:han4you/providers/graphql/outage-provider.dart';
import 'package:han4you/view/pages/outage-page.dart';
import 'package:provider/provider.dart';

class OutageList extends StatefulWidget {
  final String status;

  OutageList({@required this.status});

  @override
  _BuildingListState createState() => _BuildingListState();
}

class _BuildingListState extends State<OutageList> {
  @override
  void initState() {
    context.read<OutageProvider>().fetchOutages(widget.status);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OutageProvider>();
    if (provider.loading) return Center(child: CircularProgressIndicator());

    final outages = provider.outages[widget.status];
    return ListView.builder(
      itemCount: outages.length,
      itemBuilder: (_, index) {
        final outage = outages[index];
        final description = outage.description.substring(0, 50).trim() + '...';

        return ListTile(
          title: Text(outage.title),
          subtitle: Text(description),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OutagePage(outage: outage),
              ),
            );
          },
        );
      },
    );
  }
}
