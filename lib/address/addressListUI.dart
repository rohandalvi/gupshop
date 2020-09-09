import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/address/addressListData.dart';
import 'package:gupshop/address/saveButton.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customText.dart';

class AddressListUI extends StatelessWidget {
  final String userPhoneNo;

  AddressListUI({this.userPhoneNo});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(WidgetConfig.appBarSeventy),
        child: CustomAppBar(
          title: CustomText(text : "Address Book"),
        ),
      ),
      body: Container(
        child: AddressListData(userPhoneNo: userPhoneNo,),
      ),
    );
  }
}
