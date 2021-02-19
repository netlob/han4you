import 'package:flutter/material.dart';
import 'package:han4you/api/graphql/graphql.dart';
import 'package:han4you/models/graphql/outage.dart';
import 'package:han4you/providers/graphql-provider.dart';
import 'package:han4you/view/generic-future-builder.dart';
import 'package:han4you/view/pages/outage-page.dart';
import 'package:provider/provider.dart';

class OutageList extends StatefulWidget {
  final String status;

  OutageList({@required this.status});

  @override
  _BuildingListState createState() => _BuildingListState();
}

class _BuildingListState extends State<OutageList> {
  Future<List<Outage>> _outagesFuture;

  @override
  void initState() {
    GraphQL graphql = context.read<GraphQLProvider>().graphql;
    _outagesFuture = graphql.fetchOutages(widget.status);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GenericFutureBuilder<List<Outage>>(
      future: _outagesFuture,
      builder: (outages) {
        return ListView.builder(
          itemCount: outages.length,
          itemBuilder: (_, index) {
            final outage = outages[index];
            final description =
                outage.description.substring(0, 50).trim() + '...';

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
      },
    );
  }
}
