import 'package:flutter/material.dart';

import '../widgets/notificationTile.dart';

class NotificationsTab extends StatelessWidget {
  final List<Map> _notifications = [
    {"title": "Flat 101", "message": "Hello World", "d": DateTime.now()},
    {"title": "Flat 101", "message": "Hello World", "d": DateTime.now()},
    {"title": "Flat 101", "message": "Hello World", "d": DateTime.now()},
    {"title": "Flat 101", "message": "Hello World", "d": DateTime.now()},
    {"title": "Flat 101", "message": "Hello World", "d": DateTime.now()},
    {"title": "Flat 101", "message": "Hello World", "d": DateTime.now()},
    {"title": "Flat 101", "message": "Hello World", "d": DateTime.now()}
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: ListView.builder(
          itemCount: 7,
          itemBuilder: (context, index) => NotificationTile(
              _notifications[index]["title"],
              _notifications[index]["message"],
              _notifications[index]["d"])),
    );
  }
}
