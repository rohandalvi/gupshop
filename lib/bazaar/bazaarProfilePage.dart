import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/PushToFirebase/pushToCategoriesMetadata.dart';
import 'package:gupshop/bazaar/bazaarWalasBasicProfile.dart';
import 'package:gupshop/bazaar/categories.dart';
import 'package:gupshop/bazaar/createMapFromListOfCategories.dart';
import 'package:gupshop/bazaar/setDocumentIdsForCollections.dart';
import 'package:gupshop/individualChat/messageCardDisplay.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/location/location_service.dart';
import 'package:gupshop/image/imagePickersDisplayPicturesFromURLorFile.dart';
import 'package:gupshop/navigators/navigateToChangeBazaarPicturesFetchAndDisplay.dart';
import 'package:gupshop/retriveFromFirebase/getCategoriesFromCategoriesMetadata.dart';
import 'package:gupshop/service/videoPicker.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';
import 'package:gupshop/widgets/customVideoPlayerThumbnail.dart';
import 'package:video_player/video_player.dart';

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
  bool locationSelected = true;
  bool isCategorySelected = false;
  bool isBazaarWala;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: CustomAppBar(
            title: CustomText(text: 'Become a Bazaarwala', fontSize: 20,),
            onPressed:(){
             Navigator.pop(context);
          },),
        ),
      backgroundColor: Colors.white,
      body:
//      FutureBuilder(
//        future: UserDetails().getIsBazaarWalaInSharedPreferences(),
//        builder: (context, snapshot) {
//          if(snapshot.connectionState == ConnectionState.done){
//            isBazaarWala = snapshot.data;

          FutureBuilder(
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

                  return ListView(
                   // shrinkWrap: true,
                      children: <Widget>[
                        /// video widgets:
//                        VideoPlayerAndSelectOptions(
//                          video: video,
//                          cameraVideo: _cameraVideo,
//                          videoURL: videoURL,
//                          videoSelected: videoSelected,
//                          isBazaarWala: isBazaarWala,
//                          userPhoneNo: userPhoneNo,
//                        ),
                        if((video != null || _cameraVideo != null)) Row(
                          children: <Widget>[
                            MessageCardDisplay().showVideo(videoURL,),
                            changeVideo(),
                          ],
                        ),
                        createSpaceBetweenButtons(15),
                        pageSubtitle(),
                        Visibility(
                          visible: (videoSelected == false),
                          child: setVideoFromGallery(),
                        ),
                        Visibility(
                          visible: (videoSelected == false),
                          child: or(),
                        ),
                        Visibility(
                          visible:(videoSelected == false),
                          child: setVideoFromCamera(),
                        ),

                        /// location widgets:
                        if(locationSelected == false ) Row(
                          children: <Widget>[
                            LocationServiceState().showLocation(userName, latitude, longitude),
                            changeLocation(),
                          ],
                        ),
                        Visibility(
                          visible: locationSelected,
                          child: setLocation(context),
                        ),
                        Visibility(
                          visible: locationSelected,
                          child: or(),
                        ),
                        Visibility(
                          visible: locationSelected,
                          child: setLocationOtherThanCurrentAsHome(),
                        ),

                        /// category widgets:
                        //if(isCategorySelected == true ) changeCategories(context),
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

                              return Categories(map: map, isCategorySelected: isCategorySelected,);
                              //return getCategories(context);
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),

                        /// show save button if everything is selected:
                        showSaveButton(context),
                      ]
                  );
                  } return CircularProgressIndicator();
                }
              ),
