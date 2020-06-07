import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;

  const CustomText({Key key, @required this.text, this.fontSize});

  @override
  Widget build(BuildContext context) {
    print("text in CustomText: $text");
    return Text(
      text,
      style: GoogleFonts.openSans(
        //inconsolata
        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: fontSize != null ? fontSize : 16,
        ),
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
}
