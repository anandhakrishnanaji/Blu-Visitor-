import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';

class Auth with ChangeNotifier {
  String _session = null;
  String _loc_id = null;
  List _iconlist = [];
  double _version = 10000;

  get session => _session;

  Future<bool> login(String mobile, String password) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final url =
        'https://genapi.bluapps.in/society/login_v3?mobile=$mobile&pass=$password&device_id=${androidInfo.androidId}&device_platform=${Platform.operatingSystem}&ver=$_version';
    try {
      final response = await http.get(url);
      final jresponse = json.decode(response.body) as Map;
      if (jresponse['status'] == 'failed')
        throw (jresponse['message']);
      else {
        _session = jresponse['data']['session_id'];
        _loc_id = jresponse['data']['loc_id'];
        await _saveToken();
        return true;
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<void> _saveToken() async {
    SharedPreferences shr = await SharedPreferences.getInstance();
    shr.setString('session', _session);
    shr.setString('loc_id', _loc_id);
  }

  Future<bool> isloggedin() async {
    SharedPreferences shr = await SharedPreferences.getInstance();
    if (shr.containsKey('session') && shr.containsKey('loc_id')) {
      _session = shr.getString('session');
      _loc_id = shr.getString('loc_id');
      final response = await http.get(
          'https://genapi.bluapps.in/society/visittype_master/$_loc_id?session=$_session');
      final jresponse = json.decode(response.body);
      if (jresponse['status'] == 'failed') {
        shr.clear();
        return false;
      } else {
        _iconlist = jresponse['data'];
        return true;
      }
    } else
      return false;
  }

  Future<List> obtainIcons() async {
    print(_iconlist == []);
    try {
      if (_iconlist.length == 0) {
        final url =
            'https://genapi.bluapps.in/society/visittype_master/$_loc_id?session=$_session';
        final response = await http.get(url);
        final jresponse = json.decode(response.body) as Map;
        print(jresponse);
        if (jresponse['status'] == 'failed') throw (jresponse['message']);
        _iconlist = jresponse['data'];
        return _iconlist;
      } else
        return _iconlist;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<void> logout() async {
    SharedPreferences shr = await SharedPreferences.getInstance();
    shr.clear();
    _session = null;
    _loc_id = null;
  }
}
