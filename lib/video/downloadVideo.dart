import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloadVideo{
  String videoURL;

  DownloadVideo({this.videoURL});

  downloadVideo() async{
    Dio dio = new Dio();

    try{
      var dir = await getApplicationDocumentsDirectory();
      await dio.download(videoURL, "${dir.path}");
    }catch(e){

    }

  }
}