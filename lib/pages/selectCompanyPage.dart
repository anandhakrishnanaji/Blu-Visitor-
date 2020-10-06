import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:floating_search_bar/floating_search_bar.dart';

class SelectCompany extends StatefulWidget {
  static const routeName = '/selectCompany';
  final String type;
  SelectCompany(this.type);
  @override
  _SelectCompanyState createState() => _SelectCompanyState();
}

class _SelectCompanyState extends State<SelectCompany> {
  List<Map> _fullCompany = [], _filtered = [];

  Future<void> _obtainCompanies() async {
    final url =
        'https://genapi.bluapps.in/society/visitor_from/6?visitType_id=${widget.type}';
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

  List<Map> _buildList(String str) {
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

  @override
  void initState() {
    _obtainCompanies();
    //.then((value){setState(() {});} );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Company'),
      ),
      body: FloatingSearchBar.builder(
        itemCount: _filtered.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Image.network(_filtered[index]['logo']),
            title: Text(_filtered[index]['logo']),
            onTap: () {},
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
    );
  }
}
