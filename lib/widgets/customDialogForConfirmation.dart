import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gupshop/widgets/customText.dart';

class CustomDialogForConfirmation{

  Future<bool> dialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const CustomText(text: "Hey group admin, are you sure ?"),
            content: const CustomText(text: "The member will be deleted from the group"),
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