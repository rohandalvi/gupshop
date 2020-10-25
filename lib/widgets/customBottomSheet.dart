import 'package:flutter/material.dart';
import 'package:gupshop/responsive/iconConfig.dart';
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
  final String thirdIconName;
  final VoidCallback thirdIconAndTextOnPressed;
  final String thirdIconText;
  final String fourthIconName;
  final VoidCallback fourthIconAndTextOnPressed;
  final String fourthIconText;
  final String fifthIconName;
  final VoidCallback fifthIconAndTextOnPressed;
  final String fifthIconText;
  final String sixthIconName;
  final VoidCallback sixthIconAndTextOnPressed;
  final String sixthIconText;


  CustomBottomSheet({this.customContext,
    this.firstIconName, this.firstIconAndTextOnPressed, this.firstIconText,
    this.secondIconName, this.secondIconAndTextOnPressed, this.secondIconText,
    this.thirdIconName, this.thirdIconAndTextOnPressed, this.thirdIconText,
    this.fourthIconName, this.fourthIconAndTextOnPressed, this.fourthIconText,
    this.fifthIconName, this.fifthIconAndTextOnPressed, this.fifthIconText,
    this.sixthIconName, this.sixthIconAndTextOnPressed, this.sixthIconText,
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
    return showBottomSheet(
        context: customContext,
        builder: (BuildContext context){
          return Container(
            //height: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                /// icon and name, so CustomIconButton and CustomText
                Row(
                  children: <Widget>[
                    CustomIconButton(
                      iconNameInImageFolder: firstIconName,
                      onPressed: firstIconAndTextOnPressed,
                    ),
                    GestureDetector(
                      onTap: firstIconAndTextOnPressed,
                      child: CustomText(text: firstIconText,)
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    CustomIconButton(
                      iconNameInImageFolder: secondIconName,
                      onPressed: secondIconAndTextOnPressed,
                    ),
                    GestureDetector(
                      onTap: secondIconAndTextOnPressed,
                      child: CustomText(text: secondIconText,)
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    CustomIconButton(
                      iconNameInImageFolder: thirdIconName,
                      onPressed: thirdIconAndTextOnPressed,
                    ),
                    GestureDetector(
                      onTap: thirdIconAndTextOnPressed,
                      child: CustomText(text: thirdIconText,))
                  ],
                ),
                Row(
                  children: <Widget>[
                    CustomIconButton(
                      iconNameInImageFolder: fourthIconName,
                      onPressed: fourthIconAndTextOnPressed,
                    ),
                    GestureDetector(
                      onTap: fourthIconAndTextOnPressed,
                      child: CustomText(text: fourthIconText,))
                  ],
                ),
                Row(
                  children: <Widget>[
                    CustomIconButton(
                      iconNameInImageFolder: fifthIconName,
                      onPressed: fifthIconAndTextOnPressed,
                    ),
                    GestureDetector(
                      onTap: fifthIconAndTextOnPressed,
                      child: CustomText(text: fifthIconText,)
                    )
                  ],
                ),
//                Row(
//                  children: <Widget>[
//                    CustomIconButton(
//                      iconNameInImageFolder: sixthIconName,
//                      onPressed: sixthIconAndTextOnPressed,
//                    ),
//                    CustomText(text: sixthIconText,)
//                  ],
//                ),
                CustomIconButton(
                  iconNameInImageFolder: IconConfig.cancel,
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        }
    );
  }

  showTwo(){
    return showBottomSheet(
        context: customContext,
        builder: (BuildContext context){
          return Container(
            //height: MediaQuery.of(context).size.height*0.22,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                /// icon and name, so CustomIconButton and CustomText
                Container(
                  child: Row(
                    children: <Widget>[
                      CustomIconButton(
                        iconNameInImageFolder: firstIconName,
                        onPressed: firstIconAndTextOnPressed,
                      ),
                      GestureDetector(
                        child: CustomText(text: firstIconText,),
                        onTap: firstIconAndTextOnPressed,
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      CustomIconButton(
                        iconNameInImageFolder: secondIconName,
                        onPressed: secondIconAndTextOnPressed,
                      ),
                      GestureDetector(onTap : secondIconAndTextOnPressed,child: CustomText(text: secondIconText,))
                    ],
                  ),
                ),
                Container(
                  child: CustomIconButton(
                    iconNameInImageFolder: IconConfig.cancel,
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  showOne(){
    return showBottomSheet(
        context: customContext,
        builder: (BuildContext context){
          return Container(
            height: MediaQuery.of(context).size.height*0.2,
            child: Column(
              children: <Widget>[
                /// icon and name, so CustomIconButton and CustomText
                Row(
                  children: <Widget>[
                    CustomIconButton(
                      iconNameInImageFolder: firstIconName,
                      onPressed: firstIconAndTextOnPressed,
                    ),
                    GestureDetector(
                      onTap: firstIconAndTextOnPressed,
                      child: CustomText(text: firstIconText,))
                  ],
                ),
              ],
            ),
          );
        }
    );
  }

  showOneWithCancel(){
    return showBottomSheet(
        context: customContext,
        builder: (BuildContext context){
          return Container(
            child: Column(
              /// to make the bottom sheet take only the width and height as
              /// is required we use :
              /// mainAxisAlignment - To align the contents to the bottom
              /// mainAxisSize - To make the bottom sheet take the minimum
              /// space required
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                /// icon and name, so CustomIconButton and CustomText
                Container(
                  child: Row(
                    children: <Widget>[
                      CustomIconButton(
                        iconNameInImageFolder: firstIconName,
                        onPressed: firstIconAndTextOnPressed,
                      ),
                      GestureDetector(
                        onTap: firstIconAndTextOnPressed,
                        child: CustomText(text: firstIconText,))
                    ],
                  ),
                ),
                Container(
                  child: CustomIconButton(
                    iconNameInImageFolder: IconConfig.cancel,
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          );
        }
    );
  }

}
