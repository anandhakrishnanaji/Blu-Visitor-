import 'package:flutter/material.dart';

class TextFieldDialog extends StatefulWidget {
  @override
  _TextFieldDialogState createState() => _TextFieldDialogState();
}

class _TextFieldDialogState extends State<TextFieldDialog> {
  TextEditingController _con;
  bool _isError = false;
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
        decoration: InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide()),
            labelText: 'Enter the company name',
            errorText: _isError ? 'The field cannot be empty' : null,
            isDense: true,
            contentPadding: EdgeInsets.all(10)),
        controller: _con,
      )),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.pop(context, "null"),
            child: Text('Cancel')),
        FlatButton(
            onPressed: () {
              setState(() => _isError = _con.text.isEmpty);
              if (!_isError) Navigator.pop(context, _con.text);
            },
            child: Text('OK'))
      ],
    );
  }
}
