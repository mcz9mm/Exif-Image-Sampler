import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:exif/exif.dart';

class PhotoSamplePage extends StatefulWidget {
  @override
  _PhotoSamplePageState createState() => _PhotoSamplePageState();
}

class _PhotoSamplePageState extends State<PhotoSamplePage> {

  List<AssetEntity> _mediaList = [];
  List<AssetEntity> _filteredMediaList = [];
  var _switchValue = false;

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  void showSelectPickImage(AssetEntity data) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Select Action'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Show Exif Data'),
              onPressed: () async {
                Navigator.pop(context);
                var file = await data.file;
                final tags = await readExifFromBytes(await file.readAsBytes());
                _showExifData(tags);
              },
            ),
            CupertinoDialogAction(
              child: Text('Delete Image'),
              onPressed: () async {
                var result = await PhotoManager.editor.deleteWithIds([data.id]);
                setState(() {
                  _filteredMediaList.remove(data);
                  _mediaList.remove(data);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showExifData(Map<String, IfdTag> tags) {

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

  _fetchNewMedia() async {
    var result = await PhotoManager.requestPermission();
    if (result) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: true, type: RequestType.image);
      List<AssetEntity> media = await albums[0].getAssetListPaged(0, albums[0].assetCount);
      List<AssetEntity> filteredMedias = await _filterContainDescription(media);
      setState(() {
        _mediaList = media;
        _filteredMediaList = filteredMedias;
      });
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }

  Future<List<AssetEntity>> _filterContainDescription(List<AssetEntity> assets) async {

    List<AssetEntity> filteredMedia = [];
    await Future.forEach(assets, (element) async {
      var file = await element.file;
      final EXIF_IMAGE_DESCRIPTION = 'Image ImageDescription';
      final tags = await readExifFromBytes(await file.readAsBytes());
      var description = tags[EXIF_IMAGE_DESCRIPTION];
      if (description != null) {
        filteredMedia.add(element);
      }
    });
    return filteredMedia;
  }

  Widget _switch() {
    return Switch(
      value: _switchValue,
      onChanged: (bool value) {
        setState(() {
          _switchValue = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo List'),
        actions: [
          _switch(),
        ],
      ),
      body: GridView.builder(
          itemCount: _switchValue ? _filteredMediaList.length : _mediaList.length,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (BuildContext context, int index) {
            return FutureBuilder(
              future:  _switchValue ? _filteredMediaList[index].thumbDataWithSize(200, 200) : _mediaList[index].thumbDataWithSize(200, 200),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done)
                  return GestureDetector(
                    onTap: () async {
                      AssetEntity data = _switchValue ? _filteredMediaList[index] : _mediaList[index];
                      showSelectPickImage(data);
                    },
                    child: Image.memory(
                      snapshot.data,
                      fit: BoxFit.cover,
                    ),
                  );
                return Container();
              },
            );
          }),
    );
  }
}
