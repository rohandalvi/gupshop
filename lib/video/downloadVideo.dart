import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloadVideo{
  String videoURL;

  DownloadVideo({this.videoURL});

  downloadVideo() async{
    Dio dio = new Dio();
    var dir;
    try{
      dir = await getApplicationDocumentsDirectory();
      var result = await dio.download(videoURL, "${dir.path}/myFile.txt");
      return result;
    }catch(e){
      return null;
    }

  }
}