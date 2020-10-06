import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';

import '../providers/auth.dart';
import './cameraScreen.dart';
import './selectCompanyPage.dart';

class AddVisitorForm extends StatefulWidget {
  static const routeName = '/registration';
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

  String dropdownValue = '', dropdownValuenumber = '0';

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
  String _phonein = '', _namein = '';

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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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
                          onSaved: (newValue) => _check['mobile'] = newValue),
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
                  TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Enter Vehicle Number',
                          isDense: true,
                          contentPadding: EdgeInsets.all(10)),
                      textInputAction: TextInputAction.next,
                      focusNode: _vehiclenode,
                      validator: (value) {
                        if (value.isEmpty)
                          return "The field cannot be empty";
                        else
                          return null;
                      },
                      onSaved: (newValue) => _check['vehicle'] = newValue),
                  SizedBox(
                    height: 0.02 * height,
                  ),
                  Row(
                    children: <Widget>[
                      Text('Select Company'),
                      _check['company'] == null
                          ? RaisedButton(
                              onPressed: () => Navigator.of(context)
                                      .pushNamed(SelectCompany.routeName,
                                          arguments: (String value) {
                                    setState(() => _check['company'] = value);
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
                          color: Colors.black,
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
