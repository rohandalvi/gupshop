import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colorPalette.dart';

class CustomTextFormField extends StatelessWidget {
  ValueChanged<String> onFieldSubmitted;
  ValueChanged<String> onChanged;
  VoidCallback onEditingComplete;
  String labelText;
  //static final formKey = new GlobalKey<FormState>();
  GlobalKey<FormState> formKeyCustomText;
  int maxLength;
  String initialValue;
  InputBorder enabledBorder;
  FormFieldSetter<String> onSaved;
  int maxLines;
  FormFieldValidator<String> valForValidator;
  String errorText;

  CustomTextFormField({this.onFieldSubmitted, this.labelText, this.formKeyCustomText, this.onChanged, this.maxLength, this.initialValue, this.enabledBorder,this.onSaved, this.maxLines, this.valForValidator, this.onEditingComplete, this.errorText});

  @override
  Widget build(BuildContext context) {
    return Form(
      key : formKeyCustomText,
      child: TextFormField(
        initialValue: initialValue,
        maxLength: maxLength,
        cursorColor: primaryColor,
        decoration: new InputDecoration(
          errorText: errorText,
          labelText: labelText,
          labelStyle: GoogleFonts.openSans(
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          focusedBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color:ourBlack ),
          ),
          enabledBorder: enabledBorder == null ?new UnderlineInputBorder(
            borderSide: new BorderSide(color: ourBlack ),
          ): enabledBorder,
        ),
        keyboardType: TextInputType.text,
        onChanged: onChanged,
        validator: valForValidator == null ? ((val) => val.isEmpty ? 'Name can\'t be empty': null) : valForValidator,
        onFieldSubmitted: onFieldSubmitted,
        onSaved: onSaved,
        maxLines: maxLines,
        onEditingComplete: onEditingComplete,
      ),
    );
  }
}
