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
  List _finalList = [], _filteredList = [], _selected = [];
  bool _didload = false;

  Future<List> _obtainFlats(
      String session, String locid, List _propertyids) async {
    String url =
        'https://genapi.bluapps.in/society_v1/get_property_flats/$locid?session=$session';
    _propertyids.forEach((element) {
      url += '&property_id[]=$element';
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

  void _buildList(String str) {
    if (str.isNotEmpty) {
      // print(str);
      int ind = 0;
      List _templist = new List();
      _finalList.forEach((element) {
        _templist.add({'name': element['name'], 'data': []});
        print(element['data']);
        element['data'].forEach((e) {
          if (e['flat_no'].toLowerCase().contains(str.toLowerCase()))
            _templist[ind]['data'].add(e);
        });
        ind++;
      });
      setState(() => _filteredList = _templist);
      //print(_templist);
    } else
      setState(() => _filteredList = _finalList);
  }

  Map userDetails;

  @override
  void didChangeDependencies() async {
    final Map arg = ModalRoute.of(context).settings.arguments;
    userDetails = arg['userdetails'];
    if (!_didload) {
      final prov = Provider.of<Auth>(context, listen: false);
      _finalList =
          await _obtainFlats(prov.session, prov.loc_id, arg['propertyids']);
      _filteredList = _finalList;
      _didload = true;
      setState(() {});
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
        onChanged: (value) => _buildList(value),
        children: _filteredList
            .map((e) => Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(5),
                      width: double.infinity,
                      child: Text(
                        e['name'],
                        style: TextStyle(fontSize: 18),
                      ),
                      decoration: BoxDecoration(color: Colors.grey[350]),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: e['data'].length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      itemBuilder: (context, index) {
                        // print(e['data']);
                        // print(index);
                        bool a = _selected.contains(e['data'][index]);
                        return InkWell(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color:
                                    a ? Colors.purple[800] : Colors.purple[200],
                                borderRadius: BorderRadius.circular(30)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                a
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      )
                                    : SizedBox(),
                                Text(
                                  e['data'][index]['flat_no'].toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            print(e['data'][index].toString());
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'prptag',
        icon: Icon(Icons.check),
        label: Text("Submit"),
        onPressed: () {
          
          _selected.forEach((element) {
            element['data'].forEach((e) {
              userDetails['visitor_flats[${e['fltypeid']}][property_id]'] =
                  e['property_id'];
              userDetails['visitor_flats[${e['fltypeid']}][building_name]'] =
                  element['name'];
              userDetails['visitor_flats[${e['fltypeid']}][wing_name]'] =
                  e['wing_name'];
              userDetails['visitor_flats[${e['fltypeid']}][fltypeid]'] =
                  e['fltypeid'];
            });
          });
        },
      ),
    );
  }
}
