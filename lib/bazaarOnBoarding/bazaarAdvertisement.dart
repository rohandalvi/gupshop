import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/bazaar/bazaarProfileSetVideo.dart';
import 'package:gupshop/bazaar/categories.dart';
import 'package:gupshop/bazaarOnBoarding/serviceAtHomeUI.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToBazaarLocation.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/retriveFromFirebase/getBazaarWalasBasicProfileInfo.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';
import 'package:gupshop/widgets/customFlushBar.dart';
import 'package:gupshop/widgets/customText.dart';


// bazaarHomeScreen=>
// =>CheckBoxCategorySelector
class BazaarAdvertisement extends StatefulWidget {
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


  BazaarAdvertisement({@required this.userPhoneNo, @required this.userName,
    this.category, this.listOfSubCategories, this.listOfSubCategoriesForData,
    this.subCategoryMap,this.categoryData,
    this.addListData, this.deleteListData
  });

  @override
  _BazaarAdvertisementState createState() => _BazaarAdvertisementState(userName: userName, userPhoneNo: userPhoneNo);
}

class _BazaarAdvertisementState extends State<BazaarAdvertisement> {
  final String userPhoneNo;
  final String userName;

  _BazaarAdvertisementState({@required this.userPhoneNo, @required this.userName});


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
  String addressName;


  @override
  void initState() {
    setState(() {
      aSubCategoryData = getASubcategoryName();
    });
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
            title: CustomText(text: TextConfig.bazaarAdvertisementTitle,),
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
            ).getVideoAndLocationRadius(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.data != null){
                  video = new File("videoURL");
                  databaseVideoURL = snapshot.data["videoURL"];
                  videoNotNull = true;

                  videoURL = databaseVideoURL;
                }

                return SafeArea(
                  bottom: false,
                  left: false,
                  right: false,
                  child: Column(
                      children: <Widget>[
                        /// video widgets:
                        Expanded(
                          flex: 1,
                          child:FittedBox(
                            child: whyAdvertisementWidget(TextConfig.bazaarAdvertisementIntro),
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: cache["video"] == null ? selectVideo() : cache["video"],
                        ),
                      ]
                  ),
                );
              } return CircularProgressIndicator();
            }
        ),
        floatingActionButton: showSaveButton(context),
      ),
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
        });


        if(videoNotNull == true ){
          /// saving user as a bazaarwala in his shared preferences
          UserDetails().saveUserAsBazaarWalaInSharedPreferences(true);

          Map data = await GetBazaarWalasBasicProfileInfo(
            userNumber: userPhoneNo,
            categoryData: widget.categoryData,
            subCategoryData: aSubCategoryData,
          ).getLocationRadiusAddressName();

          print("data in map : $data");
          if(data != null){
            databaseLongitude = data["longitude"];
            databaseLatitude = data["latitude"];
            addressName = data["addressName"];
            radius =data["radius"];

            location = new LatLng(databaseLatitude, databaseLongitude);
            locationNotNull = true;

            print("addressName in locationAddDisplay : $addressName");
          }


          NavigateToBazaarLocation(
            category: widget.category,
            categoryData: widget.categoryData,
            subCategoryMap: widget.subCategoryMap,
            userName: userName,
            userPhoneNo: userPhoneNo,
            addListData: widget.addListData,
            deleteListData: widget.deleteListData,
            videoChanged: videoChanged,
            videoURL: videoURL,
            aSubCategoryData: aSubCategoryData,
            databaseLatitude: databaseLatitude,
            databaseLongitude: databaseLongitude,
            listOfSubCategoriesForData: widget.listOfSubCategoriesForData,
            listOfSubCategories: widget.listOfSubCategories,
            addressName: addressName,
            radius: radius,
            location: location,
            locationNotNull: locationNotNull,
          ).navigateNoBrackets(context);
        }if(videoNotNull == false){
          CustomFlushBar(
            customContext: context,
            text: CustomText(text: 'Select Video',),
            iconName: 'stopHand',
            message: 'Select Video',
          ).showFlushBar();
          }
      },
    );
  }


//  createSpaceBetweenButtons(double height){
//    return SizedBox(
//      height: height,
//    );
//  }

  whyAdvertisementWidget(String text){
    return Align(
      alignment: Alignment.bottomCenter,
      child: CustomText(
        text: text,
        textAlign: TextAlign.center,
        textColor: subtitleGray,
      ).subTitle(),
    );
  }



}
