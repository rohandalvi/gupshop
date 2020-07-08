import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gupshop/widgets/colorPalette.dart';

class CustomAppBar extends StatelessWidget{
  final VoidCallback onPressed;
  Widget title;

  CustomAppBar({Key key, this.onPressed, this.title});



  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: secondryColor.withOpacity(.03),
      elevation: 0,
      title: title,
      leading: IconButton(
        icon: SvgPicture.asset('images/backArrowColor.svg',),
        onPressed: onPressed,
//        onPressed: (){//toDo- implement- if the parameter not given then use this
//          Navigator.pop(context);
//        },
      ),
//      title: Material(
//        color: Theme.of(context).primaryColor,
//      ),
    );
  }
}
