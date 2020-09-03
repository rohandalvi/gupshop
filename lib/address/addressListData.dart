import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/address/addressListBodyUI.dart';
import 'package:gupshop/bazaarCategory/changeLocationInSearch.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/retriveFromFirebase/getUsersLocation.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

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
            print("addressName : ${snapshot.data.length}");
            String addressName = "Home : ";
            String address = snapshot.data["address"];

            int numberOfAddresses =  1;/// right now we are showing only 1 address,  i.e home address


            return AddressListBodyUI(
              userPhoneNo: widget.userPhoneNo,
              address: address,
              addressName: addressName,
              numberOfAddresses: numberOfAddresses,
            );
//              ListView.builder(
//              itemCount: numberOfAddresses,
//            itemBuilder: (BuildContext context, int index){
//                return ListTile(
//                  title: titleRow(addressName, context),
//                  subtitle: CustomText(text: address,),
//                );
//              }
//            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  titleRow(String addressName, BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CustomText(text: addressName, textColor: primaryColor,),
        CustomIconButton(
          iconNameInImageFolder: 'editPencil',
          onPressed: () async{
            /// open maps
            LatLng latLng = await ChangeLocationInSearch(userNumber: widget.userPhoneNo).getLatLang(context);
            print("latLng : $latLng");

            Position location =  new Position(longitude: latLng.longitude, latitude: latLng.latitude);

            String newAddress = await ChangeLocationInSearch().getAddress(location);

            setState(() {
              addressName = newAddress;
              print("addressName in setState : $addressName");
              print("newAddress in setState : $newAddress");
            });
          },
        ),
      ],
    );
  }
}
