import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BuildMessageComposer extends StatelessWidget {
  VoidCallback firstOnPressed;
  VoidCallback secondOnPressed;
  VoidCallback onPressedForSendingMessageIcon;
  ValueChanged<String> onChangedForTextField;
  ScrollController scrollController;
  TextEditingController controller;

  BuildMessageComposer({this.firstOnPressed,this.secondOnPressed, this.onPressedForSendingMessageIcon, this.onChangedForTextField, this.scrollController, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: SvgPicture.asset('images/image2vector.svg',),
            onPressed: firstOnPressed,
          ),
          IconButton(
            icon: SvgPicture.asset('images/videoCamera.svg',),
            onPressed: secondOnPressed,
          ),
          Expanded(
            child: TextField(
              maxLines: null,
              onChanged: onChangedForTextField,
              scrollController: scrollController,
              controller: controller,//used to clear text when user hits send button
            ),
          ),
          IconButton(
            icon: SvgPicture.asset('images/paperPlane.svg',),///or forward2
            onPressed: onPressedForSendingMessageIcon,
          ),
        ],
      ),
    );
  }
}
