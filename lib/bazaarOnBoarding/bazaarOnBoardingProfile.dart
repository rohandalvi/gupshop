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
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/location/location_service.dart';
import 'package:gupshop/navigators/navigateToChangeBazaarPicturesFetchAndDisplay.dart';
import 'package:gupshop/navigators/navigateToCustomMap.dart';
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

  //final Future<List<DocumentSnapshot>> subCategoriesListFuture;
  Map<String, String> subCategoryMap;


  BazaarOnBoardingProfile({@required this.userPhoneNo, @required this.userName,
    this.category, this.listOfSubCategories, this.listOfSubCategoriesForData,
     this.subCategoryMap,this.categoryData,
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

  bool videoSelected = false;
  bool locationSelected = false;
  bool isBazaarWala;
  bool videoFromActualSelection;

  BazaarProfileSetVideo isVideo;
  LatLng locationFromMap;
  double radius;

  Categories categorySelection;
  ServiceAtHome service;
  bool homeService;

  Map<dynamic, dynamic> cache = new Map();



  @override
  void initState() {
    getIsBazaarWala();

    super.initState();
  }


  getIsBazaarWala() async{
    bool result= await UserDetails().getIsBazaarWalaInSharedPreferences();
    setState(() {
      isBazaarWala = result;
    });
  }

  selectVideo() {
    isVideo = BazaarProfileSetVideo(userPhoneNo: userPhoneNo,
      videoURL: databaseVideoURL,
      videoSelected: videoSelected,
      video: video,
      cameraVideo: _cameraVideo,);

    videoFromActualSelection = true;
    cache["video"] = isVideo;
    print("isVideo in selectVideo : $isVideo");
    print("isVideo.url in selectVideo : ${isVideo.videoURL}");

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
          preferredSize: Size.fromHeight(WidgetConfig.appBarBazaarOnBoarding),
          child: CustomAppBar(
            title: CustomText(text: 'Advertisement and Location',),
            onPressed:(){
              //NavigateToHome(initialIndex: 1).navigateNoBrackets(context);
            },),
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder(
            future: GetBazaarWalasBasicProfileInfo(
                userNumber: userPhoneNo,
                categoryData: widget.categoryData,
              subCategoryData: widget.listOfSubCategoriesForData[0],
            ).getVideoAndLocation(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                print("map in GetBazaarWalasBasicProfileInfo : ${snapshot.data}");
                if(snapshot.data != null){
                  video = new File("videoURL");
                  databaseVideoURL = snapshot.data["videoURL"];
//                  isVideo.videoURL = databaseVideoURL;
                  videoSelected = true;

                  databaseLongitude = snapshot.data["longitude"];
                  databaseLatitude = snapshot.data["latitude"];
//                  locationFromMap = new LatLng(databaseLatitude, databaseLongitude);
                  locationSelected = true;
                }

                return ListView(
                    children: <Widget>[
                      /// video widgets:
                      pageSubtitle('Add Advertisement video : '),
                      cache["video"] == null ? selectVideo() : cache["video"],

                      createSpaceBetweenButtons(15),
                      pageSubtitle('Add home Location : '),

                      /// location widgets:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomRaisedButton(
                              child: CustomText(text: 'Tap to add location and service area',),
                              onPressed: () async{
                                LocationData location;
                                var currentLocation = new Location();
                                location = await currentLocation.getLocation();

                                //Position location  = await LocationService().getLocation();

                                List list = await NavigateToCustomMap(
                                  latitude: location.latitude,
                                  longitude: location.longitude,
                                  showRadius: true,
                                ).navigateNoBrackets(context);

                                /// list[0] = location
                                /// list[1] = radius
                                locationFromMap = list[0];
                                radius = list[1];

                              },
                            ).elevated(),
                          ),
                          showLocation(),
                        ],
                      ),
                    ]
                );
              } return CircularProgressIndicator();
            }
        ),
        floatingActionButton: showSaveButton(context),
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
      padding: const EdgeInsets.all(8.0),
      child: CustomText(text: text,).underLine(),
    );
  }


  showLocation(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible: locationSelected == true,
        child: LocationService().showLocation(userName, databaseLatitude, databaseLatitude),
      ),
    );
  }

  isSubCategoryBazaarwalaWidget() async{
    bool isSubCategoryBazaarwala = await GetBazaarWalasBasicProfileInfo(
      userNumber: userPhoneNo,
      categoryData: widget.categoryData,
      subCategoryData: widget.listOfSubCategoriesForData[0],
    ).getIsBazaarwala();
    return isSubCategoryBazaarwala;
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
          if(isVideo != null) videoSelected = isVideo.videoSelected;
          if(locationFromMap != null) locationSelected = true;
        });

        if(locationSelected == true && videoSelected == true ){

          /// if he is already a bazaarwala and video or location is changed
          bool tempIsSubCategoryBazaarwala = await isSubCategoryBazaarwalaWidget();
          if(tempIsSubCategoryBazaarwala == true){
            if(videoFromActualSelection == true){
              /// then update
              widget.listOfSubCategoriesForData.forEach((subCategory) async{
                await UpdateBazaarWalasBasicProfile(
                  userPhoneNo: userPhoneNo,
                  categoryData: widget.categoryData,
                  subCategoryData: subCategory,
                ).updateVideo(isVideo.videoURL);
              });

            }
            if(locationFromMap != null){
              widget.listOfSubCategoriesForData.forEach((subCategory) async{
                await UpdateBazaarWalasBasicProfile(
                  userPhoneNo: userPhoneNo,
                  categoryData: widget.categoryData,
                  subCategoryData: subCategory,
                ).updateLocation(locationFromMap);
              });
            }
          }/// else if he adding for the first time and not editing the profile
          else await pushToVideoBazaarWalaLocationAndBasiCProfile();
          //await pushToVideoBazaarWalaLocationAndBasiCProfile();


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
          ).navigateNoBrackets(context);
        }else{
          if(locationSelected == false && videoSelected == false){
            CustomFlushBar(
              customContext: context,
              text: CustomText(text: 'Select Video and Location',),
              iconName: 'stopHand',
              message: 'Select Video,Location and Category',
            ).showFlushBar();
          }else if(locationSelected == false){
            CustomFlushBar(
              customContext: context,
              text: CustomText(text: 'Select Location',),
              iconName: 'stopHand',
              message: 'Select Location',
            ).showFlushBar();
          }else if(videoSelected == false){
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

  uploadToVideoCollection() async{
    Firestore.instance.collection("videos").document(userPhoneNo).setData({'url':isVideo.videoURL});
  }

  pushTobazaarWalasLocation(){
    if(locationFromMap != null){
      widget.listOfSubCategoriesForData.forEach((subCategory) {
        LocationService().pushBazaarWalasLocationToFirebase(
            locationFromMap.latitude, locationFromMap.longitude,
            widget.categoryData, userPhoneNo, subCategory, radius
        );
      });
    }
  }


  pushToVideoBazaarWalaLocationAndBasiCProfile() async{
    await uploadToVideoCollection();

    await pushTobazaarWalasLocation();

    widget.listOfSubCategoriesForData.forEach((subCategory) async{
      await PushToBazaarWalasBasicProfile(
          categoryData: widget.categoryData,
          subCategoryData: subCategory,
          userPhoneNo: userPhoneNo,
          userName: userName,
          videoURL: isVideo.videoURL,
          longitude: locationFromMap.longitude,
          latitude: locationFromMap.latitude,
          radius: radius,
      ).pushToFirebase();
    });

  }

}
