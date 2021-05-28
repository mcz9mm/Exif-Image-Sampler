import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:exif/exif.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:multiple_image_upload/snackbar.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

class ExifSamplePage extends StatefulWidget {
  @override
  _ExifSamplePageState createState() => _ExifSamplePageState();
}

class _ExifSamplePageState extends State<ExifSamplePage> {
  final picker = ImagePicker();
  File pickedImage;
  String pickedDate;
  TextEditingController _textFieldController = TextEditingController();
  String descriptionText;
  String inputValue;

  static const platform = const MethodChannel('mcz9mm.flutter.dev/multiple_image_upload');

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  void _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  inputValue = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(
                hintText: 'Image Description Tag:',
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () async {
                  setState(() {
                    descriptionText = inputValue;
                    Navigator.pop(context);
                  });
                  _writeExifData();
                },
              ),
            ],
          );
        });
  }

  void _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
  }

  Future _writeExifData() async {
    var uri = pickedImage.uri.toString();
    try {
        // FIXME: description value
        final Map params = <String, dynamic> {
          'description': descriptionText ?? 'TEST',
          'uri': uri,
        };
        String result = await platform.invokeMethod('writeExifData', params);
        final tags = await readExifFromBytes(await pickedImage.readAsBytes());
        print(tags);
        Snackbar().showSnackBar(context, 'Added Image Description Tag: $inputValue');
    } on PlatformException catch (e) {
      Snackbar().showSnackBar(context, 'Failed: ${e.message}');
    }
  }

  void showSelectPickImage() {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Picked Image From...'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Camera'),
              onPressed: () {
                Navigator.pop(context);
                _imagePickFromCamera();
              },
            ),
            CupertinoDialogAction(
              child: Text('Gallery'),
              onPressed: () {
                Navigator.pop(context);
                _imagePickFromGallery();
              },
            ),
          ],
        );
      },
    );
  }

  Future _saveImage() async {
    if(pickedImage != null) {
      final result = await ImageGallerySaver.saveFile(pickedImage.path);
      Snackbar().showSnackBar(context, 'Saved image: $result');
    }
  }

  void _showExifData(Map<String, IfdTag> tags) {

    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Exif Data List'),
            content: Container(
              height: 500.0, // Change as per your requirement
              width: 400.0, // Change as per your requirement
              child: Scrollbar(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: tags.length,
                  itemBuilder: (BuildContext context, int index) {
                    String key = tags.keys.elementAt(index);
                    return Column(
                      children: <Widget>[
                        Card(
                          child: ListTile(
                            title: Text('$key'),
                            subtitle: Text('${tags[key]}'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        });
  }

  void _imagePickFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      pickedImage = File(pickedFile.path);
    });
  }

  void _imagePickFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      pickedImage = File(pickedFile.path);
    });
  }

  Widget _getExifFromImage() {
    return TextButton(onPressed: () async {
      final tags = await readExifFromBytes(await pickedImage.readAsBytes());
      print(tags);
      _showExifData(tags);
    }, child: Text('SHOW'),);
  }

  Widget _saveImageButton() {
    return TextButton(onPressed: () async {
      await _saveImage();
    }, child: Text('SAVE'),);
  }

  Widget _writeExifFromImage() {
    return TextButton(onPressed: () async {
      _displayTextInputDialog(context);
    }, child: Text('WRITE EXIF'),);
  }

  Widget _imageViewer() {
    return Center(
      child: Container(
          child: pickedImage != null
            ?  Image.file(pickedImage, fit: BoxFit.fitWidth,)
            :  Text('No Image')
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Exif Sample'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            showSelectPickImage();
          },
          child: Icon(Icons.camera),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _imageViewer()),
            pickedImage != null ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getExifFromImage(),
                SizedBox(height: 16,),
                _writeExifFromImage(),
                SizedBox(height: 16,),
                _saveImageButton(),
              ],
            ) : Container(),
            SizedBox(height: 32,),
          ],
        )
    );
  }
}