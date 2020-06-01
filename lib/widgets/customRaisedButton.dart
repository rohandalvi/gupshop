import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomRaisedButton extends StatelessWidget {
  VoidCallback onPressed;
  final Widget child;
  CustomRaisedButton({this.onPressed, this.child});

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
//      splashColor: Colors.transparent,
//      highlightColor: Colors.blueGrey,
//        highlightElevation: 8,
//      onHighlightChanged: (value){//todo - make tick button fancy
//      },
      elevation: 0,
      hoverColor: Colors.blueGrey,
      child: child
    );
  }
}

