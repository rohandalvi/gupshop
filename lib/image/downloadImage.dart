import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';

class DownloadImage{
  final String imageURL;

  DownloadImage({this.imageURL});


  download() async{
    try{
      var imageId = await ImageDownloader.downloadImage(imageURL);
      return imageId;
    }on PlatformException catch (error){
      print(error);
    }
  }

  progressIndicator(){
    return ImageDownloader.callback(
        onProgressUpdate: (String s, int i){
          CircularProgressIndicator();
        }
    );
  }
}
