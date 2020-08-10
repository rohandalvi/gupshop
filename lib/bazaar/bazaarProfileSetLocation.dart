import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gupshop/location/location_service.dart';
import 'package:gupshop/widgets/customBottomSheet.dart';
import 'package:gupshop/widgets/customIconButton.dart';

class BazaarProfileSetLocation extends StatefulWidget {
  bool locationSelected;
  Position bazaarWalaLocation;
  double latitude;
  double longitude;
  String userName;

  BazaarProfileSetLocation({this.locationSelected, this.bazaarWalaLocation, this.longitude, this.latitude, this.userName});

  @override
  _BazaarProfileSetLocationState createState() => _BazaarProfileSetLocationState();
}

class _BazaarProfileSetLocationState extends State<BazaarProfileSetLocation> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
          CustomIconButton(
          iconNameInImageFolder: 'locationPin',
            onPressed: (){
              CustomBottomSheet(
                customContext: context,
                firstIconName: 'home',
                firstIconText: 'Set current location as home location',
                firstIconAndTextOnPressed: (){
                  set();
                },
                secondIconName: 'locationPin',
                secondIconText: 'Set other location as home location',
                secondIconAndTextOnPressed: (){
                  set();
                },
              ).showTwo();
            },
          ),
        if(widget.locationSelected == true ) Padding(child: LocationServiceState().showLocation(widget.userName, widget.latitude, widget.longitude), padding: EdgeInsets.only(right: 5),)
      ],
    );
  }

  set() async{
    Navigator.pop(context);
    Position location  = await LocationServiceState().getLocation();//setting user's location
    setState(() {
      widget.locationSelected = true;
      widget.bazaarWalaLocation = location;

      widget.latitude = widget.bazaarWalaLocation.latitude;
      widget.longitude =  widget.bazaarWalaLocation.longitude;
    });
  }
}
