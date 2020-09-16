import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarWalasBasicProfileCollection.dart';
import 'package:gupshop/bazaar/bazaarProfileSetVideo.dart';
import 'package:gupshop/bazaar/categories.dart';
import 'package:gupshop/bazaarCategory/homeServiceText.dart';
import 'package:gupshop/bazaarOnBoarding/pushSubCategoriesToFirebase.dart';
import 'package:gupshop/bazaarOnBoarding/serviceAtHomeUI.dart';
import 'package:gupshop/location/locationPermissionHandler.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/location/location_service.dart';
import 'package:gupshop/navigators/navigateToChangeBazaarPicturesFetchAndDisplay.dart';
import 'package:gupshop/navigators/navigateToCustomMap.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/retriveFromFirebase/getBazaarWalasBasicProfileInfo.dart';
import 'package:gupshop/updateInFirebase/updateBazaarWalasBasicProfile.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customDialogForConfirmation.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';
import 'package:gupshop/widgets/customFlushBar.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:location/location.dart';


// bazaarHomeScreen=>
// =>CheckBoxCategorySelector
class BazaarOnBoardingProfile extends StatefulWidget {
  final String userPhoneNo;
  final String userName;
  final List<String> listOfSubCategories;
  final String category;
  final String categoryData;
  List<String> listOfSubCategoriesForData;
  final List<dynamic> deleteListData;
  final List<dynamic> addListData;



  //final Future<List<DocumentSnapshot>> subCategoriesListFuture;
  Map<String, String> subCategoryMap;


  BazaarOnBoardingProfile({@required this.userPhoneNo, @required this.userName,
    this.category, this.listOfSubCategories, this.listOfSubCategoriesForData,
     this.subCategoryMap,this.categoryData,
    this.addListData, this.deleteListData
  });

  @override
  _BazaarOnBoardingProfileState createState() => _BazaarOnBoardingProfileState(userName: userName, userPhoneNo: userPhoneNo);
}

class _BazaarOnBoardingProfileState extends State<BazaarOnBoardingProfile> {
  final String userPhoneNo;
  final String userName;

  _BazaarOnBoardingProfileState({@required this.userPhoneNo, @required this.userName});


  double databaseLatitude;
  double databaseLongitude;

  /// for _pickVideoFromGallery
  File video;
  String databaseVideoURL;

  List<bool> inputs = new List<bool>();


  bool saveButtonVisible = false;

  File _cameraVideo;

  bool videoNotNull = false;
  bool locationNotNull = false;
  bool isBazaarWala;

  /// to know if the video is changed
  bool videoPicked;

  /// for creating local cache
  BazaarProfileSetVideo isVideo;

  LatLng locationFromMap;
  double radius;

  Categories categorySelection;
  ServiceAtHome service;
  bool homeService;

  Map<dynamic, dynamic> cache = new Map();

  String videoURL;
  bool videoChanged;
  LatLng location;
  bool locationChanged;

  String aSubCategoryData;


