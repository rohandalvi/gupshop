import 'package:flutter/cupertino.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final BuildContext context;
  final Widget buttons;
  CustomSnackBar({@required this.context, @required this.buttons});

  @override
  Widget build(BuildContext context) {
    print("in customsnackbar class build");
    return snackBarWithButtons(context);
  }


  snackBarWithButtons(BuildContext context){
    print("in snackbarbutton method");
    return Flushbar(
      padding : EdgeInsets.all(10),
      borderRadius: 8,
      backgroundColor: Colors.white,
//      backgroundGradient: LinearGradient(
//        colors: [Colors.transparent, Colors.cyan],
//        stops: [0.6, 1],
//      ),
//      boxShadows: [
//        BoxShadow(
//          color: Colors.white70,
//          offset: Offset(3, 3),
//          blurRadius: 3,
//        ),
//      ],

      dismissDirection: FlushbarDismissDirection.HORIZONTAL,

      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      titleText: buttons,
      message: 'Change',

    )..show(context);
  }
}
