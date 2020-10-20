import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

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

  stt.SpeechToText _speech, _speech1;

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
    'vehicle': "",
    'company': "",
    'companyid': ""
  };

  String dropdownValuenumber = 'Not Selected';

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
    _speech1 = stt.SpeechToText();
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

  bool _phonelisten = false,
      _namelisten = false,
      available = false,
      _complisten = false;

  void _listen(bool a) async {
    // print('etthi');
    bool jb = a ? _phonelisten : _namelisten;
    if (!jb) {
      available = await _speech.initialize(
        onStatus: (status) => print('Onstatus $status'),
        onError: (errorNotification) => print('OnError $errorNotification'),
      );

      if (available) {
        setState(() {
          if (a) {
            _namelisten = false;
            _phonelisten = true;
          } else {
            _phonelisten = false;
            _namelisten = true;
          }
        });
        _speech.listen(
          onResult: (result) {
            setState(() {
              if (a) {
                if (_isNumeric(result.recognizedWords))
                  _phonein.text = result.recognizedWords;
              } else
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

  void _listencomp() async {
    if (!_complisten) {
      available = await _speech1.initialize(
        onStatus: (status) => print('Onstatus $status'),
        onError: (errorNotification) => print('OnError $errorNotification'),
      );
      if (available) {
        setState(() {
          _complisten = true;
        });
        _speech.listen(
          onResult: (result) {
            setState(() {
              _check["company"] = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() {
        _complisten = false;
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

  bool _isloaded = false;
  String type;
  @override
  Widget build(BuildContext context) {
    final Map visitDetails = ModalRoute.of(context).settings.arguments;
    if (!_isloaded) {
      type = visitDetails['visitid'];
      _isloaded = true;
    }
    final height = MediaQuery.of(context).size.height;
    final prov = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a Visitor'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 0.03 * height, vertical: 0.03 * height),
        child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: prov.iconlist
                          .map<Widget>((e) => InkWell(
                                onTap: () =>
                                    setState(() => type = e['visitType_id']),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: e['visitType_id'] == type
                                        ? Colors.blue[900]
                                        : Colors.white,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Image.network(
                                        e['logo'],
                                        height: 71,
                                        width: 71,
                                      ),
                                      Text(e['name'],
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: e['visitType_id'] == type
                                                ? Colors.white
                                                : Colors.black,
                                          ))
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 115,
                        child: Row(
                          children: <Widget>[
                            Text('Mobile'),
                            AvatarGlow(
                                glowColor:
                                    _phonelisten ? Colors.blue : Colors.red,
                                animate: _phonelisten,
                                repeat: true,
                                endRadius: 30,
                                child: IconButton(
                                    icon: Icon(Icons.mic,
                                        color: _phonelisten
                                            ? Colors.blue
                                            : Colors.red),
                                    onPressed: () => _listen(true))),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          controller: _phonein,
                          decoration: InputDecoration(
                              border:
                                  OutlineInputBorder(borderSide: BorderSide()),
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
                        width: 115,
                        child: Row(
                          children: <Widget>[
                            Text('Name'),
                            AvatarGlow(
                                glowColor:
                                    _namelisten ? Colors.blue : Colors.red,
                                animate: _namelisten,
                                repeat: true,
                                endRadius: 30,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.mic,
                                      color: _namelisten
                                          ? Colors.blue
                                          : Colors.red,
                                    ),
                                    onPressed: () => _listen(false)))
                          ],
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _namein,
                          decoration: InputDecoration(
                              border:
                                  OutlineInputBorder(borderSide: BorderSide()),
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
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Text('Company'),
                              AvatarGlow(
                                  glowColor:
                                      _complisten ? Colors.blue : Colors.red,
                                  animate: _complisten,
                                  repeat: true,
                                  endRadius: 30,
                                  child: IconButton(
                                      icon: Icon(Icons.mic,
                                          color: _complisten
                                              ? Colors.blue
                                              : Colors.red),
                                      onPressed: () => _listencomp()))
                            ],
                          ),
                          width: 115,
                        ),
                        _check['company'] == ""
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
                                onPressed: () {
                                  print(type);
                                  if (type == '4') return;
                                  Navigator.of(context).pushNamed(
                                      SelectCompany.routeName,
                                      arguments: {
                                        'callback': (String value, String cid) {
                                          print('hello');
                                          setState(() {
                                            _check['company'] = value;
                                            _check['companyid'] = cid;
                                          });
                                        },
                                        'type': type
                                      });
                                })
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
                                      'callback': (String value, String cid) {
                                        print('hello');
                                        setState(() {
                                          _check['company'] = value;
                                          _check['companyid'] = cid;
                                        });
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
                        width: 115,
                      ),
                      Expanded(
                        child: TextFormField(
                            controller: _vehiclein,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide()),
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
                        child: Text('No. of Person'),
                        width: 115,
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
                        items: <String>['Not Selected', '0', '1', '2', 'More']
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
                      RaisedButton(
                          child: Text('Take Picture'),
                          onPressed: () => Navigator.of(context)
                                  .pushNamed(CameraScreen.routeName,
                                      arguments: (String pth) {
                                setState(() => _path = pth);
                              })),
                      SizedBox(
                        width: 30,
                      ),
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
                              width: 115,
                              child: Icon(
                                Icons.camera_alt,
                                size: 100,
                              ),
                            ),
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
              udetail['visitor[visitType_id]'] = type;
              udetail['visitor[visittype_details_id]'] = _check['companyid'];
              udetail['visitor[visitor_name]'] = _check['name'];
              udetail['visitor[visitType]'] = visitDetails['visitype'];
              udetail['visitor[v_mobile]'] = _check['mobile'];
              udetail['visitor[visitor_company]'] = _check['company'];
              udetail['visitor[visitor]'] = 'visitor';
              udetail['visitor[members]'] =
                  dropdownValuenumber == "Not Selected"
                      ? ""
                      : dropdownValuenumber;
              udetail['visitor[vehicle_no]'] = _check['vehicle'];
              Navigator.of(context)
                  .pushNamed(AddProperties.routeName, arguments: udetail);
            }
          }),
    );
  }
}
