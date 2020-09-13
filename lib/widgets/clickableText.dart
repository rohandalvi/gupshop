import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/widgets/customText.dart';

class ClickableText extends StatelessWidget {
  final String text;
  final GestureTapCallback onTap;
  final Widget textWidget;

  ClickableText({@required this.text, @required this.onTap, this.textWidget});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: CustomText(text: text,),
      onTap: onTap
    );
  }

  customText(){
    return InkWell(
        child: textWidget,
        onTap: onTap
    );
  }

//  richText(){
//    return TextSpan(
//      text : text,
//      style: GoogleFonts.openSans(
//        textStyle: TextStyle(
//            fontWeight: fontWeight == null ? FontWeight.w600 : fontWeight,
//            /// screen size verticle = 8.16(SizeConfig.textMultiplier = _blockSizeVertical),
//            /// so 8*2 = 16, that is our font size
//            fontSize: standardFontSize
//          //fontSize != null ? fontSize : 16,
//        ),
//        color: textColor == null ? Colors.black : textColor,
//      ),
//    );
//  }
}
