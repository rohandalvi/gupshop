import 'package:gupshop/responsive/textConfig.dart';
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

  isBazaarwalaPromise(String bazaarwalaNumber) async{

  }


  bool isBazaarwala(String userNumber, String bazaarwalaNumber){
    if(userNumber == bazaarwalaNumber) return true;
    return false;
  }


  Future setPasscode(String passcode) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool done = await prefs.setString(TextConfig.passcode, passcode);
    print("setPasscode : $done");
  }

  Future<String> getPasscode() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String passcode = prefs.getString(TextConfig.passcode);
    print("passcode in getPasscode : $passcode");
    return passcode;
  }

  Future<String> diablePasscode() async {
    print("in diablePasscode");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(TextConfig.passcode);
  }

  Future<bool> getPasscodeStatus() async {
    String passcode = await getPasscode();
    print("passcode in getPasscodeStatus : $passcode");
    if(passcode == null) return false;
    return true;
  }

  Stream getPasscodeStatusStream(){
    Stream result = Stream.fromFuture(getPasscode());
//    Stream<String> passcode = getPasscode().asStream();
    print("passcode stream : $result");
    return result;
//    bool result;
//    if(passcode == null) result= false;
//    else result = true;
//    return result;
  }
}