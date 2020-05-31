import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CreateRaisedButton extends StatelessWidget {
  VoidCallback onPressed;
  final Widget child;
  CreateRaisedButton({this.onPressed, this.child});

  //VerticalPadding({this.child, @required this.verticleHeight});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
//      shape: RoundedRectangleBorder(
//        borderRadius: new BorderRadius.circular(5.0),
//        side: BorderSide(color : Colors.black),
//      ),
      onPressed: onPressed,
      color: Colors.transparent,
      splashColor: Colors.transparent,
      //highlightColor: Colors.blueGrey,
      elevation: 0,
      hoverColor: Colors.blueGrey,
      child: child
    );
  }
}

