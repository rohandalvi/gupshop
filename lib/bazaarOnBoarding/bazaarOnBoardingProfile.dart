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
            ).main(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                isBazaarWala = false;
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
                    ]
                );
              } return CircularProgressIndicator();
            }
        ),
        floatingActionButton: showSaveButton(context),
      ),
    );
  }

//  homeServiceDialog() async{
//    if(homeService == null ){
//      String homeServiceText;
//
//      widget.listOfSubCategoriesForData.forEach((subCategory) {
//        homeServiceText = HomeServiceText(categoryData:widget.categoryData,
//            subCategoryData: subCategory).bazaarWalasdialogText();
//      });
//
//
//
//      bool temp = await CustomDialogForConfirmation(
//        /// from homeServiceText
//        title: 'Do you offer services at clients home',
//      ).dialog(context);
//      return temp;
//    }
//
//
//    widget.listOfSubCategoriesForData.forEach((subCategory) async{
//      await PushToBazaarWalasBasicProfile(
//        categoryData: widget.categoryData,
//        subCategoryData: subCategory,
//        userPhoneNo: userPhoneNo,
//        userName: userName,
//        videoURL: isVideo.videoURL,
//        longitude: locationFromMap.longitude,
//        latitude: locationFromMap.latitude,
//        radius: radius,
//        homeService: homeService,
//      ).pushToFirebase();
//    });
//  }


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

        //homeService = await homeServiceDialog();


        setState(() {
          if(isVideo != null) videoSelected = isVideo.videoSelected;
          if(locationFromMap != null) locationSelected = true;
        });
        if(locationSelected == true && videoSelected == true ){
          await pushToVideoBazaarWalaLocationAndBasiCProfile();

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
    widget.listOfSubCategoriesForData.forEach((subCategory) {
      LocationService().pushBazaarWalasLocationToFirebase(
        locationFromMap.latitude, locationFromMap.longitude,
          widget.categoryData, userPhoneNo, subCategory, radius
      );
    });
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

  pushTosubCategoryInFirebase()async{
    if(widget.categoryData == "deliveryErrands") {

      String userNumber = await UserDetails().getUserPhoneNoFuture();

      PushSubCategoriesToFirebase(category: widget.categoryData,userPhoneNo: userNumber,
          userName: userName, list: widget.listOfSubCategoriesForData
      ).bazaarCategories();

      PushSubCategoriesToFirebase(category: widget.categoryData,userPhoneNo: userNumber,
          userName: userName, list: widget.listOfSubCategoriesForData
      ).bazaarCategoriesMetaData();

      PushSubCategoriesToFirebase(category: widget.categoryData,userPhoneNo: userNumber,
          userName: userName, list: widget.listOfSubCategoriesForData
      ).createBlankRatingNumber();

      PushSubCategoriesToFirebase(category: widget.categoryData,userPhoneNo: userNumber,
          userName: userName, list: widget.listOfSubCategoriesForData
      ).createBlankReviews();

      PushSubCategoriesToFirebase(category: widget.categoryData,userPhoneNo: userNumber,
          userName: userName, list: widget.listOfSubCategoriesForData
      ).bazaarWalasLocation();
    }
  }

}
