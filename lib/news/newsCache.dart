import 'package:gupshop/news/newsContainerUI.dart';

class NewsCache{

  newsValidator(Map<String,NewsContainerUI> mapIsNewsGenerated, String newsId, String newsTitle, String newsLink, String newsBody){
    var newsObj;
    if(mapIsNewsGenerated[newsId] != null) {
      print("cached");
      newsObj = mapIsNewsGenerated[newsId];
    } else {
      print("not cached");
      newsObj = NewsContainerUI(title: newsTitle, link: newsLink, newsBody: newsBody);
      mapIsNewsGenerated.putIfAbsent(newsId, () => newsObj);
    }
    return mapIsNewsGenerated;
  }
}