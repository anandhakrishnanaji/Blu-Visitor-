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

  List<Map> _selected = [];

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Building'),
        actions: <Widget>[
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[Text('Next'), Icon(Icons.navigate_next)],
              ),
            ),
            onTap: () {
              List _propertyids = [];
              _selected.forEach(
                  (element) => _propertyids.add(element['property_id']));
              Navigator.of(context)
                  .pushNamed(AddFlats.routeName, arguments: _propertyids);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _obtainProperties(prov.session, prov.loc_id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          else if (snapshot.hasError) {
            Future.delayed(
                Duration.zero,
                () => showDialog(
                    context: context,
                    child: Alertbox(snapshot.error.toString())));
            return SizedBox();
          } else
            return GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (context, index) {
                  bool a = _selected.contains(snapshot.data[index]);
                  return InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          color: a ? Colors.blue[900] : Colors.blueAccent[700],
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        children: <Widget>[
                          a
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : SizedBox(),
                          snapshot.data[index]['building_name']
                        ],
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        if (a)
                          _selected.remove(snapshot.data[index]);
                        else
                          _selected.add(snapshot.data[index]);
                      });
                    },
                  );
                });
        },
      ),
    );
  }
}
