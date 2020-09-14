import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageVideoPermissionHandler{

  /// camera
  cameraPermissionStatus() async{
    var permission = await Permission.camera.status;
    if(permission != PermissionStatus.granted && permission != PermissionStatus.denied){
      final Map<dynamic, PermissionStatus> permissionStatus= await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.undetermined;
    } else{
      return permission;
    }
  }

  handleCameraPermissions(BuildContext context,) async{
    PermissionStatus permission = await cameraPermissionStatus();
    /// Accessing contacts only if we have permission
    if(permission == PermissionStatus.granted){
      return true;
    } else {
      /// show dialog to permit access of contacts
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('Permissions error'),
            content: Text('Please enable camera access '
                'permission in system settings'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));
      return null;
    }
  }


  /// gallery
  galleryPermissionStatus() async{
    var permission = await Permission.mediaLibrary.status;
    if(permission != PermissionStatus.granted && permission != PermissionStatus.denied){
      final Map<dynamic, PermissionStatus> permissionStatus= await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.undetermined;
    } else{
      return permission;
    }
  }

  handleGalleryPermissions(BuildContext context,) async{
    PermissionStatus permission = await cameraPermissionStatus();
    /// Accessing contacts only if we have permission
    if(permission == PermissionStatus.granted){
      return true;
    } else {
      /// show dialog to permit access of contacts
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('Permissions error'),
            content: Text('Please enable gallery access '
                'permission in system settings'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));
      return null;
    }
  }
}