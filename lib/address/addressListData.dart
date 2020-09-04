import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/address/addressListBodyUI.dart';
import 'package:gupshop/retriveFromFirebase/getUsersLocation.dart';

class AddressListData extends StatefulWidget {
  final String userPhoneNo;

  AddressListData({this.userPhoneNo});


  @override
  _AddressListDataState createState() => _AddressListDataState();
}

class _AddressListDataState extends State<AddressListData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: GetUsersLocation(userPhoneNo: widget.userPhoneNo).getHomeAddress(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            String addressName = "Home : ";
            String address = snapshot.data["address"];

            int numberOfAddresses =  1;/// right now we are showing only 1 address,  i.e home address


            return AddressListBodyUI(
              userPhoneNo: widget.userPhoneNo,
              address: address,
              addressName: addressName,
              numberOfAddresses: numberOfAddresses,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
