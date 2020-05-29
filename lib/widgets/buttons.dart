import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Buttons{
  raisedButtonMaker(BuildContext context, dynamic action){
    return RaisedButton(
      onPressed: (){
//                            if(_galleryImage != null) image = basename(_galleryImage.path);
//                            if(_cameraImage != null) image = basename(_cameraImage.path);
       action;
      },
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