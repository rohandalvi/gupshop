
import 'package:flutter/material.dart';
import 'package:gupshop/service/login_auth_service.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesServiceProvider =
FutureProvider<SharedPreferencesService>((ref) async {
  return SharedPreferencesService(await SharedPreferences.getInstance());
});

class SharedPreferencesService {
  SharedPreferencesService(this.sharedPreferences);
  final SharedPreferences sharedPreferences;

  static const phoneNumber = 'phoneNumber';

  Future<void> addPhoneNumberToSharedPreferences({@required String number}) async{
    await sharedPreferences.setString(phoneNumber, number);
  }
  
  AppUser getExistingUser() {
    String number = sharedPreferences.getString(phoneNumber);
    if(number == null) return null;
    return AppUser(phoneNumber: number);
  }
}