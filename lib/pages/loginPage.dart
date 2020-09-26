import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import './homePage.dart';

class LoginPage extends StatefulWidget {
  static String routeName = '/loginPage';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 0.245 * width,
        child: Image.asset('assets/images/logo.png'),
      ),
    );

    final phone = TextFormField(
      keyboardType: TextInputType.phone,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'phnno'.tr(),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'passw'.tr(),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final login = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () =>
            Navigator.pushReplacementNamed(context, Home.routeName),
        padding: EdgeInsets.all(12),
        color: Colors.blueAccent[700],
        child: Text('login', style: TextStyle(color: Colors.white)).tr(),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'forgtpass',
        style: TextStyle(color: Colors.black54),
      ).tr(),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 0.058 * width, right: 0.058 * width),
          children: <Widget>[
            logo,
            SizedBox(height: 0.065 * height),
            phone,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 0.033 * height),
            login,
            forgotLabel
          ],
        ),
      ),
    );
  }
}
