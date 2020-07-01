import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/service/checkIfGroup.dart';
import 'package:gupshop/widgets/colorPalette.dart';
import 'package:gupshop/widgets/customText.dart';

class CustomDismissible extends StatelessWidget {
  Key key;
  DismissDirectionCallback onDismissed;
  Widget child;
  String icon;
  String documentID;

  CustomDismissible({@required this.key, @required this.onDismissed, this.child, this.icon, this.documentID});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss:(DismissDirection direction) async {
        bool group = await CheckIfGroup().ifThisIsAGroup(documentID);
        return group == true ? showDialog(
            context: context,
            builder: (BuildContext context) {
          return AlertDialog(
            title: const CustomText(text: "Are you sure"),
            content: const CustomText(text: "The group will be deleted permenantly"),
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
        },
        ) : true;
      },
      key: key,
      onDismissed: onDismissed,
      direction: DismissDirection.endToStart,
      background: Container(
        color: deleteColor,
        alignment: AlignmentDirectional.centerEnd,
        child:
        IconButton(
            icon: SvgPicture.asset('images/recycleBin.svg',)
          //SvgPicture.asset('images/downChevron.svg',)
        ),
//        CustomText(
//          text: text == null ? 'Delete group' : text,
//          textColor: Colors.white,),
      ),
      child: child,
    );
  }

}
