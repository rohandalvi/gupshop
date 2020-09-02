//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/bazaar/getCategoriesSubscribedTo.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarProfilePage.dart';
import 'package:gupshop/bazaar/productDetail.dart';
import 'package:gupshop/navigators/navigateToBazaarOnBoardingHome.dart';
import 'package:gupshop/navigators/navigateToOnBoardingCategorySelector.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customNavigators.dart';
import 'package:gupshop/location/location_service.dart';
import 'package:gupshop/service/getSharedPreferences.dart';
import 'package:gupshop/usersLocation/usersLocation.dart';
import 'package:gupshop/widgets/CustomFutureBuilder.dart';
import 'package:gupshop/bazaarCategory/bazaarHomeGridView.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';

// home.dart =>
// => bazaarProfilePage
class BazaarHomeScreen extends StatefulWidget {
  final String userPhoneNo;
  final String userName;

  BazaarHomeScreen({@required this.userPhoneNo, @required this.userName});

  @override
  _BazaarHomeScreenState createState() => _BazaarHomeScreenState(userPhoneNo: userPhoneNo, userName: userName);
}

class _BazaarHomeScreenState extends State<BazaarHomeScreen> {

  final String userPhoneNo;
  final String userName;

  _BazaarHomeScreenState({@required this.userPhoneNo, @required this.userName});

  @override
  void initState() {
    super.initState();

    UsersLocation().setUsersLocationToFirebase();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(height: WidgetConfig.sizedBoxBazaarHome,),
          new BazaarHomeGridView(),
        ],
      ),
      floatingActionButton: CustomFutureBuilderForGetIsBazaarWala(
        createIcon: floatingActionButtonForNewBazaarwala(),
        editIcon: floatingActionButtonForEditBazaarwala(),
      ),
      //_floatingActionButtonForNewBazaarwala(),
    );
  }

  floatingActionButtonForNewBazaarwala(){
    return CustomBigFloatingActionButton(
      child: CustomIconButton(
          iconNameInImageFolder: 'add',
      ),
      onPressed: NavigateToBazaarOnBoardingHome().navigate(context),
      //NavigateToBazaarProfilePage(userName: userName, userPhoneNo: userPhoneNo).navigate(context)
    );
  }

  /// futureBuilder for show
  floatingActionButtonForEditBazaarwala(){
    return CustomBigFloatingActionButton(
        child: CustomIconButton(
          iconNameInImageFolder: 'add',
        ),
        onPressed: NavigateToBazaarOnBoardingHome().navigate(context),
        //NavigateToBazaarProfilePage(userName: userName, userPhoneNo: userPhoneNo).navigate(context)
    );
  }
}

