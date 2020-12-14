import 'package:flutter/material.dart';
import 'package:han4you/components/design/typography-design.dart';
import 'package:han4you/components/pages/outage-page.dart';
import 'package:han4you/han-api/han-api.dart';
import 'package:han4you/han-api/models/han-outage.dart';

class OutageList extends StatefulWidget {
  final String outageStatus;

  OutageList({@required this.outageStatus});

  @override
  _OutageListState createState() => _OutageListState();
}

class _OutageListState extends State<OutageList> {
  Future<List<HanOutage>> _outagesFuture;

  String _getOutageText() {
    String text = widget.outageStatus == 'fixed'
        ? 'opgeloste storingen'
        : 'actieve storingen';
    return text.toUpperCase();
  }

  ListView _buildList(List<HanOutage> outages) {
    return ListView.builder(
      itemCount: outages.length,
      itemBuilder: (BuildContext ctx, int index) {
        HanOutage outage = outages[index];
        return ListTile(
          title: Text(outage.title),
          subtitle: Text('${outage.description.substring(0, 45)}...'),
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OutagePage(outage: outage),
              ),
            )
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
    return FutureBuilder<List<HanOutage>>(
      future: _outagesFuture,
      builder: (BuildContext context, AsyncSnapshot<List<HanOutage>> snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          children: [
            Container(
              height: 50,
              child: Center(
                child: Text(
                  _getOutageText(),
                  style: TypographyDesign.overline,
                ),
              ),
            ),
            Expanded(
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: _buildList(snapshot.data),
              ),
            ),
          ],
        );
      },
    );
  }
}
