import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../pages/addVisitorForm.dart';

class HomeGridTile extends StatelessWidget {
  final Map visitorType;
  HomeGridTile(this.visitorType);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(AddVisitorForm.routeName,
          arguments: {
            'visitid': visitorType['visitType_id'],
            'visitype': visitorType['name']
          }),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 25,
              backgroundImage: NetworkImage(visitorType['logo']),
            ),
            Text(
              visitorType['name'],
              style: TextStyle(fontSize: 20),
            ).tr()
          ],
        ),
      ),
    );
  }
}
