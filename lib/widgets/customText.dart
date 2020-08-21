import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/responsive/sizeConfig.dart';

class CustomText extends StatelessWidget {
  String text;
  final double fontSize;
  final Color textColor;
  final FontWeight fontWeight;

  final double standardFontSize;
  final double bigFontSize;
  final double subtitleFontSize;
  final double welcomeTitleSize;

  CustomText({Key key, @required this.text, this.fontSize, this.textColor, this.fontWeight}) :
        standardFontSize =  SizeConfig.textMultiplier * 2,
        bigFontSize = SizeConfig.textMultiplier * 2.5,
        subtitleFontSize = SizeConfig.textMultiplier * 1.5,
        welcomeTitleSize =  SizeConfig.textMultiplier * 11;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.openSans(
        textStyle: TextStyle(
          fontWeight: fontWeight == null ? FontWeight.w600 : fontWeight,
            /// screen size verticle = 8.16(SizeConfig.textMultiplier = _blockSizeVertical),
            /// so 8*2 = 16, that is our font size
          fontSize: standardFontSize
          //fontSize != null ? fontSize : 16,
        ),
        color: textColor == null ? Colors.black : textColor,
      ),
    );
  }

  welcomeTitle(){
    return Text(
      text,
      style: GoogleFonts.openSans(
        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: welcomeTitleSize,
        ),
      ),
    );
  }

  bigFont(){
    return Text(
      text,
      style: GoogleFonts.openSans(
        textStyle: TextStyle(
            fontWeight: fontWeight == null ? FontWeight.w600 : fontWeight,
            fontSize: bigFontSize
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
          fontSize: standardFontSize,
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
          fontSize: subtitleFontSize,
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
          fontSize: standardFontSize,
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
          fontSize: subtitleFontSize,
        ),
      ),
    );
  }

  blueSubtitle(){
    return Text(
      text,
      style: GoogleFonts.openSans(
        textStyle: TextStyle(
          color: Colors.blue,
          fontSize: subtitleFontSize,
          fontStyle : FontStyle.italic,
        ),
      ),
    );
  }

  graySubtitleItalic(){
    return Text(
      text,
      style: GoogleFonts.openSans(
        textStyle: TextStyle(
          color: Colors.grey,
          fontSize: subtitleFontSize,
          fontStyle : FontStyle.italic,
        ),
      ),
    );
  }

  italic(){
    return Text(
      text,
      style: GoogleFonts.openSans(
        textStyle: TextStyle(
          color: textColor == null ? Colors.redAccent : textColor,
          fontSize: subtitleFontSize,
          fontStyle : FontStyle.italic,
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
          fontSize: standardFontSize,
        ),
        color: textColor == null ? Colors.black : textColor,
      ),
    );
  }
}
