import 'package:flutter/material.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class CustomBottomSheet extends StatelessWidget {
  final BuildContext customContext;
  final String firstIconName;
  final VoidCallback firstIconAndTextOnPressed;
  final String firstIconText;
  final String secondIconName;
  final VoidCallback secondIconAndTextOnPressed;
  final String secondIconText;

  CustomBottomSheet({this.customContext, this.firstIconName, this.firstIconAndTextOnPressed, this.firstIconText,
    this.secondIconName, this.secondIconAndTextOnPressed, this.secondIconText,
  });

  @override
  Widget build(BuildContext context) {
    /// this is just a placeholder method.
    /// because showBottomSheet requires the scaffold's context
    /// which cannot be used in build method.
    /// Same logic is used in CustomFlushBar
    /// use show method instead.
    return show();
  }

  show(){
    print("customContext in customBottom: $customContext");
    return showBottomSheet(
        context: customContext,
        builder: (BuildContext context){
          return Container(
            height: 200,
            child: Column(
              children: <Widget>[
                /// icon and name, so CustomIconButton and CustomText
                Row(
                  children: <Widget>[
                    CustomIconButton(
                      iconNameInImageFolder: firstIconName,
                      onPressed: firstIconAndTextOnPressed,
                    ),
                    CustomText(text: firstIconText,)
                  ],
                ),
                Row(
                  children: <Widget>[
                    CustomIconButton(
                      iconNameInImageFolder: secondIconName,
                      onPressed: secondIconAndTextOnPressed,
                    ),
                    CustomText(text: secondIconText,)
                  ],
                ),
//                Row(),
              ],
            ),
          );
        }
    );
  }
}
