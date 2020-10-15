import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import '../widgets/alertBox.dart';

class CameraScreen extends StatefulWidget {
  static const routeName = '/cameraScreen';
  final CameraDescription camera;
  CameraScreen(this.camera);
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  String imgPath;
  bool _wait = false;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Function callback = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: imgPath != null
          ? Container(
              decoration: BoxDecoration(
              image: DecorationImage(
                  image: FileImage(File(imgPath)), fit: BoxFit.cover),
            ))
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _wait
              ? FloatingActionButton(
                  heroTag: 'first',
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    print(imgPath);
                    File _file = File(imgPath);
                    _file.delete();
                    setState(() {
                      imgPath = null;
                      _wait = false;
                    });
                  },
                )
              : SizedBox(),
          SizedBox(
            width: 30,
          ),
          FloatingActionButton(
            heroTag: 'second',
            backgroundColor: Colors.blueAccent[700],
            child: Icon(_wait ? Icons.check : Icons.camera_alt),
            onPressed: () async {
              if (_wait) {
                Navigator.pop(context);
                callback(imgPath);
              } else {
                try {
                  await _initializeControllerFuture;

                  final path = join(
                    (await getTemporaryDirectory()).path,
                    '${DateTime.now()}.png',
                  );

                  await _controller.takePicture(path);
                  setState(() {
                    imgPath = path;
                    _wait = true;
                  });
                  print('hello boi');
                } catch (e) {
                  showDialog(context: context, child: Alertbox(e.toString()));
                }
              }
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
