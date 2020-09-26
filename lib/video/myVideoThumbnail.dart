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
  static String token = "token=";
  String videoURL;

  MyVideoThumbnail({this.videoURL});

  /**
   * Do not forget to add .png extension at the end of the identifier.
   * Library will not throw an explicit error but the video thumbnail would
   * not get generated and the user will keep seeing a loader.
   */
  getUniqueVideoIdentifier() {


    return videoURL.substring(videoURL.indexOf(token)+token.length)+".png";
  }

  main() async{
    final Completer<ThumbnailResult> completer = Completer();
    var dir = await getTemporaryDirectory();
    var thumbnailPath = "${dir.path}/${getUniqueVideoIdentifier()}";
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
          width: info.image.width
      ));
    }));
    return completer.future;


  }

}