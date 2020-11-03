import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../widgets/textFieldDialog.dart';

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
      child: FloatingSearchBar(
        children: [
          MaterialButton(
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (contex) => TextFieldDialog()).then((value) {
                print(value);
                if (value != "null") {
                  print(mapinput['callback'].toString());
                  mapinput['callback'](value, "0");
                  Navigator.pop(context);
                }
              });
            },
            color: Colors.red,
            child: Text(
              'Add Company',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            minWidth: double.infinity,
          ),
          GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemCount: _filtered.length,
              itemBuilder: (BuildContext context, int index) {
                //print(index);
                return InkWell(
                  child: Container(
                    //padding: EdgeInsets.all(5),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(_filtered[index]['logo']),
                                  fit: BoxFit.contain)),
                        ),
                        Text(_filtered[index]['name']),
                      ],
                    ),
                  ),
                  onTap: () {
                    mapinput['callback'](_filtered[index]['name'],
                        _filtered[index]['visittype_details_id']);
                    Navigator.pop(context);
                  },
                );
              })
        ],
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
          hintText: "Search",
        ),
      ),
    ));
  }
}
