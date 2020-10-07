import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:floating_search_bar/floating_search_bar.dart';

import '../providers/auth.dart';

class AddFlats extends StatefulWidget {
  // final List _propertyids;
  // AddFlats(this._propertyids);
  static const routeName = '/addFlats';
  @override
  _AddFlatsState createState() => _AddFlatsState();
}

class _AddFlatsState extends State<AddFlats> {
  List _finalList = [], _filteredList = [], _selected;
  bool _didload = false;

  Future<List> _obtainFlats(
      String session, String locid, List _propertyids) async {
    String url =
        'https://genapi.bluapps.in/society_v1/get_property_flats/$locid&session=$session';
    _propertyids.forEach((element) {
      url += '&property_id[]=${element['property_id']}';
    });
    try {
      final response = await http.get(url);
      final jresponse = json.decode(response.body) as Map;
      if (jresponse['status'] == 'failed')
        throw (jresponse['message']);
      else {
        List _mainList = [];
        jresponse['data'].forEach((element) {
          _mainList.add({'name': element[0]['building_name'], 'data': element});
        });
        return _mainList;
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  List<Map> _buildList(String str) {
    if (str.isNotEmpty) {
      int ind = 0;
      List _templist = new List();
      _finalList.forEach((element) {
        _templist.add({'name': element['name'], 'data': []});
        element['data'].forEach((e) {
          if (e['flat_no'].toLowerCase().contains(str.toLowerCase()))
            _templist[ind]['data'].add(element);
        });
        ind++;
      });
      return _templist;
    } else
      return _finalList;
  }

  @override
  void didChangeDependencies() async {
    final List flats = ModalRoute.of(context).settings.arguments;
    if (!_didload) {
      final prov = Provider.of<Auth>(context, listen: false);
      _finalList = await _obtainFlats(prov.session, prov.loc_id, flats);
      _filteredList = _finalList;
      _didload = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Select Flats'),
          centerTitle: true,
        ),
        body: FloatingSearchBar(
          onChanged: (value) {
            setState(() {
              _filteredList = _buildList(value);
            });
          },
          children: _filteredList
              .map((e) => Column(
                    children: <Widget>[
                      Text(e['name']),
                      GridView.builder(
                        itemCount: e['data'].length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.75,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        itemBuilder: (context, index) {
                          bool a = _selected.contains(e['data'][index]);
                          return InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: a
                                      ? Colors.blue[900]
                                      : Colors.blueAccent[700],
                                  borderRadius: BorderRadius.circular(30)),
                              child: Row(
                                children: <Widget>[
                                  a
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        )
                                      : SizedBox(),
                                  e['data'][index]['flat_no']
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                if (a)
                                  _selected.remove(e['data'][index]);
                                else
                                  _selected.add(e['data'][index]);
                              });
                            },
                          );
                        },
                      )
                    ],
                  ))
              .toList(),
        ));
  }
}
