import 'package:flutter/material.dart';
import 'package:han4you/components/design/typography-design.dart';
import 'package:han4you/components/page-header.dart';
import 'package:han4you/han-api/models/han-outage.dart';
import 'package:url_launcher/url_launcher.dart';

class OutagePage extends StatelessWidget {
  final HanOutage outage;

  OutagePage({this.outage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          PageHeader(
            title: 'Storing',
            subtitle: 'storing m.b.t. ${outage.title}',
          ),
          SizedBox(
            height: 50,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  outage.description.replaceAll('[â¦]', '[...]'),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          Ink(
            color: Theme.of(context).primaryColor,
            height: 50,
            child: InkWell(
              child: Center(
                child: Text(
                  'LEES MEER',
                  style: TypographyDesign.overline.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              onTap: () async {
                if (await canLaunch(outage.link)) {
                  await launch(outage.link);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
