import 'package:dio/dio.dart';
import 'package:gupshop/video/videoExtension.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';

class DownloadVideo{
  String videoURL;

  DownloadVideo({this.videoURL});

  downloadAndGetTempPath(var fileName) async{
    Dio dio = new Dio();
    var dir;
    try{
      dir = await getApplicationDocumentsDirectory();
//      print("dir.path : ${dir.path}");
      var path = "${dir.path}/$fileName";
      var result = await dio.download(videoURL, path);

//      print("path in download video : ${path}");
      return path;
    }catch(e){
//      print("exception thrown in download video : ${e}");
      // add metric to denote failure downloading video
      return null;
    }
  }

  downloadVideo() async{
    String fileName;
    fileName = VideoExtension(videoURL: videoURL).getExtension();
//    print("fileName outside: $fileName");
    try {
      fileName = "xyz" + VideoExtension(videoURL: videoURL).getExtension();
//      print("fileName : $fileName");
      var path = await downloadAndGetTempPath(fileName);
      if (path != null) {
        bool success = await GallerySaver.saveVideo(path);
//        print("success : $success");
        return success;
      } else {
//        print("in downloadVideo else");
        return null;
      }
    }catch(e){
//      print("in downloadVideo catch");
      return null;
    }


    //var fileName  = "xy.mp4";


//    try{
//      result = await GallerySaver.saveVideo(videoURL);
//      //print("result in downloadVideo :  $result");
//      return result;
//    }catch(e){
//      //print("result in catch");
//      return null;
//    }


  }
}