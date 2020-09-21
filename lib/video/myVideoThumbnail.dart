import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class ThumbnailResult {
  final Image image;
  final int dataSize;
  final int height;
  final int width;
  const ThumbnailResult({this.image, this.dataSize, this.height, this.width});
}

class MyVideoThumbnail{
  String videoURL;

  MyVideoThumbnail({this.videoURL});

  getUniqueIdentifierFromVideoUrl() {
    print("URL $videoURL");
    String videoId = videoURL.substring(videoURL.indexOf(".com")+5).split("/")[4];
    String  hashedId  = videoId.substring(0, videoId.indexOf("?"));
    String hash = "video%2F";
    return hashedId.substring(hashedId.indexOf(hash)+hash.length, hashedId.indexOf("."))+".png";
  }

  main() async{
    final Completer<ThumbnailResult> completer = Completer();
    var dir = await getTemporaryDirectory();
    var thumbnailPath = "${dir.path}/${getUniqueIdentifierFromVideoUrl()}";
    Uint8List bytes;
    try {
      final file = File(thumbnailPath);
      bytes = file.readAsBytesSync();
    } catch(IllegalArgumentException) {
      print("Caught video exception $thumbnailPath");
      await VideoThumbnail.thumbnailFile(
          video: videoURL,
          thumbnailPath: thumbnailPath ,
          quality: 5
      );
      final file = File(thumbnailPath);
      bytes = file.readAsBytesSync();
    }

    int _imageDataSize = bytes.length;
    final _image = Image.memory(bytes);
    _image.image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(ThumbnailResult(
        image: _image,
        dataSize: _imageDataSize,
        height: info.image.height,
        width: info.image.width,
      ));
    }));
    return completer.future;
  }

}