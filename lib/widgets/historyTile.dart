import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';

class HistoryTile extends StatelessWidget {
  final String name;
  final String cname;
  final String mobile;
  final String type;
  final String imguri;
  final DateTime d;
  HistoryTile(
      this.name, this.cname, this.mobile, this.type, this.imguri, this.d);
  @override
  Widget build(BuildContext context) {
    final String date = DateFormat('dd-MM-yyyy   kk:mm').format(d);
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(8),
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(imguri),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'name'.tr() + ':  $name',
                style: TextStyle(fontSize: 15),
              ),
              Text(
                'company'.tr() + ':  $cname',
                style: TextStyle(fontSize: 15),
              ),
              Text(
                'mobile'.tr() + ':  $mobile',
                style: TextStyle(fontSize: 15),
              ),
              Text(
                'type'.tr() + ':  $type',
                style: TextStyle(fontSize: 16),
              ),
              Text(date, style: TextStyle(color: Colors.grey[600])),
              Align(
                child: MaterialButton(
                  color: Colors.blueAccent[700],
                  onPressed: () {},
                  child: Text(
                    'detail'.tr(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
