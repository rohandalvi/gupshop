import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/widgets/clickableText.dart';

class ForwardMessagesSnackBarTitleText extends StatelessWidget {
  final GestureTapCallback onTap;

  ForwardMessagesSnackBarTitleText({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),///Forward button was touching the edge of the screen
          child: ClickableText(text: 'Forward', onTap: onTap,),
        ),
        IconButton(
          icon: SvgPicture.asset('images/cancel.svg',),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
