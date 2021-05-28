import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class CameraSamplePage extends StatefulWidget {
  @override
  _CameraSamplePageState createState() => _CameraSamplePageState();
}

class _CameraSamplePageState extends State<CameraSamplePage> {

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Sample'),
      ),
      body: Center(
        child: Center(
          child: _image == null
              ? Text('No image selected.')
              : Image.file(_image, fit: BoxFit.fill,),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        child: Icon(
          Icons.camera,
        ),
      ),
    );
  }
}
