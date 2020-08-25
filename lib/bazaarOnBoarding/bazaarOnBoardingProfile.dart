import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gupshop/PushToFirebase/pushToCategoriesMetadata.dart';
import 'package:gupshop/bazaar/bazaarProfileSetVideo.dart';
import 'package:gupshop/bazaar/bazaarWalasBasicProfile.dart';
import 'package:gupshop/bazaar/categories.dart';
import 'package:gupshop/bazaar/createMapFromListOfCategories.dart';
import 'package:gupshop/bazaar/setDocumentIdsForCollections.dart';
import 'package:gupshop/bazaar/bazaarProfileSetLocation.dart';
import 'package:gupshop/bazaarOnBoarding/locationRadiusUI.dart';
import 'package:gupshop/bazaarOnBoarding/serviceAtHomeUI.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/location/location_service.dart';
import 'package:gupshop/navigators/navigateToChangeBazaarPicturesFetchAndDisplay.dart';
import 'package:gupshop/navigators/navigateToHome.dart';
import 'package:gupshop/retriveFromFirebase/getCategoriesFromCategoriesMetadata.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';
import 'package:gupshop/widgets/customFlushBar.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';


// bazaarHomeScreen=>
// =>CheckBoxCategorySelector
class BazaarOnBoardingProfile extends StatefulWidget {
  final String userPhoneNo;
  final String userName;

  BazaarOnBoardingProfile({@required this.userPhoneNo, @required this.userName});

  @override
  _BazaarOnBoardingProfileState createState() => _BazaarOnBoardingProfileState(userName: userName, userPhoneNo: userPhoneNo);
}

class _BazaarOnBoardingProfileState extends State<BazaarOnBoardingProfile> {
  final String userPhoneNo;
  final String userName;

  _BazaarOnBoardingProfileState({@required this.userPhoneNo, @required this.userName});

  Position _bazaarWalaLocation;
  double latitude;
  double longitude;

  /// for _pickVideoFromGallery
  File video;
  String videoURL;


  List<bool> inputs = new List<bool>();
  List<String> categoriesForBazaarWalasBasicProfile = new List();

  int categorySize;
  bool saveButtonVisible = false;

  File _cameraVideo;

  bool videoSelected = false;
  bool locationSelected = false;
  bool isCategorySelected = false;
  bool isBazaarWala;

  BazaarProfileSetVideo isVideo;
  BazaarProfileSetLocation isLocation;
  Categories categorySelection;
  ServiceAtHome service;
  bool homeService;

  Map<dynamic, dynamic> cache = new Map();

  Map<String, bool > map = new SplayTreeMap();/// make it set
  getCategorySizeFuture() async{
    QuerySnapshot querySnapshot = await Firestore.instance.collection("bazaarCategoryTypesAndImages").getDocuments();

    if(querySnapshot == null) return CircularProgressIndicator();//to avoid red screen(error)

    Map mapOfDocumentSnapshots = querySnapshot.documents.asMap();

    mapOfDocumentSnapshots.forEach((key, value) {
      String categoryNames = mapOfDocumentSnapshots[key]["name"];
      map.putIfAbsent(categoryNames, () => false);
    });
    int size = querySnapshot.documents.length;
    return size;
  }

  initializeList(List<bool>inputs ) async{
    int size = await getCategorySizeFuture();
    setState(() {
      for(int i =0; i<size; i++){//initializing the array inputs to false for showing nothing selected when the checkbox pops up for the 1st time
        inputs.add(false);
      }
    });
  }


