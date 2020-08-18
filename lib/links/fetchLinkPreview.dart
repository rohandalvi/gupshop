import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class FetchLinkPreviewData{

  Future<List<String>> fetch(String url, String title, String description, String image) async{
    final response = await http.get(url);
    final document = parse(response.body);



    List elements = document.getElementsByTagName('meta');

    elements.forEach((tmp) {
      if(tmp.attributes['property'] == 'og:title'){
        title = tmp.attributes['content'];
      }

      if(title == null || title.isEmpty){
        title = document.getElementsByTagName('title')[0].text;
      }

      if(tmp.attributes['property'] == 'og:description'){
        description = tmp.attributes['content'];
      }

      if(tmp.attributes['property'] == 'og:image'){
        image = tmp.attributes['content'];
        /// adding place holder when no URI host specified
      }
    });

    List<String> result = new List();

    result.add(title ?? '');
    result.add(description ?? '');
    result.add(image ?? '');
    result.add(url ?? '');

    return result;
  }
}