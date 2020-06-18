import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final String tooltip;
  final Widget child;
  final VoidCallback onPressed;

  CustomFloatingActionButton({this.tooltip, this.child, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: tooltip==null?'Scroll to the bottom':tooltip,
      backgroundColor: Colors.transparent,
      elevation: 0,
//              hoverColor: Colors.transparent,

      highlightElevation: 0,
      child: child == null ? IconButton(
          icon: SvgPicture.asset('images/groupManWoman.svg',)
        //SvgPicture.asset('images/downChevron.svg',)
      ): child,
      onPressed: onPressed,
    );
  }
}
