import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomShowDialog{

  main(BuildContext context,String text){
    return showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(text),
          content: Center(child: CircularProgressIndicator()),
        ));
  }
}