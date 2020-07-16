import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  String iconNameInImageFolder;

  CustomIconButton({this.onPressed, this.iconNameInImageFolder});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset('images/$iconNameInImageFolder.svg',),
      onPressed: onPressed,
    );
  }
}