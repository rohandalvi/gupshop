import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/PushToFirebase/pushToCategoriesMetadata.dart';
import 'package:gupshop/bazaar/bazaarProfileSetVideo.dart';
import 'package:gupshop/bazaar/bazaarWalasBasicProfile.dart';
import 'package:gupshop/bazaar/categories.dart';
import 'package:gupshop/bazaar/createMapFromListOfCategories.dart';
import 'package:gupshop/bazaar/setDocumentIdsForCollections.dart';
import 'package:gupshop/bazaar/bazaarProfileSetLocation.dart';
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
class BazaarProfilePage extends StatefulWidget {
  final String userPhoneNo;
  final String userName;

  BazaarProfilePage({@required this.userPhoneNo, @required this.userName});

  @override
  _BazaarProfilePageState createState() => _BazaarProfilePageState(userName: userName, userPhoneNo: userPhoneNo);
}

class _BazaarProfilePageState extends State<BazaarProfilePage> {
  final String userPhoneNo;
  final String userName;

  _BazaarProfilePageState({@required this.userPhoneNo, @required this.userName});

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

  Map<dynamic, dynamic> cache = new Map();

  Map<String, bool > map = new SplayTreeMap();/// make it set
  getCategorySizeFuture() async{
    QuerySnapshot querySnapshot = await Firestore.instance.collection("bazaarCategoryTypesAndImages").getDocuments();

    if(querySnapshot == null) return CircularProgressIndicator();//to avoid red screen(error)

    Map mapOfDocumentSnapshots = querySnapshot.documents.asMap();
    print("mapOfDocumentSnapshots : ${mapOfDocumentSnapshots[0].documentID}");
    mapOfDocumentSnapshots.forEach((key, value) {
      String categoryNames = mapOfDocumentSnapshots[key].documentID;
      map.putIfAbsent(categoryNames, () => false);
    });
    int size = querySnapshot.documents.length;
    print("map in getCategorySizeFuture: $map");
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

  selectVideo(){
    isVideo = new BazaarProfileSetVideo(userPhoneNo: userPhoneNo,
      videoURL: videoURL,
      videoSelected: videoSelected,
      video: video,
      cameraVideo: _cameraVideo,);

      cache["video"] = isVideo;
//      print("isVideo.videoSelected : ${isVideo.videoSelected}");
//      videoSelected = isVideo.videoSelected;

    return isVideo;
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
//    print("isVideo.isLocation : ${isLocation.locationSelected}");
//    locationSelected = isLocation.locationSelected;

    return isLocation;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: CustomAppBar(
            title: CustomText(text: 'Become a Bazaarwala', fontSize: 20,),
            onPressed:(){
              NavigateToHome(initialIndex: 1).navigateNoBrackets(context);
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
                    locationSelected = false;

                    isCategorySelected = true;
                  }

                  print("cache[video]: ${cache[video]}");

                  return ListView(
                      children: <Widget>[
                        /// video widgets:
                        pageSubtitle('Add Advertisement video : '),
                        cache["video"] == null ? selectVideo() : cache["video"],
                        createSpaceBetweenButtons(15),
                        pageSubtitle('Add Location : '),


                        /// location widgets:
                        cache["location"] == null ? selectLocation() :  cache["location"],

                        /// category widgets:
                        //if(isCategorySelected == true ) changeCategories(context),
                        pageSubtitle('Add categories : '),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CustomRaisedButton(child: CustomText(text: 'Categories:',),),
                            FutureBuilder(
                              future: GetCategoriesFromCategoriesMetadata().main(),
                              builder: (BuildContext context, AsyncSnapshot categorySnapshot) {
                                if (categorySnapshot.connectionState == ConnectionState.done) {
                                  /// if the user does not have bazaar profile yet:
                                  if(categorySnapshot.data != null){
                                    categoriesForBazaarWalasBasicProfile = categorySnapshot.data["categories"].cast<String>();///type 'List<dynamic>' is not a subtype of type 'List<String>'
                                  }
                                  ///create map here:
                                  map = CreateMapFromListOfCategories().createMap(categoriesForBazaarWalasBasicProfile, map);

                                  categorySelection = new Categories(map: map, isCategorySelected: isCategorySelected,);
                                  isCategorySelected = categorySelection.isCategorySelected;
                                  return categorySelection;
                                  //return getCategories(context);
                                }
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ],
                        ),
                      ]
                  );
                  } return CircularProgressIndicator();
                }
              ),
      floatingActionButton: showSaveButton(context),
    );
  }



  createSpaceBetweenButtons(double height){
    return SizedBox(
      height: height,
    );
  }

  pageSubtitle(String text){
    return CustomText(text: text,);
  }


  setLocationOtherThanCurrentAsHome(){
    return CustomRaisedButton(
      onPressed: (){
        Future<Position> location  = LocationServiceState().getLocation();//setting user's location
        location.then((val){
          setState(() {
            _bazaarWalaLocation = val;
            print("val in _bazaarWalaLocation: $val");
            print("_bazaarWalaLocation in initstate = $_bazaarWalaLocation");
            latitude = _bazaarWalaLocation.latitude;
            longitude =  _bazaarWalaLocation.longitude;
            locationSelected = false;
          });
        });
      },
      child: Text("Click to set other location as home location",style: GoogleFonts.openSans()),
    );
  }


  bool moveForward(bool isSelected) {
    bool result;
    if(isBazaarWala == true){
      result = true;
    }else {
      setState(() {

      });
      print("videoSelected : $videoSelected");
      print("locationSelected : $locationSelected");
      result = (videoSelected == true  && locationSelected == true);
      print("result : $result");
//      result = ((video != null || _cameraVideo != null ) && isSelected == true && _bazaarWalaLocation != null);
    }
    saveButtonVisible = result;
    return saveButtonVisible;
  }



  showSaveButton(BuildContext context){

      return CustomFloatingActionButtonWithIcon(
        iconName: 'forward2',
        onPressed: () async{
          setState(() {
            if(isVideo != null) videoSelected = isVideo.videoSelected;
            if(isLocation != null) locationSelected = isLocation.locationSelected;
            if(isCategorySelected != null) isCategorySelected = categorySelection.isCategorySelected;
          });
          if(locationSelected == true && videoSelected == true && isCategorySelected == true){
            await uploadVideoToFirestore();

            await pushTobazaarWalasLocationCategoryBasicProfile();

            ///push to bazaarWalasBasicProfile
            /// update and not add if edit profile
            await BazaarWalasBasicProfile(
              userPhoneNo: userPhoneNo, userName: userName,).pushToFirebase(
              videoURL, latitude, longitude,);

            print("categoriesForBazaarWalasBasicProfile : $categoriesForBazaarWalasBasicProfile");

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

  uploadVideoToFirestore() async{
    Firestore.instance.collection("videos").document(userPhoneNo).setData({'url':videoURL});
  }


  pushTobazaarWalasLocationCategoryBasicProfile() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection(
        "bazaarCategoryTypesAndImages").getDocuments();

    if (querySnapshot == null)
      return CircularProgressIndicator(); //to avoid red screen(error)

        /// creating new list to store in bazaarWalasBasicProfile

    print("map in push : ${map}");
    map.forEach((categoryNameInMap, value) async{
      print(" map : $categoryNameInMap : $value");
      String categoryName = categoryNameInMap;
      if(value == true){
        if(categoriesForBazaarWalasBasicProfile.contains(categoryName) == false){
          categoriesForBazaarWalasBasicProfile.add(categoryName);
        }


//        categoriesForBazaarWalasBasicProfile.add(categoryName);
        var result = {
          userPhoneNo: {
            'name': userName
          }
        };

        ///push to bazaarWalasLocation collection
        LocationServiceState().pushBazaarWalasLocationToFirebase(
            latitude, longitude, categoryName, userPhoneNo);

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
