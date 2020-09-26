import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../pages/languagePage.dart';

class SettingsTab extends StatelessWidget {
  final Map<String, String> _trailingLanguage = {
    "en_US": "English",
    "hi_IN": "हिंदी"
  };

  final List<Map> _accsettingsList = [
    {'title': 'cp', 'trailing': null, 'onTap': null},
    {
      'title': 'logout',
      'trailing': Icon(
        Icons.exit_to_app,
        color: Colors.red,
        size: 25,
      ),
      'onTap': null
    },
  ];

  @override
  Widget build(BuildContext context) {
    final List<Map> _gensettingsList = [
      {
        'title': 'lang',
        'trailing': Text(
          _trailingLanguage[context.locale.toString()],
          style: TextStyle(color: Colors.grey[600], fontSize: 18),
        ),
        'onTap': (BuildContext ctx) =>
            Navigator.of(context).pushNamed(LanguagePage.routeName)
      },
      {
        'title': 'aboutblu',
        'trailing': null,
        'onTap': (BuildContext ctx) => null
      },
      {'title': 'rate', 'trailing': null, 'onTap': (BuildContext ctx) => null},
    ];
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Text(
              'gen',
              style: TextStyle(color: Colors.grey[700], fontSize: 15),
            ).tr(),
            decoration: BoxDecoration(color: Colors.grey[350]),
          ),
          ..._gensettingsList
              .map((e) => ListTile(
                    title: Text(e['title']).tr(),
                    //leading: leading,
                    trailing: e['trailing'],
                    onTap: () => e['onTap'](context),
                  ))
              .toList(),
          SwitchListTile(
            value: true,
            //activeColor: switchActiveColor,
            onChanged: null,
            title: Text('dkth').tr(),
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Text(
              'acc',
              style: TextStyle(color: Colors.grey[700], fontSize: 15),
            ).tr(),
            decoration: BoxDecoration(color: Colors.grey[350]),
          ),
          ..._accsettingsList
              .map((e) => ListTile(
                    title: Text(e['title']).tr(),
                    //leading: leading,
                    trailing: e['trailing'],
                    onTap: e['onTap'],
                  ))
              .toList()
        ],
      ),
    );
  }
}