//          } return CircularProgressIndicator();
//        }
//      ),
    );
  }

  
  changeVideo(){
    return CustomRaisedButton(
      child: CustomText(text :'Change Video'),
      onPressed: (){
        setState(() {
          isBazaarWala = false;
          video = null;
          _cameraVideo = null;
          videoURL = null;
          videoSelected = false;
        });
      },
    );
  }

  changeLocation(){
    return CustomRaisedButton(
      child: CustomText(text :'Change Location'),
      onPressed: (){
        setState(() {
          isBazaarWala = false;
          _bazaarWalaLocation = null;
          latitude = null;
          longitude = null;
          locationSelected = true;
        });
      },
    );
  }

  changeCategories(BuildContext context){
    return CustomRaisedButton(
      child: CustomText(text :'Change Category'),
      onPressed: (){
        setState(() {
          isBazaarWala = false;
          /// to change from changeCategory button to select category button:
          isCategorySelected = false;
        });
      },
    );
  }

  createSpaceBetweenButtons(double height){
    return SizedBox(
      height: height,
    );
  }



  pageSubtitle(){
    return CustomText(text: 'Advertisement : ',);
  }


  setVideoFromGallery(){
    return CustomRaisedButton(
      onPressed: (){
        _pickVideoFromGallery();
      },
      child: Text("Choose a video from Gallery",style: GoogleFonts.openSans()),
    );
  }
  /// used in setVideoFromGallery(),
  _pickVideoFromGallery() async{
    File _video = await VideoPicker().pickVideoFromGallery();
    video = _video;
    String url = await ImagesPickersDisplayPictureURLorFile().getVideoURL(video, userPhoneNo, null);
    setState(() {
      videoURL = url;
      videoSelected = true;
    });
  }


  or(){
    return Text('or',style: GoogleFonts.openSans());
  }


  setVideoFromCamera(){
    return RaisedButton(
      onPressed: (){
        _pickVideoFromCamer();
      },
      child: Text("Record from camera",style: GoogleFonts.openSans()),
    );
  }
  _pickVideoFromCamer() async{
    File _video = await VideoPicker().pickVideoFromCamer();
    _cameraVideo = _video;
    String url = await ImagesPickersDisplayPictureURLorFile().getVideoURL(_cameraVideo, userPhoneNo, null);
    setState(() {
      videoURL = url;
      videoSelected = true;
    });
  }


  setLocation(BuildContext context){/// use usersLocation.dart
    return RaisedButton(
      onPressed: () async{
        Position location  = await LocationServiceState().getLocation();//setting user's location
          setState(() {
            _bazaarWalaLocation = location;

            latitude = _bazaarWalaLocation.latitude;
            longitude =  _bazaarWalaLocation.longitude;

            Flushbar( /// for the flushBar if the user enters wrong verification code
              icon: SvgPicture.asset(
                'images/stopHand.svg',
                width: 30,
                height: 30,
              ),
              backgroundColor: Colors.white,
              duration: Duration(seconds: 5),
              forwardAnimationCurve: Curves.decelerate,
              reverseAnimationCurve: Curves.easeOut,
              titleText: Text(
                'Currenr Location saved as Home Location',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ourBlack,
                  ),
                ),
              ),
              message: "Please enter your name to move forward",
            )..show(context);
            //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Currenr Location saved as Home Location '),));

          });

        setState(() {
          locationSelected = false;
        });

      },
      child: Text("Click to set current location as home location",style: GoogleFonts.openSans()),
    );
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
      result = ((video != null || _cameraVideo != null) && isSelected == true && _bazaarWalaLocation != null);
    print("Video : $video} and Camera: $_cameraVideo and IsSelected: $isSelected and bazaarwalalocation: $_bazaarWalaLocation");
    print("result : $result");
    print("bazaarwala location : $_bazaarWalaLocation");
    print("latitude: $latitude");
    print("result : $result");
//    setState(() {
      saveButtonVisible = result;
//    });
    return saveButtonVisible;
  }



  showSaveButton(BuildContext context){
    bool isVisible;
//    setState(() {
      isVisible = moveForward(isCategorySelected);
//    });
    return Visibility(
      visible: isVisible,
      child: CustomRaisedButton(
        onPressed: () async{
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

//          Navigator.push(
//              context,
//              MaterialPageRoute(//todo- category is hardcoded here, we need to one category to ProductDetail page from the categories selected
//                builder: (context) => ProductDetail(productWalaName: userName, category: categoryName, productWalaNumber: userPhoneNo,),//pass Name() here and pass Home()in name_screen
//              )
//          );
        },
        child: CustomText(text: 'Click to add Advertisement Pictures',),
      ),
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
