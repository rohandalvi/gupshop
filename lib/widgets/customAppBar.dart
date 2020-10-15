import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/widgets/customIconButton.dart';

class CustomAppBar extends StatelessWidget{
  final VoidCallback onPressed;
  final Widget title;
  final List<Widget> actions;

  CustomAppBar({Key key, this.onPressed, this.title, this.actions});



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        backgroundColor: secondryColor.withOpacity(.03),
        elevation: 0,
        title: FittedBox(child: title),
        actions: actions,
        leading: CustomIconButton(
          iconNameInImageFolder:IconConfig.backArrow,
          onPressed: onPressed,
        ),
      ),
    );
  }

  noLeading(){
    return SafeArea(
      child: AppBar(
        backgroundColor: secondryColor.withOpacity(.03),
        elevation: 0,
        title: title,
        actions: actions,
        automaticallyImplyLeading: false,
      ),
    );
  }
}
