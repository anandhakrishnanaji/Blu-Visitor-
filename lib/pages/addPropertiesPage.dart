import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../widgets/alertBox.dart';
import './addFlatsPage.dart';

class AddProperties extends StatefulWidget {
  static const routeName = '/addProperties';
  @override
  _AddPropertiesState createState() => _AddPropertiesState();
}

class _AddPropertiesState extends State<AddProperties> {
  List _finalList = [], _selected = [];
  bool _didload = false;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  Future<List> _obtainProperties(String session, String locid) async {
    final url =
        'https://genapi.bluapps.in/society/get_properties/$locid?session=$session';
    try {
      final response = await http.get(url);
      final jresponse = json.decode(response.body) as Map;
      if (jresponse['status'] == 'failed')
        throw (jresponse['message']);
      else
        return jresponse['data'];
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  void didChangeDependencies() async {
    if (!_didload) {
      final prov = Provider.of<Auth>(context, listen: false);
      _finalList = await _obtainProperties(prov.session, prov.loc_id);
      _didload = true;
      setState(() {});
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Map userDetails = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          title: Text('Select Building'),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: GridView.builder(
              itemCount: _finalList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemBuilder: (context, index) {
                bool a = _selected.contains(_finalList[index]);
                return InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        color: a ? Colors.purple[900] : Colors.purple[600],
                        borderRadius: BorderRadius.circular(40)),
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
                          _finalList[index]['building_name'],
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      if (a)
                        _selected.remove(_finalList[index]);
                      else
                        _selected.add(_finalList[index]);
                    });
                  },
                );
              }),
        ),
        floatingActionButton: FloatingActionButton.extended(
            heroTag: 'flotag',
            icon: Icon(Icons.arrow_forward_ios),
            label: Text("Next"),
            onPressed: () {
              if (_selected.length == 0) {
                _scaffoldkey.currentState.showSnackBar(SnackBar(
                    content: Text('Atleast one property must be selected!')));
              } else {
                List _propertyids = [];
                _selected.forEach((element) {
                  userDetails[
                          'property_access[${element['property_id']}][property_id]'] =
                      element['property_id'];
                  userDetails[
                          'property_access[${element['property_id']}][wing]'] =
                      element['wing_name'];
                  userDetails[
                          'property_access[${element['property_id']}][building_name]'] =
                      element['building_name'];
                  _propertyids.add(element['property_id']);
                });
                // print(_propertyids);
                Navigator.of(context).pushNamed(AddFlats.routeName, arguments: {
                  'propertyids': _propertyids,
                  'userdetails': userDetails
                });
              }
            }));
  }
}
