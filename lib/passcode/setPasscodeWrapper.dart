import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/passcode/appLockMethods.dart';
import 'package:gupshop/passcode/setPasscode.dart';
import 'package:gupshop/widgets/customIconButton.dart';

class SetPasscodeWrapper extends StatelessWidget {
  final String icon;

  SetPasscodeWrapper({this.icon});

  bool passcodeSet;

  @override
  Widget build(BuildContext context) {
    print("AppLock state SetPasscodeWrapper: ${AppLock.of(context)}");
    return CustomIconButton(
      iconNameInImageFolder: icon,
      onPressed: () async{
        print("AppLock state onPressed: ${AppLock.of(context)}");
        await Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => SetPasscode(
            ),
          ),
        );

//        passcodeSet = await UserDetails().getPasscodeStatus();

//        if(passcodeSet == true){
//          print("AppLock state passcodeSet: ${AppLock.of(context)}");
//          AppLockMethods().enableAppLock(context: context);
//        }
      },
    );
  }




}
