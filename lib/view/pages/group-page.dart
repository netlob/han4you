import 'package:flutter/material.dart';
import 'package:han4you/view/header.dart';
import 'package:han4you/view/lists/group-list.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  String _filter = '';

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
      body: SafeArea(
        child: Column(
          children: [
            Header(
              title: 'Groepen',
              subtitle: 'selecteer je groepen',
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 15,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Zoekterm',
                  icon: Icon(Icons.search),
                ),
                onChanged: (filter) {
                  setState(() {
                    _filter = filter;
                  });
                },
              ),
            ),
            Expanded(
              child: GroupList(
                filter: _filter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
