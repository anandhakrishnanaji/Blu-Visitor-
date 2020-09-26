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
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3,vertical: 8),
                  child: Text(
                    'msg'.tr(),
                    style: TextStyle(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 17),
                  ),
                )
              ],
            ),
            Text(
              date,
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            )
          ],
        ));
  }
}
