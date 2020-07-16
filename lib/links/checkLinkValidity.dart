import 'package:http/http.dart' as http;

class CheckLinkValidity{

  check(String url) async{
    final response = await http.head(url);

    if(response.statusCode == 200){
      return false;
    }return true;
  }

}