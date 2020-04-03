import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionService{


  Future<bool> requestPermission() async{
    Future<PermissionStatus> contactsPermissionRequest = Permission.contacts.request();
    contactsPermissionRequest.then((value)
      {
        if(value.isGranted) {
        print("Granted request");
      } else if(value.isDenied) {
        print("Denied request");
      }

      },
    );
  }
}