import 'package:flutter/material.dart';

import '../widgets/historyTile.dart';

class HistoryTab extends StatelessWidget {
  final List<Map> _history = [
    {
      "name": "Beatrice",
      "cname": "Ford",
      "mobile": "4356789",
      "type": "Visitor",
      "date": DateTime.now(),
      "imguri": "assets/images/user.png"
    },
    {
      "name": "Beatrice",
      "cname": "Ford",
      "mobile": "4356789",
      "type": "Visitor",
      "date": DateTime.now(),
      "imguri": "assets/images/user.png"
    },
    {
      "name": "Beatrice",
      "cname": "Ford",
      "mobile": "4356789",
      "type": "Visitor",
      "date": DateTime.now(),
      "imguri": "assets/images/user.png"
    },
    {
      "name": "Beatrice",
      "cname": "Ford",
      "mobile": "4356789",
      "type": "Visitor",
      "date": DateTime.now(),
      "imguri": "assets/images/user.png"
    },
    {
      "name": "Beatrice",
      "cname": "Ford",
      "mobile": "4356789",
      "type": "Visitor",
      "date": DateTime.now(),
      "imguri": "assets/images/user.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => HistoryTile(
              _history[index]['name'],
              _history[index]['cname'],
              _history[index]['mobile'],
              _history[index]['type'],
              _history[index]['imguri'],
              _history[index]['date'])),
    );
  }
}
