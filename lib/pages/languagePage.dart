import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguagePage extends StatefulWidget {
  static const routeName = '/languagePage';
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  int selectedRadioTile;

  @override
  void initState() {
    super.initState();
    selectedRadioTile = 0;
  }

  setSelectedRadioTile(int val, BuildContext ctx) {
    print(ctx.locale.toString());
    final List<String> j = _languages[val].split('_');
    print(j[0] + j[1]);
    setState(() {
      ctx.locale = Locale(j[0], j[1]);
      print(ctx.locale.toString());
      selectedRadioTile = val;
    });
  }

  final List _languages = [
    'en_US',
    'hi_IN',
  ];

  final Map<String, int> _langtoval = {'en_US': 0, 'hi_IN': 1};

  @override
  Widget build(BuildContext context) {
    selectedRadioTile = _langtoval[context.locale.toString()];
    return Scaffold(
        appBar: AppBar(
          title: Text('langset'.tr()),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            RadioListTile(
              value: 0,
              groupValue: selectedRadioTile,
              title: Text("English"),
              onChanged: (val) => setSelectedRadioTile(val, context),
              activeColor: Colors.blueAccent[700],
            ),
            Divider(),
            RadioListTile(
              value: 1,
              groupValue: selectedRadioTile,
              title: Text("हिंदी"),
              onChanged: (val) => setSelectedRadioTile(val, context),
              activeColor: Colors.blueAccent[700],
            ),
          ],
        ));
  }
}
