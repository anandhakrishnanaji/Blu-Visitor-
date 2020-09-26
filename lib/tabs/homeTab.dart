import 'package:flutter/material.dart';

import '../widgets/homePageTile.dart';

class HomeTab extends StatelessWidget {
  final List<Map<String, String>> _tiles = [
    {'text': 'In Waiting', 'imgName': 'waiting'},
    {'text': 'Inside Visitor', 'imgName': 'visitor'},
    {'text': 'Search Visit', 'imgName': 'search'},
    {'text': 'Scan Meeting Code', 'imgName': 'barcode'},
    {'text': 'Staff Attendance', 'imgName': 'attendance'}
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(15),
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/flat.jpg'))),
          ),
          Expanded(
              child: GridView.builder(
                  itemCount: 5,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 0.75),
                  itemBuilder: (context, index) => HomeTabTile(
                      _tiles[index]['text'], _tiles[index]['imgName'])))
        ],
      ),
    );
  }
}
