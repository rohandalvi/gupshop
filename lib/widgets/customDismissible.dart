import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/service/conversationDetails.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/widgets/customIcon.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class CustomDismissible extends StatefulWidget {
  Key key;
  DismissDirectionCallback onDismissed;
  Widget child;
  String icon;
  String documentID;

  CustomDismissible({@required this.key, @required this.onDismissed, this.child, this.icon, this.documentID});

  @override
  _CustomDismissibleState createState() => _CustomDismissibleState();
}

class _CustomDismissibleState extends State<CustomDismissible> {
  bool group;
  String admin;
  String myNumber;

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  getUserDetails() async{
    bool groupTemp = await CheckIfGroup().ifThisIsAGroup(widget.documentID);
    String adminTemp = await CheckIfGroup().getAdminNumber(widget.documentID);
    String myNumberTemp = await UserDetails().getUserPhoneNoFuture();
    setState(() {
     group = groupTemp;
     admin = adminTemp;
     myNumber = myNumberTemp;
    });
  }

  @override
  Widget build(BuildContext context){
    return Dismissible(
      confirmDismiss:(direction) async {
        bool groupTemp = await CheckIfGroup().ifThisIsAGroup(widget.documentID);
        String adminTemp = await CheckIfGroup().getAdminNumber(widget.documentID);
        String myNumberTemp = await UserDetails().getUserPhoneNoFuture();
        setState((){
          group = groupTemp;
          admin  = adminTemp;
          myNumber = myNumberTemp;
        });
        return (direction == DismissDirection.startToEnd && group == true && admin == myNumber) ? showDialog(/// if its a group, then show dialog, else delete directly
            context: context,
            builder: (BuildContext context) {
          return AlertDialog(
            title: CustomText(text: TextConfig.groupAdminDeleteAlert),
            content: CustomText(text: TextConfig.groupWillBeDeleted),
            actions: <Widget>[
              CustomIcon(iconName: IconConfig.alarm,),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: CustomText(text:TextConfig.yes)
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: CustomText(text:TextConfig.no),
              ),
            ],
          );
        },
        ) : true;
      },
      key: widget.key,
      onDismissed: widget.onDismissed,
      direction: (group == true && admin == myNumber) ? DismissDirection.horizontal : DismissDirection.endToStart,
      background: Container(
        color: red,
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: EdgeInsets.all(PaddingConfig.eight),
          child: CustomText(text: TextConfig.delete,textColor: white,),
        )
      ),
      secondaryBackground: Container(
        color: primaryColor,
        //notMeChatColor,
        alignment: AlignmentDirectional.centerEnd,
        child: Padding(
          padding: EdgeInsets.all(PaddingConfig.eight),
          child: CustomText(text: TextConfig.hide,textColor: white,),
        )
      ),
      child: widget.child,
    );
  }
}
