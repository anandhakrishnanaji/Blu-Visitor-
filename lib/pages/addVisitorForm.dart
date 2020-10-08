import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../providers/auth.dart';
import './cameraScreen.dart';
import './selectCompanyPage.dart';
import './addPropertiesPage.dart';

class AddVisitorForm extends StatefulWidget {
  static const routeName = '/addVisitor';
  @override
  _AddVisitorFormState createState() => _AddVisitorFormState();
}

class _AddVisitorFormState extends State<AddVisitorForm> {
  CameraController controller;

  stt.SpeechToText _speech;

  final _namefocusnode = FocusNode();
  final _vehiclenode = FocusNode();
  final _form = GlobalKey<FormState>();

  String _path = null;

  bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  bool _isValid = false;

  Map<String, dynamic> _check = {
    'name': null,
    'mobile': null,
    'vehicle': null,
    'company': null,
    'companyid': null
  };

  String dropdownValuenumber = '0';

  void _saveform() {
    _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState.save();
  }

  TextEditingController _phonein, _namein, _vehiclein;

  @override
  void initState() {
    _speech = stt.SpeechToText();
    _phonein = TextEditingController();
    _namein = TextEditingController();
    _vehiclein = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phonein.dispose();
    _vehiclein.dispose();
    _namein.dispose();
    _namefocusnode.dispose();
    _vehiclenode.dispose();

    super.dispose();
  }

  bool isloading = false;

  bool _phonelisten = false, _namelisten = false, available = false;

