/*
1. Get permission to access contacts using PermissionStatus
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/contacts/getContactsFromUserPhone.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:permission_handler/permission_handler.dart';


class ContactsPermissionHandler{

  Future getPermission() async{
    var permission = await Permission.contacts.status;

    if(permission != PermissionStatus.granted && permission != PermissionStatus.denied){
      final Map<dynamic, PermissionStatus> permissionStatus= await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.undetermined;
    } else{
      return permission;
    }
  }

  Future<bool> handlePermissons(BuildContext context) async{
    PermissionStatus permission = await getPermission();
    /// Accessing contacts only if we have permission
    if(permission == PermissionStatus.granted){
      return true;
      //return await GetContactsFromUserPhone().getContacts();
    } else {
      /// show dialog to permit access of contacts
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(TextConfig.permissionError),
            content: Text(TextConfig.enableContactAccess),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(TextConfig.ok),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));
      return false;
    }
  }

}