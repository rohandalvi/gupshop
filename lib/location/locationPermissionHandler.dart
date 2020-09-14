import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionHandler{
  /// for bazaar:
  /// 1) Bazaar search:
  ///   - Used in BazaarIndividualCategoryListData in getListOfBazaarWalasInAGivenRadius()
  ///   - Used in changing users location for searching the bazaarwalas in
  ///     changeLocation()
  /// 2) Bazaar Onboarding :
  ///   Used in BazaarOnBoardingProfile in locationAddDisplay()
  /// 3) Individual chat:
  ///   Used in PlusButtonMessageComposerNewsSend in fifthIconAndTextOnPressed()  i.e send location icon



  permissionStatus() async{
    var permission = await Permission.location.status;
    if(permission != PermissionStatus.granted && permission != PermissionStatus.denied){
      final Map<dynamic, PermissionStatus> permissionStatus= await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.undetermined;
    } else{
      return permission;
    }
  }

  handlePermissions(BuildContext context,) async{
    PermissionStatus permission = await permissionStatus();
    /// Accessing contacts only if we have permission
    if(permission == PermissionStatus.granted){
      return true;
    } else {
      /// show dialog to permit access of contacts
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('Permissions error'),
            content: Text('Please enable location access '
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