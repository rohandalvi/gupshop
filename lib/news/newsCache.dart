import 'package:gupshop/news/newsContainerUI.dart';

class NewsCache{

  newsValidator(Map<String,NewsContainerUI> mapIsNewsGenerated, String newsId, String newsTitle, String newsLink, String newsBody){
    var newsObj;
    if(mapIsNewsGenerated[newsId] != null) {
      newsObj = mapIsNewsGenerated[newsId];
    } else {
      newsObj = NewsContainerUI(title: newsTitle, link: newsLink, newsBody: newsBody);
      mapIsNewsGenerated.putIfAbsent(newsId, () => newsObj);
    }
    return mapIsNewsGenerated;
  }
}