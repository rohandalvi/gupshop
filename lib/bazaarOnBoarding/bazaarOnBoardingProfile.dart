import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarWalasLocation.dart';
import 'package:gupshop/PushToFirebase/pushToCategoriesMetadata.dart';
import 'package:gupshop/bazaar/bazaarProfileSetVideo.dart';
import 'package:gupshop/bazaar/bazaarWalasBasicProfile.dart';
import 'package:gupshop/bazaar/categories.dart';
import 'package:gupshop/bazaar/createMapFromListOfCategories.dart';
import 'package:gupshop/PushToFirebase/setDocumentIdsForCollections.dart';
import 'package:gupshop/bazaar/bazaarProfileSetLocation.dart';
import 'package:gupshop/bazaarOnBoarding/locationRadiusUI.dart';
import 'package:gupshop/bazaarOnBoarding/serviceAtHomeUI.dart';
import 'package:gupshop/cutomMaps/customMap.dart';
import 'package:gupshop/maps/maps.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/location/location_service.dart';
import 'package:gupshop/navigators/navigateToChangeBazaarPicturesFetchAndDisplay.dart';
import 'package:gupshop/navigators/navigateToCustomMap.dart';
import 'package:gupshop/navigators/navigateToHome.dart';
import 'package:gupshop/navigators/navigateToMaps.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/retriveFromFirebase/getCategoriesFromCategoriesMetadata.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';
import 'package:gupshop/widgets/customFlushBar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
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

  BazaarOnBoardingProfile({@required this.userPhoneNo, @required this.userName, this.category, this.listOfSubCategories});

  @override
  _BazaarOnBoardingProfileState createState() => _BazaarOnBoardingProfileState(userName: userName, userPhoneNo: userPhoneNo);
}

class _BazaarOnBoardingProfileState extends State<BazaarOnBoardingProfile> {
  final String userPhoneNo;
  final String userName;

  _BazaarOnBoardingProfileState({@required this.userPhoneNo, @required this.userName});


  double latitude;
  double longitude;

  /// for _pickVideoFromGallery
  File video;
  String videoURL;


  List<bool> inputs = new List<bool>();


  bool saveButtonVisible = false;

  File _cameraVideo;

  bool videoSelected = false;
  bool locationSelected = false;
  bool isBazaarWala;

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
      videoURL: videoURL,
      videoSelected: videoSelected,
      video: video,
      cameraVideo: _cameraVideo,);

    cache["video"] = isVideo;

    return isVideo;
  }

  cacheVideo(){
    setState(() {
      cache["video"] = isVideo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(WidgetConfig.appBarBazaarOnBoarding),
        child: CustomAppBar(
          title: CustomText(text: 'Become a Bazaarwala',),
          onPressed:(){
            //NavigateToHome(initialIndex: 1).navigateNoBrackets(context);
          },),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo).get(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              if(isBazaarWala == true){
                video = new File("videoURL");
                videoURL = snapshot.data["videoURL"];
                videoSelected = true;

                longitude = snapshot.data["longitude"];
                latitude = snapshot.data["latitude"];
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
                    Container(
                      width: WidgetConfig.sizedBoxBazaarOnBoarding,
                      child: CustomRaisedButton(
                        child: CustomText(text: 'Add location and service area',),
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
                      ),
                    ),


                    /// service offered location:
                    serviceWidget(),

                  ]
              );
            } return CircularProgressIndicator();
          }
      ),
      floatingActionButton: showSaveButton(context),
    );
  }

  serviceWidget(){
    service = new ServiceAtHome(text: 'Do you offer services at clients place ? ',);
    homeService = service.value;
    print("homeService : $homeService");
    return service;
  }


  createSpaceBetweenButtons(double height){
    return SizedBox(
      height: height,
    );
  }

  pageSubtitle(String text){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomText(text: text,),
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
          if(isVideo != null) videoSelected = isVideo.videoSelected;
          if(locationFromMap != null) locationSelected = true;
        });
        if(locationSelected == true && videoSelected == true ){
          await pushToVideoBazaarWalaLocationAndBasiCProfile();

          /// saving user as a bazaarwala in his shared preferences
          UserDetails().saveUserAsBazaarWalaInSharedPreferences(true);

          NavigateToChangeBazaarProfilePicturesFetchAndDisplay().navigateNoBrackets(context);
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
    widget.listOfSubCategories.forEach((subCategory) {
      LocationService().pushBazaarWalasLocationToFirebase(
        locationFromMap.latitude, locationFromMap.longitude,
          widget.category, userPhoneNo, subCategory, radius
      ).push();
    });
  }


  pushToVideoBazaarWalaLocationAndBasiCProfile() async{
    await uploadToVideoCollection();

    await pushTobazaarWalasLocation();

    await BazaarWalasBasicProfile(
      userPhoneNo: userPhoneNo, userName: userName,).pushToFirebase(
        isVideo.videoURL, locationFromMap.latitude, locationFromMap.longitude, radius);
  }

//  pushTobazaarWalasLocationCategory() async {
//    QuerySnapshot querySnapshot = await Firestore.instance.collection(
//        "bazaarCategoryTypesAndImages").getDocuments();
//
//    if (querySnapshot == null)
//      return CircularProgressIndicator(); //to avoid red screen(error)
//
//    /// creating new list to store in bazaarWalasBasicProfile
//
//    map.forEach((categoryNameInMap, value) async{
//      String categoryName = categoryNameInMap;
//      if(value == true){
//        if(categoriesForBazaarWalasBasicProfile.contains(categoryName) == false){
//          categoriesForBazaarWalasBasicProfile.add(categoryName);
//        }
//
//        var result = {
//          userPhoneNo: {
//            'name': userName
//          }
//        };
//
//        ///push to bazaarWalasLocation collection
//        /// also  push radius with location
//        LocationService().pushBazaarWalasLocationToFirebase(
//            locationFromMap.latitude, locationFromMap.longitude, categoryName, userPhoneNo);
//
//        ///push to bazaarCategories
//        ///if new user then dont merge, else merge
//        await Firestore.instance.collection("bazaarCategories").document(categoryName).setData(result, merge: true);
//
//        /// create some blank collections:
//        await SetDocumentIdsForCollections().setForBazaarRatingNumbers(userPhoneNo, categoryName);
//        await SetDocumentIdsForCollections().setForBazaarReviews(userPhoneNo);
//
//      }
//
//      if(value == false && categoriesForBazaarWalasBasicProfile.contains(categoryName) == true){
//        categoriesForBazaarWalasBasicProfile.remove(categoryName);
//      }
//    });
//  }
}
