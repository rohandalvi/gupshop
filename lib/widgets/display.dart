import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gupshop/widgets/colorPalette.dart';

class Display{

  appBar(BuildContext context){
    return AppBar(
      backgroundColor: primaryColor.withOpacity(.03),
      elevation: 0,
      leading: IconButton(
          icon: SvgPicture.asset('images/backArrowColor.svg',),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
//      title: Material(
//        color: Theme.of(context).primaryColor,
//      ),
    );
  }
}