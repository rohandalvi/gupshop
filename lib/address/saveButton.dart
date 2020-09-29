import 'package:flutter/cupertino.dart';
import 'package:gupshop/navigators/navigateToAddressList.dart';
import 'package:gupshop/navigators/navigateToBazaarIndividualCategoryListDisplay.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/updateInFirebase/updateUsersLocation.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';

class SaveButton extends StatelessWidget {
  var geoPoint;
  String address;
  String geohash;
  String userPhoneNo;

  SaveButton({this.geoPoint, this.geohash, this.address, this.userPhoneNo});

  @override
  Widget build(BuildContext context) {
    return CustomFloatingActionButtonWithIcon(
      iconName: IconConfig.save,
      onPressed: (){
        /// update home address in usersLocation collection
        UpdateUsersLocation(userPhoneNo: userPhoneNo).updateHomeAddress(
            address, geoPoint, geohash);

        /// then send the user to bazaarIndividual
        Navigator.pop(context, true);
      },
      width: WidgetConfig.floatingActionButtonSmallWidth,
      height: WidgetConfig.floatingActionButtonSmallHeight,
    );
  }
}
