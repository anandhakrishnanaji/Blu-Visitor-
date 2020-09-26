import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationTile extends StatelessWidget {
  final String title;
  final String message;
  final DateTime d;
  NotificationTile(this.title, this.message, this.d);
  @override
  Widget build(BuildContext context) {
    final String date = DateFormat('dd-MM-yyyy – kk:mm').format(d);
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[Text('msg'.tr()), Text(title), Text(message)],
            ),
            Text(date)
          ],
        ));
  }
}
