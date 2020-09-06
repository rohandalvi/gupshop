import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomRaisedButton extends StatelessWidget {
  VoidCallback onPressed;
  final Widget child;
  ShapeBorder shape;
  double minWidth;
  double height;
  CustomRaisedButton({this.onPressed, this.child, this.shape,this.minWidth, this.height});

  //VerticalPadding({this.child, @required this.verticleHeight});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: shape == null ? RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(5.0),
        side: BorderSide(color : Colors.black),
        ) : shape,
//      RoundedRectangleBorder(
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

  Widget elevated() {
    return RaisedButton(
      onPressed: onPressed,
      child: child,
    );
  }
}

