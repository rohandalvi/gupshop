import 'package:flutter/cupertino.dart';
import 'package:gupshop/location/location_service.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';

class LocationDisplayAndLaunchInMap extends StatelessWidget {
  final String textOnButton;
  final String locationName;
  final double latitude;
  final double longitude;

  LocationDisplayAndLaunchInMap({this.textOnButton, this.locationName, this.latitude, this.longitude});

  @override
  Widget build(BuildContext context) {
    return CustomRaisedButton(
      child: CustomText(text: '$textOnButton \n$locationName 📍',),/// toDo- very very big name
      onPressed: (){
        LocationService().launchMapsUrl(latitude, longitude);
      },
    );
  }
}
