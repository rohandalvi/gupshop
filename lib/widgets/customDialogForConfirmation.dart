import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gupshop/widgets/customText.dart';

class CustomDialogForConfirmation{
  String title;
  String content;

  CustomDialogForConfirmation({this.title, this.content});

  Future<bool> dialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: title == null?const CustomText(text: "Hey group admin, are you sure ?"): CustomText(text: title),
            content: content == null?const CustomText(text: "The member will be deleted from the group"): CustomText(text: content),
            actions: <Widget>[
              IconButton(
                  icon: SvgPicture.asset('images/alarm.svg',)
                //SvgPicture.asset('images/downChevron.svg',)
              ),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const CustomText(text:"YES")
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const CustomText(text:"NO"),
              ),
            ],
          );
        }
    );
  }

}