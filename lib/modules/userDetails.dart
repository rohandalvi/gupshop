import 'package:shared_preferences/shared_preferences.dart';

class UserDetails{

  Future getUserPhoneNoFuture() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userPhoneNo = prefs.getString('userPhoneNo');

    print("userPhoneNo in Profile Picture: $userPhoneNo");
    print("prefs: ${prefs.getString('userPhoneNo')}");
    return userPhoneNo;
  }

  Future getUserNameFuture() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userName = prefs.getString('userName');

    print("userName in Profile Picture: $userName");
    print("prefs: $prefs");
    return userName;
  }



}