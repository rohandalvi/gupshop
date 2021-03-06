import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/widgets/customIcon.dart';
import 'package:gupshop/widgets/customText.dart';

class CustomDialogForConfirmation{
  String title;
  String content;
  bool barrierDismissible;

  CustomDialogForConfirmation({this.title, this.content, this.barrierDismissible});

  Future<bool> dialog(BuildContext context) {
    return showDialog(
        barrierDismissible: barrierDismissible == null ? false : barrierDismissible,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: title == null?CustomText(text: "Hey group admin, are you sure ?"): CustomText(text: title),
            content: content == null?CustomText(text: "The member will be deleted from the group"): CustomText(text: content),
            actions: <Widget>[
              CustomIcon(iconName: IconConfig.alarm,),
//              IconButton(
//                  icon: SvgPicture.asset('images/alarm.svg',)
//                //SvgPicture.asset('images/downChevron.svg',)
//              ),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: CustomText(text:"YES")
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: CustomText(text:"NO"),
              ),
            ],
          );
        }
    );
  }

}