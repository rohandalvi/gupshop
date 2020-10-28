import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/bazaar/bazaarProfileSetVideo.dart';
import 'package:gupshop/bazaar/categories.dart';
import 'package:gupshop/bazaarHomeService/serviceAtHomeUI.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/location/locationPermissionHandler.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/location/location_service.dart';
import 'package:gupshop/navigators/navigateToCustomMap.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';
import 'package:gupshop/widgets/customFlushBar.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:location/location.dart';


// bazaarHomeScreen=>
// =>CheckBoxCategorySelector
class BazaarLocation extends StatefulWidget {
  final String userPhoneNo;
  final String userName;
  final List<String> listOfSubCategories;
  final String category;
  final String categoryData;
  List<String> listOfSubCategoriesForData;
  final List<dynamic> deleteListData;
  final List<dynamic> addListData;
  final bool videoChanged;
  final String videoURL;
  final String aSubCategoryData;
  double databaseLatitude;
  double databaseLongitude;
  String addressName;
  double radius;
  LatLng location;
  bool locationNotNull;
  final bool isBazaarWala;



  //final Future<List<DocumentSnapshot>> subCategoriesListFuture;
  Map<String, String> subCategoryMap;
  final Map<String, bool> homeServiceMap;


  BazaarLocation({@required this.userPhoneNo, @required this.userName,
    this.category, this.listOfSubCategories, this.listOfSubCategoriesForData,
    this.subCategoryMap,this.categoryData,
    this.addListData, this.deleteListData,
    this.videoURL, this.videoChanged, this.aSubCategoryData,
    this.addressName, this.location, this.databaseLongitude,
    this.databaseLatitude,
    this.locationNotNull, this.radius, this.homeServiceMap, this.isBazaarWala
  });

  @override
  _BazaarLocationState createState() => _BazaarLocationState(userName: userName, userPhoneNo: userPhoneNo);
}

class _BazaarLocationState extends State<BazaarLocation> {
  final String userPhoneNo;
  final String userName;

  _BazaarLocationState({@required this.userPhoneNo, @required this.userName});


  List<bool> inputs = new List<bool>();


  bool saveButtonVisible = false;

  /// for creating local cache
  BazaarProfileSetVideo isVideo;

  LatLng locationFromMap;

  Categories categorySelection;
  ServiceAtHome service;
  bool homeService;

  Map<dynamic, dynamic> cache = new Map();

  bool locationChanged;



  @override
  void initState() {
    super.initState();
  }



