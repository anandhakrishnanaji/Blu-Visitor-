import 'package:flutter/material.dart';

class TextFieldDialog extends StatefulWidget {
  @override
  _TextFieldDialogState createState() => _TextFieldDialogState();
}

class _TextFieldDialogState extends State<TextFieldDialog> {
  TextEditingController _con;
  @override
  void initState() {
    _con = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _con.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add a Company'),
      content: Container(
          child: TextField(
        controller: _con,
      )),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.pop(context,"null"), child: Text('Cancel')),
        FlatButton(onPressed: ()=>Navigator.pop(context,_con.text) , child: Text('OK'))
      ],
    );
  }
}
