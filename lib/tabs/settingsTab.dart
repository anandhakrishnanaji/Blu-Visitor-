import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsTab extends StatelessWidget {
  final List<Map> _gensettingsList = [
    {'title': 'lang', 'trailing': null, 'onTap': null},
    {'title': 'aboutblu', 'trailing': null, 'onTap': null},
    {'title': 'rate', 'trailing': null, 'onTap': null},
  ];

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
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Text(
              'gen'.tr(),
              style: TextStyle(color: Colors.grey[700], fontSize: 15),
            ),
            decoration: BoxDecoration(color: Colors.grey[350]),
          ),
          ..._gensettingsList
              .map((e) => ListTile(
                    title: Text(e['title'].tr()),
                    //leading: leading,
                    trailing: e['trailing'],
                    onTap: e['onTap'],
                  ))
              .toList(),
          SwitchListTile(
            value: true,
            //activeColor: switchActiveColor,
            onChanged: null,
            title: Text('dkth'),
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Text(
              'acc'.tr(),
              style: TextStyle(color: Colors.grey[700], fontSize: 15),
            ),
            decoration: BoxDecoration(color: Colors.grey[350]),
          ),
          ..._accsettingsList
              .map((e) => ListTile(
                    title: Text(e['title'].tr()),
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
