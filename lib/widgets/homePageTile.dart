import 'package:flutter/material.dart';

class HomeTabTile extends StatelessWidget {
  final String text;
  final String imgName;
  HomeTabTile(this.text, this.imgName);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color.fromRGBO(39, 42, 54, 1),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/$imgName.jpg'))),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }
}
