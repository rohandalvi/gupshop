import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/customText.dart';

class CustomShowDialog{
  //final List<Widget> actions;

  //CustomShowDialog({});
//  CustomShowDialog({this.actions});

  main(BuildContext context,String text,{bool barrierDismissible}){
    print("primaryColor in main: ${Theme.of(context).primaryColor}");
    return showDialog(
      barrierDismissible: barrierDismissible,
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(text),
          content: Center(child: CircularProgressIndicator()),
          //actions: actions,
        ));
  }


  confirmation(BuildContext context,String text,{bool barrierDismissible}){
    return showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(text),
          //content: Center(child: CircularProgressIndicator()),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: CustomText(text:"YES")
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: CustomText(text:"NO"),
            ),
          ],
        ));
  }

  withActions(BuildContext context,String text,{bool barrierDismissible, List<Widget> actions, Widget content}){
    return showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(text),
          content: content,
          actions: actions,
        ));
  }

  withTextField({BuildContext context, List<Widget> actions, Widget content, String title}){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: CustomText(text: title,),
            content: content,
            actions: actions
          );
        });
  }
}