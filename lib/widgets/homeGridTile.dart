import 'package:flutter/material.dart';

class HomeGridTile extends StatelessWidget {
  final String text;
  HomeGridTile(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/$text.png'),
          ),
          Text(text)
        ],
      ),
    );
  }
}
