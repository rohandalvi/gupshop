class VideoExtension{
  final String videoURL;
  final List<String> videoFormats = [
    '.mp4',
    'm4a',
    'm4v',
    'f4v',
    'f4a',
    'm4b',
    'm4r',
    'f4b',
    '.mov',
    '.avi',
    '.wmv',
    '.3gp',
    '3gp2',
    '3g2',
    '3gpp',
    '3gpp2',
    'ogg',
    'oga',
    'ogv',
    'ogx',
    'wmv',
    'wma',
    'asf*',
    'webm',
    '.mkv',
    '.flv',
  ];

  final String unsupportedFormat = "Unsupported Format";

  VideoExtension({this.videoURL});

  getExtension(){
    for(int i=0; i<videoFormats.length; i++){
      print("videoURL in getExtension : $videoURL");
      print("format : ${videoFormats[i]}");
      print("videoURL.contains(videoFormats[i]) : ${videoURL.contains(videoFormats[i])}");
      if(videoURL.contains(videoFormats[i])) return videoFormats[i];
    }

    throw ArgumentError(unsupportedFormat);
  }

}