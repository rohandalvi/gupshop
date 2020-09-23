import 'package:shared_preferences/shared_preferences.dart';

class UserDetails{

  Future getUserPhoneNoFuture() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userPhoneNo = prefs.getString('userPhoneNo');

    return userPhoneNo;
  }

  Future getUserNameFuture() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userName = prefs.getString('userName');

    return userName;
  }


  saveUserAsBazaarWalaInSharedPreferences(bool isBazaarWala) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isBazaarWala', isBazaarWala);
  }

  Future getIsBazaarWalaInSharedPreferences() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isBazaarWala = prefs.getBool('isBazaarWala');

    return isBazaarWala;
  }
}