  /// if user has added a subCategory, then that subcategory wont have
  /// details in firebase as it is not previously pushed.
  /// Hence, we first check if addList has any data,
  ///   if yes, then we dont set aSubCategoryData as any subCategory which
  ///   has been newly added
  getASubcategoryName(){
    String aSubCategoryData = widget.listOfSubCategoriesForData[0];

    if(widget.addListData != null){
      for(int i = 0; i<widget.listOfSubCategoriesForData.length; i++){
        if(widget.addListData.contains(widget.listOfSubCategoriesForData[i]) == false){
          return widget.listOfSubCategoriesForData[i];
        }
      }
    }else {
      return aSubCategoryData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(WidgetConfig.appBarSeventy),
          child: CustomAppBar(
            title: CustomText(text: TextConfig.bazaarLocationTitle,),
            onPressed:(){
              Navigator.pop(context);
              //NavigateToHome(initialIndex: 1).navigateNoBrackets(context);
            },),
        ),
        backgroundColor: Colors.white,
        body: Column(
                children: <Widget>[
                  /// video widgets:
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomText(
                        text: TextConfig.bazaarLocationIntro,
                        textAlign: TextAlign.center,
                        textColor: subtitleGray,
                      ),
                    ),
                  ),

                  /// location widgets:
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: PaddingConfig.eight),
                      child: Image.asset(
                        ImageConfig.bazaarOnBoardingLocationLogo,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: locationAddDisplay(context),
                  ),
                ]
            ),
        floatingActionButton: showSaveButton(context),
      ),
    );
  }




  locationAddDisplay(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(PaddingConfig.eight),
          child: CustomRaisedButton(
            child: CustomText(text: TextConfig.addLocation,),
            onPressed: () async{
              /// first check if user has given permission to access location
              var permission = await LocationPermissionHandler().handlePermissions(context);
              if(permission == true){
                LocationData locationTemp;

                /// placeholder till map is generated:
                /// show a dialog box with CircularProgressIndicator
                showDialog(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                      title: Text(TextConfig.loadingMap),
                      content: Center(child: CircularProgressIndicator()),
                    ));


                var currentLocation = new Location();
                locationTemp = await currentLocation.getLocation();

                /// getting a list of latLang and radius in the list returned
                /// by NavigateToCustomMap
                /// list[0] = location
                /// list[1] = radius
                Map<String,dynamic> navigatorMap = new Map();
                navigatorMap[TextConfig.latitude] = locationTemp.latitude;
                navigatorMap[TextConfig.longitude] = locationTemp.longitude;
                navigatorMap[TextConfig.showRadius] = true;

                dynamic list = await Navigator.pushNamed(context, NavigatorConfig.customMap, arguments: navigatorMap);// if its a group then p
//                List list =await NavigateToCustomMap(
//                  latitude: locationTemp.latitude,
//                  longitude: locationTemp.longitude,
//                  showRadius: true,
//                ).navigateNoBrackets(context);

                /// for exiting dialog:
                Navigator.pop(context);

                /// list[0] = location
                /// list[1] = radius
                locationFromMap = list[0];
                widget.radius = list[1];

                widget.location = locationFromMap;
                locationChanged = true;
                String addressNameTemp = await LocationService().getAddressFromLatLang(widget.location.latitude, widget.location.longitude);
//                print("addressNameTemp : $addressNameTemp");
                /// setState to make the locationNotNull = true so that
                /// showLocation() becomes visible
                setState(() {
                  widget.locationNotNull = true;
                  widget.addressName = addressNameTemp;
                });
              }
            },
          ).elevated(),
        ),
        showLocation(),
      ],
    );
  }

  showLocation() {
    if(widget.locationNotNull == true){
      return Padding(
        padding: EdgeInsets.all(PaddingConfig.eight),
        child: FittedBox(
          child: Visibility(
            visible:widget.locationNotNull == true,
            child: LocationService().showAddress(widget.addressName),
            //child: LocationService().showLocation(userName, databaseLatitude, databaseLatitude),
          ),
        ),
      );
    }return SizedBox.shrink();

  }


  createSpaceBetweenButtons(double height){
    return SizedBox(
      height: height,
    );
  }

  pageSubtitle(String text){
    return Padding(
      padding: EdgeInsets.all(PaddingConfig.eight),
      child: CustomText(text: text,).underLine(),
    );
  }



  showSaveButton(BuildContext context){
    /// when the video is uploaded first, then the map has video as empty value,
    /// hence by setting state again, we are setting the value of isVideo as
    /// is given by BazaarProfileSetVideo class

    return CustomFloatingActionButtonWithIcon(
      iconName: IconConfig.forward,
      onPressed: () async{
        setState(() {
          if(locationFromMap != null) {
            widget.locationNotNull = true;
          }
        });


        if(widget.locationNotNull == true){
          /// adding location to cache, to show in edit profile
          cache[TextConfig.location] = locationFromMap;

          /// saving user as a bazaarwala in his shared preferences
          UserDetails().saveUserAsBazaarWalaInSharedPreferences(true);


          Map<String,dynamic> navigatorMap = new Map();
          navigatorMap[TextConfig.category] = widget.category;
          navigatorMap[TextConfig.categoryData] = widget.categoryData;
          navigatorMap[TextConfig.subCategoryMap] = widget.subCategoryMap;
          navigatorMap[TextConfig.subCategoriesList] = widget.listOfSubCategories;
          navigatorMap[TextConfig.subCategoriesListData] = widget.listOfSubCategoriesForData;
          navigatorMap[TextConfig.userName] = userName;
          navigatorMap[TextConfig.userPhoneNo] = userPhoneNo;
          navigatorMap[TextConfig.addListData] = widget.addListData;
          navigatorMap[TextConfig.deleteListData] = widget.deleteListData;
          navigatorMap[TextConfig.videoChanged] = widget.videoChanged;
          navigatorMap[TextConfig.videoURL] = widget.videoURL;
          navigatorMap[TextConfig.locationChanged] = locationChanged;
          navigatorMap[TextConfig.location] = widget.location;
          navigatorMap[TextConfig.radius] = widget.radius;
          navigatorMap[TextConfig.isBazaarWala] = widget.isBazaarWala;
          navigatorMap[TextConfig.aSubCategoryData] = widget.aSubCategoryData;

          Navigator.pushNamed(context, NavigatorConfig.changeBazaarPicturesFetchAndDisplay, arguments: navigatorMap);
        }else{
            CustomFlushBar(
              customContext: context,
              text: CustomText(text: TextConfig.selectLocationFlushbar,),
              iconName: IconConfig.stop,
              message: TextConfig.selectLocationFlushbar,
            ).showFlushBar();
        }
      },
    );
  }


}
