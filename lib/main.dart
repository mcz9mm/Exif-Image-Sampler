import 'package:flutter/material.dart';
import 'package:multiple_image_upload/api_sample_page.dart';
import 'package:multiple_image_upload/camera_sample_page.dart';
import 'package:multiple_image_upload/exif_sample_page.dart';
import 'package:multiple_image_upload/photo_sample_page.dart';
import 'package:multiple_image_upload/util.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key,}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Widget _cardTile(String title, Function onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          title: Text(title),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('upload image sample'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _cardTile('Photo List Sample', () {
              Navigator.of(context).push(CustomPushRouter
                  .createCustomTransitionRoutePage(PhotoSamplePage()));
            }),
            _cardTile('API Sample', () {
              Navigator.of(context).push(CustomPushRouter
                  .createCustomTransitionRoutePage(APISamplePage()));
            }),
            _cardTile('Camera Sample', () {
              Navigator.of(context).push(CustomPushRouter
                  .createCustomTransitionRoutePage(CameraSamplePage()));
            }),
            _cardTile('Exif Sample', () {
              Navigator.of(context).push(CustomPushRouter
                  .createCustomTransitionRoutePage(ExifSamplePage()));
            }),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
