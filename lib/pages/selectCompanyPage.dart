import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class SelectCompany extends StatefulWidget {
  static const routeName = '/selectCompany';
  // final String type;
  // SelectCompany(this.type);
  @override
  _SelectCompanyState createState() => _SelectCompanyState();
}

class _SelectCompanyState extends State<SelectCompany> {
  List _fullCompany = [], _filtered = [];

  Future<void> _obtainCompanies(String locid, String type) async {
    final url =
        'https://genapi.bluapps.in/society/visitor_from/6?visitType_id=$type';
    try {
      final response = await http.get(url);
      final jresponse = json.decode(response.body) as Map;
      if (jresponse['status'] == 'failed')
        throw (jresponse['message']);
      else {
        _fullCompany = jresponse['data'];
        _filtered = _fullCompany;
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  List _buildList(String str) {
    if (str.isNotEmpty) {
      List _templist = new List();
      _fullCompany.forEach((element) {
        if (element['name'].toLowerCase().contains(str.toLowerCase()))
          _templist.add(element);
      });
      return _templist;
    } else
      return _fullCompany;
  }

  bool _didload = false;
  Map mapinput;

  @override
  void didChangeDependencies() async {
    final locid = Provider.of<Auth>(context, listen: false).loc_id;
    print(ModalRoute.of(context).settings.arguments);
    mapinput = ModalRoute.of(context).settings.arguments;
    if (!_didload) {
      await _obtainCompanies(locid, mapinput['type']);
      print(_filtered);
      _didload = true;
      setState(() {});
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(_filtered);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FloatingSearchBar.builder(
          itemCount: _filtered.length,
          itemBuilder: (BuildContext context, int index) {
            //print(index);
            return Padding(
              padding: EdgeInsets.all(5),
              child: ListTile(
                leading: Image.network(_filtered[index]['logo']),
                title: Text(_filtered[index]['name']),
                onTap: () {
                  mapinput['callback'](_filtered[index]['name']);
                  Navigator.pop(context);
                },
              ),
            );
          },
          trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => FocusScope.of(context).unfocus()),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () => Navigator.pop(context)),
          onChanged: (String value) {
            setState(() {
              _filtered = _buildList(value);
            });
          },
          decoration: InputDecoration.collapsed(
            hintText: "Search...",
          ),
        ),
      ),
    );
  }
}
