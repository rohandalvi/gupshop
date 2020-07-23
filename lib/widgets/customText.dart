import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;

  const CustomText({Key key, @required this.text, this.fontSize, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.openSans(
        //inconsolata
        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: fontSize != null ? fontSize : 16,
        ),
        color: textColor == null ? Colors.black : textColor,
      ),
    );
  }


  textWithOverFlow(){
    return Text(
      text,
      style: GoogleFonts.openSans(
        //inconsolata
        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: fontSize != null ? fontSize : 16,
        ),
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  subTitle(){
    return Text(
      text,
      style: GoogleFonts.openSans(
        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  bold(){
    return Text(
      text,
      style: GoogleFonts.openSans(
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  hyperLink(){
    return Text(
      text,
      style: GoogleFonts.openSans(
        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.blue,
            decoration: TextDecoration.underline
          ///decoration: TextDecoration.underline/// this is giving an underline to Enter the link too
        )
      ),
    );
  }

  graySubtitle(){
    return Text(
      text,
      style: GoogleFonts.openSans(
        textStyle: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }

  nonBoldText(){
    return Text(
      text,
      style: GoogleFonts.openSans(
        //inconsolata
        textStyle: TextStyle(
          fontSize: fontSize != null ? fontSize : 16,
        ),
        color: textColor == null ? Colors.black : textColor,
      ),
    );
  }
}
