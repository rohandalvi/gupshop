import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CreateRaisedButton extends StatelessWidget {
  VoidCallback onPressed;
  CreateRaisedButton({this.onPressed});

  //VerticalPadding({this.child, @required this.verticleHeight});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      color: Colors.transparent,
      splashColor: Colors.transparent,
      //highlightColor: Colors.blueGrey,
      elevation: 0,
      hoverColor: Colors.blueGrey,
      child: Text('Apply',style: GoogleFonts.openSans(
        color: Theme.of(context).primaryColor,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      )),
    );
  }
}
