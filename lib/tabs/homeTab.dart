import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../widgets/homePageTile.dart';

class HomeTab extends StatelessWidget {
  final List<Map<String, String>> _tiles = [
    {'text': 'inwait', 'imgName': 'waiting'},
    {'text': 'invisit', 'imgName': 'visitor'},
    {'text': 'svisit', 'imgName': 'search'},
    {'text': 'scanmeetcode', 'imgName': 'barcode'},
    {'text': 'staffatt', 'imgName': 'attendance'}
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(15),
            height: 0.273 * height,
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
                      _tiles[index]['text'].tr(), _tiles[index]['imgName'])))
        ],
      ),
    );
  }
}
