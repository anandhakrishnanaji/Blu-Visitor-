import 'package:flutter/material.dart';

class Alertbox extends StatelessWidget {
  final content;
  Alertbox(this.content);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Error'),
      content: Text(content),
      actions: <Widget>[
        FlatButton(onPressed: () => Navigator.pop(context), child: Text('OK'))
      ],
    );
  }
}
