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
    final String date = DateFormat('dd-MM-yyyy – kk:mm').format(d);
    return Container(
      child: Row(
        children: <Widget>[
          CircleAvatar(
            child: Image.asset(imguri),
          ),
          Column(
            children: <Widget>[
              Text('name'.tr() + ': $name'),
              Text('company'.tr() + ': $cname'),
              Text('mobile'.tr() + ': $mobile'),
              Text('type'.tr() + ': $type'),
              Text(date),
              Divider(),
              Align(
                child: MaterialButton(
                  onPressed: null,
                  child: Text('detail'.tr()),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
