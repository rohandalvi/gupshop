import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClickableText extends StatelessWidget {
  final String text;
  final GestureTapCallback onTap;
  ClickableText({@required this.text, @required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        text,
        style:
        GoogleFonts.openSans(
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      onTap: onTap
    );
  }
}
