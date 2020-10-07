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

class AddVisitorForm extends StatefulWidget {
  static const routeName = '/addVisitor';
  final String type;
  AddVisitorForm(this.type);
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
    'company': null
  };

  String dropdownValuenumber = '0';

  void _saveform() {
    _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState.save();
  }

  @override
  void initState() {
    _speech = stt.SpeechToText();
    super.initState();
  }

  @override
  void dispose() {
    _namefocusnode.dispose();
    _vehiclenode.dispose();

    super.dispose();
  }

  bool isloading = false;

  bool _phonelisten = false, _namelisten = false, available = false;
  String _phonein = '', _namein = '', _vehiclein = '';

  void _listen(bool a) async {
    bool jb = a ? _phonelisten : _namelisten, available;
    if (jb) {
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
                _phonein = result.recognizedWords;
              else
                _namein = result.recognizedWords;
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
    final type = ModalRoute.of(context).settings.arguments;
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
                  Padding(
                    padding: EdgeInsets.only(bottom: 0.03 * height),
                    child: Text('Create Account',
                        style: TextStyle(fontSize: 0.035 * height)),
                  ),
                  Row(
                    children: <Widget>[
                      Text('Mobile'),
                      AvatarGlow(
                          animate: _phonelisten,
                          repeat: true,
                          endRadius: 30,
                          child: IconButton(
                              icon: Icon(Icons.mic),
                              onPressed: () => _listen(true))),
                      TextFormField(
                        initialValue: _phonein,
                        decoration: InputDecoration(
                            labelText: 'Enter your Mobile Number',
                            isDense: true,
                            contentPadding: EdgeInsets.all(10)),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => _namefocusnode.requestFocus(),
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
                            final udetails = await _obtainUserDetails(
                                prov.loc_id, prov.session, value);
                            if (udetails != null) {
                              setState(() {
                                _namein = udetails['visitor_name'];
                                _check['company'] = udetails['visitor_company'];
                                _vehiclein = udetails['vehicle_no'];
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.02 * height,
                  ),
                  Row(
                    children: <Widget>[
                      Text('Name'),
                      AvatarGlow(
                          animate: _namelisten,
                          repeat: true,
                          endRadius: 30,
                          child: IconButton(
                              icon: Icon(Icons.mic),
                              onPressed: () => _listen(false))),
                      TextFormField(
                        initialValue: _namein,
                        decoration: InputDecoration(
                            labelText: 'Enter your Name',
                            isDense: true,
                            contentPadding: EdgeInsets.all(10)),
                        textInputAction: TextInputAction.next,
                        focusNode: _namefocusnode,
                        validator: (value) =>
                            value.isEmpty ? "The field cannot be empty" : null,
                        onSaved: (newValue) => _check['name'] = newValue,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.02 * height,
                  ),
                  SizedBox(
                    height: 0.02 * height,
                  ),
                  Row(
                    children: <Widget>[
                      Text('Vehicle Number'),
                      TextFormField(
                          initialValue: _vehiclein,
                          decoration: InputDecoration(
                              labelText: 'Enter Vehicle Number',
                              isDense: true,
                              contentPadding: EdgeInsets.all(10)),
                          textInputAction: TextInputAction.next,
                          focusNode: _vehiclenode,
                          onSaved: (newValue) => _check['vehicle'] = newValue),
                    ],
                  ),
                  SizedBox(
                    height: 0.02 * height,
                  ),
                  Row(
                    children: <Widget>[
                      Text('Select Company'),
                      _check['company'] == null
                          ? RaisedButton(
                              onPressed: () => Navigator.of(context).pushNamed(
                                      SelectCompany.routeName,
                                      arguments: {
                                        'callback': (String value) {
                                          setState(
                                              () => _check['company'] = value);
                                        },
                                        'type': type
                                      }))
                          : InkWell(
                              child: Text(_check['company']),
                              onTap: () => Navigator.of(context)
                                  .pushNamed(SelectCompany.routeName,
                                      arguments: (String value) {
                                setState(() => _check['company'] = value);
                              }),
                            )
                    ],
                  ),
                  SizedBox(
                    height: 0.02 * height,
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
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 0.02 * height,
                  ),
                  Row(
                    children: <Widget>[
                      _path != null
                          ? Stack(children: <Widget>[
                              Image.file(File(_path)),
                              Container(
                                child: IconButton(
                                  icon: Icon(Icons.close),
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
                          : SizedBox(),
                      RaisedButton(
                          onPressed: () => Navigator.of(context)
                                  .pushNamed(CameraScreen.routeName,
                                      arguments: (String pth) {
                                setState(() => _path = pth);
                              }))
                    ],
                  ),
                  isloading
                      ? CircularProgressIndicator()
                      : Container(
                          color: Colors.blueAccent[700],
                          child: MaterialButton(
                            child: Text(
                              'Submit',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            onPressed: () {
                              _saveform();

                              if (_isValid) {
                                setState(() {
                                  isloading = true;
                                });
                                // Provider.of<Auth>(context, listen: false)
                                //     .register(
                                //         _check['name'],
                                //         _check['mobile'],
                                //         _check['email'],
                                //         _check['company'],
                                //         profession)
                                //     .then((value) {
                                //   if (value)
                                //     // Navigator.of(context)
                                //     //     .pushNamed(OTPVerification.routeName);
                                //   setState(() {
                                //     isloading = false;
                                //   });
                                // }).catchError((e) {
                                //   setState(() {
                                //     isloading = false;
                                //   });
                                //   showDialog(
                                //       context: context,
                                //       child: Alertbox(e.toString()));
                                // });
                              }
                            },
                          ),
                        ),
                ],
              ),
            )),
      ),
    );
  }
}
