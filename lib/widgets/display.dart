import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Display{

  appBar(BuildContext context){
    return AppBar(
      leading: IconButton(
          icon: SvgPicture.asset('images/backArrowBlackWhite.svg',),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
      title: Material(
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}