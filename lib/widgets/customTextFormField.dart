import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colorPalette.dart';

class CustomTextFormField extends StatelessWidget {
  ValueChanged<String> onFieldSubmitted;
  ValueChanged<String> onChanged;
  String labelText;
  //static final formKey = new GlobalKey<FormState>();
  GlobalKey<FormState> formKey;
  int maxLength;

  CustomTextFormField({this.onFieldSubmitted, this.labelText, this.formKey, this.onChanged, this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Form(
      key : formKey,
      child: TextFormField(
        maxLength: maxLength,
        cursorColor: primaryColor,
        decoration: new InputDecoration(
          labelText: labelText,
          labelStyle:
          GoogleFonts.openSans(
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
//          new TextStyle(
//              color: primaryColor,
//
//          ),
          focusedBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color:ourBlack ),
          ),
          enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: ourBlack ),
          ),
        ),
        keyboardType: TextInputType.text,
        onChanged: onChanged,
        validator: (val) => val.isEmpty ? 'Name can\'t be empty' : null,
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }
}
