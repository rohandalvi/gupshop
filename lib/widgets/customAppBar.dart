import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gupshop/widgets/colorPalette.dart';

//class Display{


//  appBar(BuildContext context){
//    return AppBar(
//      backgroundColor: primaryColor.withOpacity(.03),
//      elevation: 0,
//      leading: IconButton(
//          icon: SvgPicture.asset('images/backArrowColor.svg',),
//        onPressed: (){
//          Navigator.pop(context);
//        },
//      ),
////      title: Material(
////        color: Theme.of(context).primaryColor,
////      ),
//    );
//  }
//}

class CustomAppBar extends StatelessWidget{
  final VoidCallback onPressed;

  CustomAppBar({Key key, this.onPressed});



  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: secondryColor.withOpacity(.03),
      elevation: 0,
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
