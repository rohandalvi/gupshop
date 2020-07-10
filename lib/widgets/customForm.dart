//import 'package:flutter/cupertino.dart';
//import 'package:gupshop/service/videoPicker.dart';
//import 'package:gupshop/widgets/customRaisedButton.dart';
//import 'package:gupshop/widgets/customText.dart';
//import 'dart:io';
//
//import 'customVideoPlayer.dart';
//
//class CustomForm extends StatelessWidget {
//  bool showFirstWidget;
//  Widget firstWidget;
//  Widget changeFirstWidget;
//  bool showFirstField;
//  Widget fieldFirstOptionOne;
//  Widget fieldFirstOptionTwo;
//
//  String subTitle;
//
//  bool showSecondWidget;
//  Widget secondWidget;
//  Widget changeSecondWidget;
//  Widget fieldSecondOptionOne;
//  Widget fieldSecondOptionTwo;
//
//  bool showThirdWidget;
//  Widget thirdWidget;
//  Widget changeThirdWidget;
//  Widget fieldThirdOptionOne;
//  Widget fieldThirdOptionTwo;
//
//  Widget save;
//
//  CustomForm({
//    this.showFirstWidget, this.firstWidget, this.firstFieldName, this.showFirstField, this.fieldFirstOptionOne,
//    this.fieldFirstOptionTwo, this.subTitle, this.showSecondWidget, this.secondWidget, this.secondFieldName, this.fieldSecondOptionOne,
//    this.fieldSecondOptionTwo,
//    this.showThirdWidget, this.thirdWidget, this.thirdFieldName, this.fieldThirdOptionOne, this.fieldThirdOptionTwo,
//    this.save,
//  });
//
//
//  @override
//  Widget build(BuildContext context) {
//    return ListView(
//        children: <Widget>[
//          /// video widgets:
//          if(showFirstWidget) Row(
//            children: <Widget>[
//              firstWidget,
//              changeFirstWidget,
//            ],
//          ),
//          createSpaceBetweenButtons(15),
//          pageSubtitle(subTitle),
//          Visibility(
//            visible: (showFirstField == false),
//            child: fieldFirstOptionOne,
//          ),
//          Visibility(
//            visible: (showFirstField == false),
//            child: or(),
//          ),
//          Visibility(
//            visible:(showFirstField == false),
//            child: fieldFirstOptionTwo,
//          ),
//
//          /// location widgets:
//          if(showSecondWidget == false ) Row(
//            children: <Widget>[
//              secondWidget,
//              changeSecondWidget
//            ],
//          ),
//          Visibility(
//            visible: showSecondWidget,
//            child: fieldSecondOptionOne,
//          ),
//          Visibility(
//            visible: showSecondWidget,
//            child: or(),
//          ),
//          Visibility(
//            visible: showSecondWidget,
//            child: fieldSecondOptionTwo,
//          ),
//
//          /// category widgets:
//          if(showThirdWidget == true ) thirdWidget,
//          Visibility(
//            visible: (showThirdWidget == false),
//            child: fieldThirdOptionOne,
//          ),
//
//          /// show save button if everything is selected:
//          save
//        ]
//    );
//  }
//
//  changeButton(String changeWhat, VoidCallback onPressedForFirstWidget){
//    return CustomRaisedButton(
//      child: CustomText(text :'Change $changeWhat'),
//      onPressed: onPressedForFirstWidget,
//    );
//  }
//
//  createSpaceBetweenButtons(double height){
//    return SizedBox(
//      height: height,
//    );
//  }
//
//  pageSubtitle(String subTitle){
//    return CustomText(text: subTitle,);
//  }
//
//or(){
//  return CustomText(text: 'or',);
//}
//}
