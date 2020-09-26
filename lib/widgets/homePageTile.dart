import 'package:flutter/material.dart';

class HomeTabTile extends StatelessWidget {
  final String text;
  final String imgName;
  HomeTabTile(this.text, this.imgName);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(39, 42, 54, 1),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Image.asset('assets/images/$imgName.jpg')),
          Text(text)
        ],
      ),
    );
  }
}