  @override
  void initState() {
    //getUserPhone();
    initializeList(inputs);

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

  selectLocation(){
    isLocation = new BazaarProfileSetLocation(
      bazaarWalaLocation: _bazaarWalaLocation,
      locationSelected: locationSelected,
      longitude: longitude,
      latitude: latitude,
      userName : userName,
    );

    cache["location"] = isLocation;

    return isLocation;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
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
                _bazaarWalaLocation = new Position(longitude: longitude, latitude: latitude);
                locationSelected = true;

                isCategorySelected = true;
              }

              return ListView(
                  children: <Widget>[
                    /// video widgets:
                    pageSubtitle('Add Advertisement video : '),
                    cache["video"] == null ? selectVideo() : cache["video"],

                    createSpaceBetweenButtons(15),
                    pageSubtitle('Add home Location : '),

                    /// location widgets:
                    cache["location"] == null ? selectLocation() :  cache["location"],

                    /// radius widgets:
                    pageSubtitle('How far do you offer services :  '),
                    LocationRadiusUI(),

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


  setLocationOtherThanCurrentAsHome(){
    return CustomRaisedButton(
        onPressed: (){
          Future<Position> location  = LocationService().getLocation();//setting user's location
          location.then((val){
            setState(() {
              _bazaarWalaLocation = val;
              latitude = _bazaarWalaLocation.latitude;
              longitude =  _bazaarWalaLocation.longitude;
              locationSelected = false;
            });
          });
        },
        child: CustomText(text: "Click to set other location as home location",)
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
          if(isLocation != null) locationSelected = isLocation.locationSelected;
          if(isCategorySelected != null) isCategorySelected = categorySelection.isCategorySelected;
        });
        if(locationSelected == true && videoSelected == true && isCategorySelected == true){
          await uploadToVideoCollection();


          await pushTobazaarWalasLocationCategory();

          ///push to bazaarWalasBasicProfile
          /// update and not add if edit profile
          await BazaarWalasBasicProfile(
            userPhoneNo: userPhoneNo, userName: userName,).pushToFirebase(
            isVideo.videoURL, isLocation.latitude, isLocation.longitude,);

          await PushToCategoriesMatedata(userNumber: userPhoneNo, categories: categoriesForBazaarWalasBasicProfile).push();

          /// saving user as a bazaarwala in his shared preferences
          UserDetails().saveUserAsBazaarWalaInSharedPreferences(true);

          NavigateToChangeBazaarProfilePicturesFetchAndDisplay().navigateNoBrackets(context);
        }else{
          if(locationSelected == false && videoSelected == false && isCategorySelected == false){
            CustomFlushBar(
              customContext: context,
              text: CustomText(text: 'Select Video,Location and Category',),
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
          }else if(isCategorySelected == false){
            CustomFlushBar(
              customContext: context,
              text: CustomText(text: 'Select Category',),
              iconName: 'stopHand',
              message: 'Select Category',
            ).showFlushBar();
          }

        }
      },
    );
  }

  uploadToVideoCollection() async{
    Firestore.instance.collection("videos").document(userPhoneNo).setData({'url':isVideo.videoURL});
  }


  pushTobazaarWalasLocationCategory() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection(
        "bazaarCategoryTypesAndImages").getDocuments();

    if (querySnapshot == null)
      return CircularProgressIndicator(); //to avoid red screen(error)

    /// creating new list to store in bazaarWalasBasicProfile

    map.forEach((categoryNameInMap, value) async{
      String categoryName = categoryNameInMap;
      if(value == true){
        if(categoriesForBazaarWalasBasicProfile.contains(categoryName) == false){
          categoriesForBazaarWalasBasicProfile.add(categoryName);
        }

        var result = {
          userPhoneNo: {
            'name': userName
          }
        };

        ///push to bazaarWalasLocation collection
        LocationService().pushBazaarWalasLocationToFirebase(
            isLocation.latitude, isLocation.longitude, categoryName, userPhoneNo);

        ///push to bazaarCategories
        ///if new user then dont merge, else merge
        await Firestore.instance.collection("bazaarCategories").document(categoryName).setData(result, merge: true);

        /// create some blank collections:
        await SetDocumentIdsForCollections().setForBazaarRatingNumbers(userPhoneNo, categoryName);
        await SetDocumentIdsForCollections().setForBazaarReviews(userPhoneNo);

      }

      if(value == false && categoriesForBazaarWalasBasicProfile.contains(categoryName) == true){
        categoriesForBazaarWalasBasicProfile.remove(categoryName);
      }
    });
  }
}
