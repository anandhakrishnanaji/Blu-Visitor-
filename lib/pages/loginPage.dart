import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import './homePage.dart';
import '../providers/auth.dart';
import '../widgets/alertBox.dart';

class LoginPage extends StatefulWidget {
  static String routeName = '/loginPage';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _phone, _pass;
  bool _isLoading = false;
  @override
  void initState() {
    _phone = TextEditingController();
    _pass = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phone.dispose();
    _pass.dispose();
    super.dispose();
  }

  bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  bool _isValidPhone;
  bool _isValidPass;

  bool _validatePhone(String phone) {
    if (phone.length != 10) return false;
    return _isNumeric(phone);
  }

  bool _validatePassword(String pass) {
    return pass.isEmpty;
  }

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
        errorText: !_isValidPhone ? 'Invalid Phone Number' : null,
        hintText: 'phnno'.tr(),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        errorText: !_isValidPass ? 'Invalid Password' : null,
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
        onPressed: () {
          setState(() {
            _isValidPhone = _validatePhone(_phone.text);
            _isValidPass = _validatePassword(_pass.text);
          });
          if (_isValidPass && _isValidPhone) {
            setState(() => _isLoading = true);
            Provider.of<Auth>(context)
                .login(_phone.text, _pass.text)
                .then((value) {
              _isLoading = false;
              Navigator.pushReplacementNamed(context, Home.routeName);
            }).catchError((e) {
              setState(() {
                _isLoading = false;
              });
              showDialog(context: context, child: Alertbox(e.toString()));
            });
          }
        },
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
            _isLoading
                ? Padding(
                    child: CircularProgressIndicator(),
                    padding: EdgeInsets.all(15),
                  )
                : login,
            forgotLabel
          ],
        ),
      ),
    );
  }
}
