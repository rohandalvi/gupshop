import 'package:cloud_firestore/cloud_firestore.dart';
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
            GeoPoint geoPoint = snapshot.data["geoPoint"];
            double latitude = geoPoint.latitude;
            double longitude = geoPoint.longitude;

            int numberOfAddresses =  1;/// right now we are showing only 1 address,  i.e home address


            return AddressListBodyUI(
              userPhoneNo: widget.userPhoneNo,
              address: address,
              addressName: addressName,
              numberOfAddresses: numberOfAddresses,
              longitude: longitude,
              latitude: latitude,
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