  @override
  void initState() {
//    getIsBazaarWala();

    setState(() {
      aSubCategoryData = getASubcategoryName();
    });
    super.initState();

    print("deleteList in init : ${widget.deleteListData}");
    print("addList in init : ${widget.addListData}");

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

//  getIsBazaarWala() async{
//    bool result= await UserDetails().getIsBazaarWalaInSharedPreferences();
//    setState(() {
//      isBazaarWala = result;
//    });
//  }

  selectVideo() {
    isVideo = BazaarProfileSetVideo(userPhoneNo: userPhoneNo,
      videoURL: databaseVideoURL,
      videoSelected: videoNotNull,
      video: video,
      cameraVideo: _cameraVideo,);

    videoPicked = true;
    cache["video"] = isVideo;

    videoChanged = true;

    return isVideo;
  }

  cacheVideo(){
    setState(() {
      cache["video"] = isVideo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(WidgetConfig.appBarSeventy),
          child: CustomAppBar(
            title: CustomText(text: 'Advertisement and Location',),
            onPressed:(){
              Navigator.pop(context);
              //NavigateToHome(initialIndex: 1).navigateNoBrackets(context);
            },),
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder(
            future: GetBazaarWalasBasicProfileInfo(
                userNumber: userPhoneNo,
                categoryData: widget.categoryData,
                subCategoryData: aSubCategoryData,
//              subCategoryData: widget.listOfSubCategoriesForData[0],
            ).getVideoAndLocationRadius(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.data != null){
                  video = new File("videoURL");
                  databaseVideoURL = snapshot.data["videoURL"];
//                  isVideo.videoURL = databaseVideoURL;
                  videoNotNull = true;

                  videoURL = databaseVideoURL;

                  databaseLongitude = snapshot.data["longitude"];
                  databaseLatitude = snapshot.data["latitude"];
                  location = new LatLng(databaseLatitude, databaseLongitude);
                  locationNotNull = true;
                  radius =snapshot.data["radius"];
                }

                return ListView(
                    children: <Widget>[
                      /// video widgets:
                      pageSubtitle('Add Advertisement video : '),
                      cache["video"] == null ? selectVideo() : cache["video"],

                      createSpaceBetweenButtons(15),
                      pageSubtitle('Add home Location : '),

                      /// location widgets:
                      locationAddDisplay(context),
                    ]
                );
              } return CircularProgressIndicator();
            }
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
              child: CustomText(text: 'Tap to add location and service area',),
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
                        title: Text('Loading map'),
                        content: Center(child: CircularProgressIndicator()),
                      ));


                  var currentLocation = new Location();
                  locationTemp = await currentLocation.getLocation();

                  List list = await NavigateToCustomMap(
                    latitude: locationTemp.latitude,
                    longitude: locationTemp.longitude,
                    showRadius: true,
                  ).navigateNoBrackets(context);

                  /// for exiting dialog:
                  Navigator.pop(context);

                  /// list[0] = location
                  /// list[1] = radius
                  locationFromMap = list[0];
                  radius = list[1];

                  location = locationFromMap;
                  locationChanged = true;

                  /// setState to make the locationNotNull = true so that
                  /// showLocation() becomes visible
                  setState(() {
                    locationNotNull = true;
                  });
                }
              },
            ).elevated(),
          ),
        showLocation(),
      ],
    );
  }

  showLocation(){
    return Padding(
      padding: EdgeInsets.all(PaddingConfig.eight),
      child: Visibility(
        visible: locationNotNull == true,
        child: LocationService().showLocation(userName, databaseLatitude, databaseLatitude),
      ),
    );
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
    cacheVideo();

    return CustomFloatingActionButtonWithIcon(
      iconName: 'forward2',
      onPressed: () async{
        setState(() {
          if(isVideo != null) {
            videoNotNull = isVideo.videoSelected;
            videoURL = isVideo.videoURL;
          }
          if(locationFromMap != null) {
            locationNotNull = true;
          }
        });


        if(locationNotNull == true && videoNotNull == true ){
          /// adding location to cache, to show in edit profile
          cache["location"] = locationFromMap;

          /// saving user as a bazaarwala in his shared preferences
          UserDetails().saveUserAsBazaarWalaInSharedPreferences(true);

          NavigateToChangeBazaarProfilePicturesFetchAndDisplay(
            category: widget.category,
            categoryData: widget.categoryData,
            subCategoryMap: widget.subCategoryMap,
            subCategoriesList: widget.listOfSubCategories,
            subCategoriesListData: widget.listOfSubCategoriesForData,
            userName: userName,
            userPhoneNo: userPhoneNo,
            addListData: widget.addListData,
            deleteListData: widget.deleteListData,
            videoChanged: videoChanged,
            videoURL: videoURL,
            locationChanged: locationChanged,
            location: location,
            radius: radius,
            isBazaarwala: isBazaarWala,
            aSubCategoryData: aSubCategoryData
          ).navigateNoBrackets(context);
        }else{
          if(locationNotNull == false && videoNotNull == false){
            CustomFlushBar(
              customContext: context,
              text: CustomText(text: 'Select Video and Location',),
              iconName: 'stopHand',
              message: 'Select Video,Location and Category',
            ).showFlushBar();
          }else if(locationNotNull == false){
            CustomFlushBar(
              customContext: context,
              text: CustomText(text: 'Select Location',),
              iconName: 'stopHand',
              message: 'Select Location',
            ).showFlushBar();
          }else if(videoNotNull == false){
            CustomFlushBar(
              customContext: context,
              text: CustomText(text: 'Select Video',),
              iconName: 'stopHand',
              message: 'Select Video',
            ).showFlushBar();
          }
        }
      },
    );
  }


}
