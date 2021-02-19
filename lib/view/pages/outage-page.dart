import 'package:flutter/material.dart';
import 'package:han4you/models/graphql/outage.dart';
import 'package:han4you/view/bar-button.dart';
import 'package:han4you/view/header.dart';
import 'package:url_launcher/url_launcher.dart';

class OutagePage extends StatelessWidget {
  final Outage outage;

  OutagePage({@required this.outage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: SafeArea(
        child: Column(
          children: [
            Header(
              title: 'Storing',
              subtitle: outage.title,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    outage.description.replaceAll(
                      '[â¦]',
                      '... (lees verder online)',
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        child: BarButton(
          "lees meer",
          onTap: () async {
            if (await canLaunch(outage.link)) {
              await launch(outage.link);
            }
          },
        ),
      ),
    );
  }
}
