import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/colorPalette.dart';
import 'package:gupshop/widgets/customText.dart';

class CustomDismissible extends StatelessWidget {
  Key key;
  DismissDirectionCallback onDismissed;
  Widget child;

  CustomDismissible({@required this.key, @required this.onDismissed, this.child});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key,
      onDismissed: onDismissed,
      direction: DismissDirection.endToStart,
      background: Container(
        color: deleteColor,
        alignment: AlignmentDirectional.centerEnd,
        child: CustomText(
          text: 'Delete group',
          textColor: Colors.white,),
      ),
      child: child,
    );
  }
}
