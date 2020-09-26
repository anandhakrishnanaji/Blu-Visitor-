import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../tabs/historyTab.dart';
import '../tabs/homeTab.dart';
import '../tabs/notificationsTab.dart';
import '../tabs/settingsTab.dart';
import './addVisitorType.dart';
import '../widgets/drawerTile.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  int selectedIndex = 0;
  void updateTabSelection(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> _widgets = [
    HomeTab(),
    NotificationsTab(),
    HistoryTab(),
    SettingsTab()
  ];

  final List<Map> _drawerList = [
    {
      'text': 'home',
      'icon': Icons.home,
      'ontap': (BuildContext ctx) => Navigator.pop(ctx)
    },
    {
      'text': 'staffreg',
      'icon': Icons.person_add,
      'ontap': (BuildContext ctx) => Navigator.pop(ctx)
    },
    {
      'text': 'staffup',
      'icon': Icons.update,
      'ontap': (BuildContext ctx) => Navigator.pop(ctx)
    },
    {
      'text': 'memapprove',
      'icon': Icons.check,
      'ontap': (BuildContext ctx) => Navigator.pop(ctx)
    },
    {
      'text': 'complaint',
      'icon': Icons.warning,
      'ontap': (BuildContext ctx) => Navigator.pop(ctx)
    },
    {
      'text': 'logout',
      'icon': Icons.exit_to_app,
      'ontap': (BuildContext ctx) => Navigator.pop(ctx)
    },
  ];
  final List<String> title = ['home', 'notifications', 'history', 'settings'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title[selectedIndex]).tr(),
      ),
      body: _widgets[selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(VisitorType.routeName),
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Icon(Icons.add),
        ),
        elevation: 4.0,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          margin: EdgeInsets.only(left: 12.0, right: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  updateTabSelection(0);
                },
                iconSize: 27.0,
                icon: Icon(
                  Icons.home,
                  color: selectedIndex == 0
                      ? Colors.blueAccent[700]
                      : Colors.grey.shade400,
                ),
              ),
              IconButton(
                onPressed: () {
                  updateTabSelection(1);
                },
                iconSize: 27.0,
                icon: Icon(
                  Icons.notifications,
                  color: selectedIndex == 1
                      ? Colors.blueAccent[700]
                      : Colors.grey.shade400,
                ),
              ),
              SizedBox(
                width: 50.0,
              ),
              IconButton(
                onPressed: () {
                  updateTabSelection(2);
                },
                iconSize: 27.0,
                icon: Icon(
                  Icons.history,
                  color: selectedIndex == 2
                      ? Colors.blueAccent[700]
                      : Colors.grey.shade400,
                ),
              ),
              IconButton(
                onPressed: () {
                  updateTabSelection(3);
                },
                iconSize: 27.0,
                icon: Icon(
                  Icons.settings,
                  color: selectedIndex == 3
                      ? Colors.blueAccent[700]
                      : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
        shape: CircularNotchedRectangle(),
      ),
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
          color: Colors.blue[200],
          child: Column(
            children: _drawerList
                .map((e) => DrawerTile(e['text'], e['icon'], e['ontap']))
                .toList(),
          ),
        ),
      ),
    );
  }
}
