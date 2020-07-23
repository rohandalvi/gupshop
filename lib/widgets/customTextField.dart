import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../colors/colorPalette.dart';

class CustomTextField extends StatelessWidget {

  ValueChanged<String> onChanged;
  String labelText;

  CustomTextField({this.onChanged, this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: primaryColor,
      decoration: new InputDecoration(
        labelText: labelText,
        labelStyle: new TextStyle(color: primaryColor ),
        focusedBorder: new UnderlineInputBorder(
          borderSide: new BorderSide(color:ourBlack ),
        ),
        enabledBorder: new UnderlineInputBorder(
          borderSide: new BorderSide(color: ourBlack ),
        ),
      ),
      keyboardType: TextInputType.text,
      onChanged: onChanged,
//          (name){
//        setState(() {
//          this.userName= name;
//        });
//      },
      // Only numbers can be entered
    );
  }
}
