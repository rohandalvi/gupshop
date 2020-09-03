import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/bazaarCategory/changeLocationInSearch.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class AddressListBodyUI extends StatefulWidget {
  final int numberOfAddresses;
  String addressName;
  String address;
  final String userPhoneNo;

  AddressListBodyUI({this.numberOfAddresses,this.addressName, this.address, this.userPhoneNo});

  @override
  _AddressListBodyUIState createState() => _AddressListBodyUIState();
}

class _AddressListBodyUIState extends State<AddressListBodyUI> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.numberOfAddresses,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            title: titleRow(widget.addressName, context),
            subtitle: CustomText(text: widget.address,),
          );
        }
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
              widget.address = newAddress;
              print("address in setState : ${widget.address}");
              print("newAddress in setState : $newAddress");
            });
          },
        ),
      ],
    );
  }
}
