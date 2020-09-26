import 'package:flutter/material.dart';

class SettingsTab extends StatelessWidget {
  final List<Map> _gensettingsList = [
    {'title': 'Language', 'trailing': null, 'onTap': null},
    {'title': 'About BluApp', 'trailing': null, 'onTap': null},
    {'title': 'Rate BluApp', 'trailing': null, 'onTap': null},
  ];

  final List<Map> _accsettingsList = [
    {'title': 'Change Password', 'trailing': null, 'onTap': null},
    {'title': 'Logout', 'trailing': null, 'onTap': null},
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            child: Text('General'),
            decoration: BoxDecoration(color: Colors.grey),
          ),
          ..._gensettingsList
              .map((e) => ListTile(
                    title: Text(e['title']),
                    //leading: leading,
                    trailing: e['trailing'],
                    onTap: e['onTap'],
                  ))
              .toList(),
          SwitchListTile(
            value: true,
            //activeColor: switchActiveColor,
            onChanged: null,
            title: Text('Dark Theme'),
          ),
          Container(
            child: Text('Account'),
            decoration: BoxDecoration(color: Colors.grey),
          ),
          ..._accsettingsList
              .map((e) => ListTile(
                    title: Text(e['title']),
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
