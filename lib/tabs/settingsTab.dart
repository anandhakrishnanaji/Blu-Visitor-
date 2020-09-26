import 'package:flutter/material.dart';

class SettingsTab extends StatelessWidget {
  final List<Map> _gensettingsList = [
    {'title': 'Language', 'trailing': null, 'onTap': null},
    {'title': 'About BluApp', 'trailing': null, 'onTap': null},
    {'title': 'Rate BluApp', 'trailing': null, 'onTap': null},
  ];

  final List<Map> _accsettingsList = [
    {'title': 'Change Password', 'trailing': null, 'onTap': null},
    {
      'title': 'Logout',
      'trailing': Icon(
        Icons.exit_to_app,
        color: Colors.red,size: 25,
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
              'General',
              style: TextStyle(color: Colors.grey[700], fontSize: 15),
            ),
            decoration: BoxDecoration(color: Colors.grey[350]),
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
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Text(
              'Account',
              style: TextStyle(color: Colors.grey[700], fontSize: 15),
            ),
            decoration: BoxDecoration(color: Colors.grey[350]),
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
