import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomShowDialog{
  //final List<Widget> actions;

  //CustomShowDialog({});
//  CustomShowDialog({this.actions});

  main(BuildContext context,String text,{bool barrierDismissible}){
    print("in CustomShowDialog");
    return showDialog(
      barrierDismissible: barrierDismissible,
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(text),
          content: Center(child: CircularProgressIndicator()),
          //actions: actions,
        ));
  }
}