  void _listen(bool a) async {
    print('etthi');
    bool jb = a ? _phonelisten : _namelisten;
    if (!jb) {
      available = await _speech.initialize(
        onStatus: (status) => print('Onstatus $status'),
        onError: (errorNotification) => print('OnError $errorNotification'),
      );

      if (available) {
        setState(() {
          if (a)
            _phonelisten = true;
          else
            _namelisten = true;
        });
        _speech.listen(
          onResult: (result) {
            setState(() {
              if (a)
                _phonein.text = result.recognizedWords;
              else
                _namein.text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() {
        if (a)
          _phonelisten = false;
        else
          _namelisten = false;
        _speech.stop();
      });
    }
  }

  Future<Map> _obtainUserDetails(
      String locid, String session, String tel) async {
    final url =
        'https://genapi.bluapps.in/society_v1/tel_search/$locid?session=$session&projid=$locid&tel=$tel';
    try {
      final response = await http.get(url);
      final jresponse = json.decode(response.body) as Map;
      if (jresponse['status'] == 'failed') {
        print('Number obtaining failed');
        return null;
      } else {
        if (jresponse['data']['members'].length > 0)
          return jresponse['data']['members'][0];
        else
          return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map visitDetails = ModalRoute.of(context).settings.arguments;
    final type = visitDetails['visitid'];
    final height = MediaQuery.of(context).size.height;
    final prov = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a Visitor'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 0.04 * height, vertical: 0.05 * height),
        child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 130,
                        child: Row(
                          children: <Widget>[
                            Text('Mobile'),
                            AvatarGlow(
                                glowColor: Colors.red,
                                animate: _phonelisten,
                                repeat: true,
                                endRadius: 30,
                                child: IconButton(
                                    icon: Icon(Icons.mic, color: Colors.red),
                                    onPressed: () => _listen(true))),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _phonein,
                          decoration: InputDecoration(
                              labelText: 'Enter your Mobile Number',
                              isDense: true,
                              contentPadding: EdgeInsets.all(10)),
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              _namefocusnode.requestFocus(),
                          validator: (value) {
                            if (value.isEmpty)
                              return "The field cannot be empty";
                            else if (value.length != 10)
                              return "The field must only contain 10 digits";
                            else if (!_isNumeric(value))
                              return "The field can only contain digits";
                            else
                              return null;
                          },
                          onSaved: (newValue) => _check['mobile'] = newValue,
                          onChanged: (value) async {
                            if (value.length == 10 && _isNumeric(value)) {
                              print('10 reached');
                              final udetails = await _obtainUserDetails(
                                  prov.loc_id, prov.session, value);
                              if (udetails != null) {
                                setState(() {
                                  _namein.text = udetails['visitor_name'];
                                  _check['company'] =
                                      udetails['visitor_company'];
                                  _vehiclein.text = udetails['vehicle_no'];
                                });
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.02 * height,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 130,
                        child: Row(
                          children: <Widget>[
                            Text('Name'),
                            AvatarGlow(
                                glowColor: Colors.red,
                                animate: _namelisten,
                                repeat: true,
                                endRadius: 30,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.mic,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _listen(false)))
                          ],
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _namein,
                          decoration: InputDecoration(
                              labelText: 'Enter your Name',
                              isDense: true,
                              contentPadding: EdgeInsets.all(10)),
                          textInputAction: TextInputAction.next,
                          focusNode: _namefocusnode,
                          validator: (value) => value.isEmpty
                              ? "The field cannot be empty"
                              : null,
                          onSaved: (newValue) => _check['name'] = newValue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.02 * height,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Text('Select Company'),
                          width: 130,
                        ),
                        _check['company'] == null
                            ? FlatButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Not Selected'),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                    )
                                  ],
                                ),
                                onPressed: () => Navigator.of(context)
                                        .pushNamed(SelectCompany.routeName,
                                            arguments: {
                                          'callback':
                                              (String value, String cid) {
                                            setState(() {
                                              _check['company'] = value;
                                              _check['companyid'] = cid;
                                            });
                                          },
                                          'type': type
                                        }))
                            : InkWell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(_check['company']),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                    )
                                  ],
                                ),
                                onTap: () => Navigator.of(context).pushNamed(
                                    SelectCompany.routeName,
                                    arguments: {
                                      'callback': (String value) {
                                        setState(
                                            () => _check['company'] = value);
                                      },
                                      'type': type
                                    }),
                              )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.02 * height,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Text('Vehicle Number'),
                        width: 130,
                      ),
                      Expanded(
                        child: TextFormField(
                            controller: _vehiclein,
                            decoration: InputDecoration(
                                labelText: 'Enter Vehicle Number',
                                isDense: true,
                                contentPadding: EdgeInsets.all(10)),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) =>
                                FocusScope.of(context).unfocus(),
                            focusNode: _vehiclenode,
                            onSaved: (newValue) =>
                                _check['vehicle'] = newValue),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.04 * height,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Text('Guest'),
                        width: 130,
                      ),
                      DropdownButton<String>(
                        value: dropdownValuenumber,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        //style: TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.black,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValuenumber = newValue;
                          });
                        },
                        items: <String>['0', '1', '2', 'More']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(value),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.04 * height,
                  ),
                  Row(
                    children: <Widget>[
                      _path != null
                          ? Stack(children: <Widget>[
                              Image.file(
                                File(_path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              Align(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    final String _copy = _path;
                                    setState(() => _path = null);
                                    File _file = File(_copy);
                                    _file.delete();
                                  },
                                ),
                                alignment: Alignment.topRight,
                              )
                            ])
                          : Container(
                              alignment: Alignment.center,
                              width: 130,
                              child: Icon(
                                Icons.camera_alt,
                                size: 100,
                              ),
                            ),
                      SizedBox(
                        width: 30,
                      ),
                      RaisedButton(
                          child: Text('Take Picture'),
                          onPressed: () => Navigator.of(context)
                                  .pushNamed(CameraScreen.routeName,
                                      arguments: (String pth) {
                                setState(() => _path = pth);
                              }))
                    ],
                  ),
                ],
              ),
            )),
      ),
      floatingActionButton: FloatingActionButton.extended(
          heroTag: 'flotag',
          icon: Icon(Icons.arrow_forward_ios),
          label: Text("Next"),
          onPressed: () {
            _saveform();
            if (_isValid) {
              Map udetail = new Map();
              udetail['visitor[visitType_id]']=type;
              udetail['visitor[visittype_details_id]']=_check['companyid'];
              udetail['visitor[visitor_name]']=_check['name'];
              udetail['visitor[visitType]']=visitDetails['visitype'];
              udetail['visitor[v_mobile]']=_check['mobile'];
              udetail['visitor[visitor_company]']=_check['company'];
              udetail['visitor[visitor]']='visitor';
              udetail['visitor[members]']=dropdownValuenumber;
              udetail['visitor[vehicle_no]']=_check['vehicle'];
              Navigator.of(context)
                  .pushNamed(AddProperties.routeName, arguments: udetail);
            }
          }),
    );
  }
}
