import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:photo_manager/photo_manager.dart';

class APISamplePage extends StatefulWidget {
  @override
  _APISamplePageState createState() => _APISamplePageState();
}

class _APISamplePageState extends State<APISamplePage> {

  List<AssetEntity> _mediaList = [];
  List<AssetEntity> _selectMediaList = [];
  List<Uint8List> _loadThumbnailList = [];
  var isLoading = true;

  _upload(List<AssetEntity> uploadAsset) async {
    // TODO: Write API endpoint
    var uri = Uri.parse('');
    var request = http.MultipartRequest("POST", uri);
    await Future.forEach(uploadAsset, (AssetEntity element) async {
      var imageFile = await element.file;
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile('file', stream, length,
          filename: basename(imageFile.path));
      request.files.add(multipartFile);
    });
    print(request.files);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  _fetchNewMedia() async {
    var result = await PhotoManager.requestPermission();
    if (result) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: true, type: RequestType.image);
      // FIXME: fetch data pagenation
      List<AssetEntity> media = await albums[0].getAssetListPaged(0, albums[0].assetCount);
      List<Uint8List> thumbnails = [];
      await Future.forEach(media, (AssetEntity element) async {
        Uint8List thumbnail = await element.thumbDataWithSize(200, 200);
        thumbnails.add(thumbnail);
      });
      print(thumbnails);
      setState(() {
        _mediaList = media;
        _loadThumbnailList = thumbnails;
        isLoading = false;
      });
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }

  _selectList(int index) {
    var data = _mediaList[index];
    setState(() {
      if (_selectMediaList.contains(data)) {
        _selectMediaList.remove(data);
      } else {
        _selectMediaList.add(data);
      }
    });
  }

  Widget _postButton() {
    return IconButton(
      icon: Icon(Icons.send),
      onPressed: () async {
        await _upload(_selectMediaList);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Sample Page'),
        actions: [
          _selectMediaList.length > 0 ?
            _postButton() : Container(),
        ],
      ),
      body: isLoading ?
        Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)),
        ) :
        GridView.builder(
          itemCount: _loadThumbnailList.length,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (BuildContext context, int index) {
            var selected = _selectMediaList.contains(_mediaList[index]);
            return GestureDetector(
              onTap: () {
                _selectList(index);
              },
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.memory(
                      _loadThumbnailList[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                  selected ? Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      child: Icon(Icons.check_circle, color: Colors.blueAccent,),
                    ),
                  ) : Container(),
                ],
              ),
            );

            // return FutureBuilder(
            //   future:  _mediaList[index].thumbDataWithSize(200, 200),
            //   builder: (BuildContext context, snapshot) {
            //     var selected = _selectMediaList.contains(_mediaList[index]);
            //     if (snapshot.connectionState == ConnectionState.done)
            //       return GestureDetector(
            //         onTap: () {
            //           selectList(index);
            //         },
            //         child: Stack(
            //           children: [
            //             Positioned.fill(
            //               child: Image.memory(
            //                 snapshot.data,
            //                 fit: BoxFit.cover,
            //               ),
            //             ),
            //             selected ? Positioned(
            //               right: 8,
            //               bottom: 8,
            //               child: Container(
            //                 child: Icon(Icons.check_circle, color: Colors.blueAccent,),
            //               ),
            //             ) : Container(),
            //           ],
            //         ),
            //       );
            //     return Container();
            //   },
            // );
          }),
    );
  }
}
