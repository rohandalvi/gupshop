/*
1. Get permission to access contacts using PermissionStatus
 */

import 'package:permission_handler/permission_handler.dart';


class GetContactsPermission{

  Future getPermission() async{
    var permission = await Permission.contacts.status;

    if(permission != PermissionStatus.granted && permission != PermissionStatus.denied){
      final Map<dynamic, PermissionStatus> permissionStatus= await [Permission.contacts].request();
      print("in if: ${permissionStatus[Permission.contacts] ?? PermissionStatus.undetermined}");
      return permissionStatus[Permission.contacts] ?? PermissionStatus.undetermined;
    }

    else{
      print("in else: $permission");
      return permission;
    }
  }

}