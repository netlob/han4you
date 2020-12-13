import 'package:flutter/material.dart';
import 'package:han4you/han-api/han-api.dart';
import 'package:han4you/han-api/models/outage.dart';

class OutageList extends StatefulWidget {
  final String outageStatus;

  OutageList({@required this.outageStatus});

  @override
  _OutageListState createState() => _OutageListState();
}

class _OutageListState extends State<OutageList> {
  Future<List<Outage>> _outagesFuture;

  ListView _buildList(List<Outage> outages) {
    return ListView.builder(
      itemCount: outages.length,
      itemBuilder: (BuildContext ctx, int index) {
        Outage outage = outages[index];
        return ListTile(
          title: Text(outage.title),
          subtitle: Text('${outage.description.substring(0, 45)}...'),
          onTap: () => {
            //TODO: Show actual outage
            throw UnimplementedError()
          },
        );
      },
    );
  }

  @override
  void initState() {
    _outagesFuture = HanApi.getOutages(widget.outageStatus);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Outage>>(
      future: _outagesFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Outage>> snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: _buildList(snapshot.data),
        );
      },
    );
  }
}
