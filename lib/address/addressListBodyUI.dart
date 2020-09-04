import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/address/saveButton.dart';
import 'package:gupshop/bazaarCategory/changeLocationInSearch.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/location/location_service.dart';
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
  bool showSave = false;
  var geoPoint;
  String geohash;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: widget.numberOfAddresses,
          itemBuilder: (BuildContext context, int index){
            return ListTile(
              title: titleRow(widget.addressName, context),
              subtitle: CustomText(text: widget.address,),
            );
          }
      ),
      floatingActionButton: Visibility(
        visible: showSave,
        child: SaveButton(geoPoint: geoPoint,geohash: geohash, address: widget.address,userPhoneNo: widget.userPhoneNo,)
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

            Position location =  new Position(longitude: latLng.longitude, latitude: latLng.latitude);

            String newAddress = await ChangeLocationInSearch().getAddress(location);

            var tempGeoPoint = await ChangeLocationInSearch().getGeoPoint(latLng.latitude, latLng.longitude);

            String tempGeohash = await LocationService().createGeohash(latLng.latitude, latLng.longitude);

            setState(() {
              widget.address = newAddress;
              showSave = true;
              geoPoint = tempGeoPoint;
              geohash = tempGeohash;
            });
          },
        ),
      ],
    );
  }
}
