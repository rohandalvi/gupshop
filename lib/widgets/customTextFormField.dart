import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colorPalette.dart';

class CustomTextFormField extends StatelessWidget {
  ValueChanged<String> onFieldSubmitted;
  ValueChanged<String> onChanged;
  String labelText;
  //static final formKey = new GlobalKey<FormState>();
  GlobalKey<FormState> formKeyCustomText;
  int maxLength;
  String initialValue;
  InputBorder enabledBorder;

  CustomTextFormField({this.onFieldSubmitted, this.labelText, this.formKeyCustomText, this.onChanged, this.maxLength, this.initialValue, this.enabledBorder});

  @override
  Widget build(BuildContext context) {
    return Form(
      key : formKeyCustomText,
      child: TextFormField(
        initialValue: initialValue,
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
          enabledBorder: enabledBorder == null ?new UnderlineInputBorder(
            borderSide: new BorderSide(color: ourBlack ),
          ): enabledBorder,
        ),
        keyboardType: TextInputType.text,
        onChanged: onChanged,
        validator: (val) => val.isEmpty ? 'Name can\'t be empty' : null,
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }
}
