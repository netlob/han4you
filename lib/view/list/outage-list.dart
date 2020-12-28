import 'package:flutter/material.dart';
import 'package:han4you/repository/graphql-repository.dart';
import 'package:han4you/repository/models/graphql/building.dart';
import 'package:han4you/repository/models/graphql/outage.dart';
import 'package:han4you/view/page/outage-page.dart';

class OutageList extends StatefulWidget {
  final String status;

  OutageList({@required this.status});

  @override
  _BuildingListState createState() => _BuildingListState();
}

class _BuildingListState extends State<OutageList> {
  final GraphQLRepository _repository = GraphQLRepository();
  Future _outageFuture;

  @override
  void initState() {
    _outageFuture = _repository.getOutages(widget.status);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Outage>>(
      future: _outageFuture,
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          throw snapshot.error;
          return Center(child: Text(snapshot.error.toString()));
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (_, index) {
            final outage = snapshot.data[index];

            return ListTile(
              title: Text(outage.title),
              subtitle: Text(
                outage.description.substring(0, 50).trim() + '...',
              ),
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
