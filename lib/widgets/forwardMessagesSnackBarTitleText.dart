import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/widgets/clickableText.dart';

class ForwardMessagesSnackBarTitleText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ClickableText(text: 'Forward', onTap: (){},),
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
