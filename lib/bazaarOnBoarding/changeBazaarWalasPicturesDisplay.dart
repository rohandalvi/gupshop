import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/bazaarOnBoarding/changeBazaarWalasPicturesAppBar.dart';
import 'package:gupshop/bazaarOnBoarding/pushToFirebase.dart';
import 'package:gupshop/navigators/navigateToBazaarSubCategorySearch.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';


class ChangeBazaarWalasPicturesDisplay extends StatefulWidget{
  final String thumbnailPicture;
  final String otherPictureOne;
  final String otherPictureTwo;

  final List<String> listOfSubCategoriesForData;
  final List<String> listOfSubCategories;
  final Map<String, String> subCategoryMap;
  final String userName;
  final String userPhoneNo;
  final String category;
  final String categoryData;
  final List<dynamic> deleteListData;
  final List<dynamic> addListData;
  final bool videoChanged;
  final bool locationChanged;
  final String videoURL;
  final LatLng location;
  final double radius;

  ChangeBazaarWalasPicturesDisplay({this.thumbnailPicture, this.otherPictureOne,
    this.otherPictureTwo, this.category, this.userName, this.userPhoneNo,
    this.listOfSubCategories, this.subCategoryMap,this.categoryData,
    this.listOfSubCategoriesForData,this.addListData, this.deleteListData,
    this.locationChanged, this.videoChanged,
    this.location, this.videoURL, this.radius,
  });

  @override
  _ChangeBazaarWalasPicturesDisplayState createState() => _ChangeBazaarWalasPicturesDisplayState();
}

class _ChangeBazaarWalasPicturesDisplayState extends State<ChangeBazaarWalasPicturesDisplay> with SingleTickerProviderStateMixin{
  TabController imagesController;
  int _activeTabIndex = 0;

  @override
  void initState() {
    imagesController = TabController(length: 3, vsync: this);
    imagesController.addListener(() {_setActiveTabIndex();});
    super.initState();
  }

  @override
  void dispose() {
    imagesController.dispose();
    super.dispose();
  }

  _setActiveTabIndex(){
    setState(() {
      _activeTabIndex =  imagesController.index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(WidgetConfig.appBarSeventy),
              child: ChangeBazaarWalasPicturesAppBar(tabNumber: _activeTabIndex,categoryData: widget.categoryData,subCategoryDataList: widget.listOfSubCategoriesForData,),
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(PaddingConfig.sixteen),
                child: Container(
                  height: WidgetConfig.twoFiftyHeight,
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        TabBarView(
                          controller: imagesController,
                          children: <Widget>[
                            /// thumbnailPicture:
                            Image(
                              image: NetworkImage(widget.thumbnailPicture),
                            ),
                            /// otherPictureOne:
                            Image(
                              image: NetworkImage(widget.otherPictureOne),
                            ),
                            /// otherPictureTwo:
                            Image(
                              image: NetworkImage(widget.otherPictureTwo),
                            ),
                          ],
                        ),
                        Container(
                          alignment: FractionalOffset(WidgetConfig.pointFive,WidgetConfig.pointNinetyFive),///placing the tabpagSelector at the bottom  center of the container
                          child: TabPageSelector(
                            controller: imagesController,///if this is not used then the images move but the tabpageSelector does not change the color of the tabs showing which image it is on
                            selectedColor: Colors.grey,///default color is blue
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButton: CustomFloatingActionButtonWithIcon(
              iconName: 'forward2',
              onPressed: () async{
                ///push all the data here

                PushToFirebase(
                  videoURL: widget.videoURL,
                  location: widget.location,
                  videoChanged: widget.videoChanged,
                  locationChanged: widget.locationChanged,
                  listOfSubCategories: widget.listOfSubCategories,
                  listOfSubCategoriesForData: widget.listOfSubCategoriesForData,
                  radius: widget.radius,
                  addListData: widget.addListData,
                  deleteListData: widget.deleteListData,
                  userPhoneNo: widget.userPhoneNo,
                  categoryData: widget.categoryData
                ).main();
//                /// this would happen if the user is already a bazaarwala
//                /// and is editing his profile but has not made any changes.
//                /// In such a case, no data has to pushed or deleted or
//                /// updated
//                if(widget.addListData == null && widget.deleteListData==null &&
//                  widget.isBazaarwala == true && widget.videoChanged == false &&
//                  widget.locationChanged == false){
//                  /// do nothing
//                }
//
//                else{
//                  /// if addList==null, deleteList==null & if isBazaarwala = false
//                  /// this would happen when :
//                  /// User is registering as a bazaarwala for the 1st time
//                  if(widget.addListData == null && widget.deleteListData==null &&
//                      widget.isBazaarwala == false && widget.videoChanged == true &&
//                      widget.locationChanged == true) {
//                    await pushSubCategoriesToFirebase(widget.listOfSubCategoriesForData);
//                  } else {
//                    /// if(addListData != null)
//                    /// eg : addList + videoChange + locationChange
//                    if(widget.addListData != null && widget.deleteListData != null){
//                      await pushSubCategoriesToFirebase(widget.addListData);
//                      await deleteUnselectedCategoriesFromDatabase(widget.deleteListData,
//                          widget.userPhoneNo);
//                    }
//                    else if(widget.addListData != null){
//                      await pushSubCategoriesToFirebase(widget.addListData);
//                    }
//
//                    /// if(deleteList != null)
//                    else if(widget.deleteListData != null){
//                      await deleteUnselectedCategoriesFromDatabase(widget.deleteListData,
//                          widget.userPhoneNo);
//                    }
//                    /// if(videoURLChanged == true)
//                    /// update all the categories in listOfSubCategoriesForData.
//                    /// This way even the addList would get covered and deleteList
//                    /// would be ignored
//                    if(widget.addListData == null && widget.deleteListData==null &&
//                        widget.videoChanged == true){
//                      await updateVideoInBazaarWalasBasicProfile(widget.listOfSubCategoriesForData);
//                    }
//
//
//                    /// if(locationChanged == true)
//                    if(widget.addListData == null && widget.deleteListData==null &&
//                        widget.locationChanged == true){
//                      await updateLocationInBazaarWalasBasicProfile(widget.listOfSubCategoriesForData);
//                    }
//
//                  }
//
//                  /// ========================== upto here ===================================///
//
//                  /// if firsttime
//                  /// this does not make sense anymore:
//                  pushToVideoBazaarWalaLocationAndBasiCProfile();
//
//                  /// same videoURL, categories deleted
//                  /// videoURLChanged == false , deleteListData != null
//                  /// delete the video from deleteListData
//
//                  /// same videoURL, categories added
//                  /// videoURLChanged == false , addListData != null
//                  /// push the the video to addListData
//
//
//                  /// same videoURL, categories not changed
//                  /// do nothing
//
//
//                  /// changed videoURL, categories deleted
//                  /// videoURLChanged == true , deleteListData != null
//                  /// delete video from deletedListData from
//                  /// video and basic profile collection.
//                  /// BasicProfile is getting deleted already when deleteUnselectedCategoriesFromDatabase
//                  /// is called.
//                  /// the subCategory in deleteListData has been already deleted
//                  /// by deleteUnselectedCategoriesFromDatabase method from
//                  /// video collection as well as basicProfile collection
//                  /// Hence, only update the new ones
//                  /// update:
//                  //updateVideoInBazaarWalasBasicProfile(widget.listOfSubCategoriesForData);
//
//                  /// changed videoURL, categories added
//                  /// videoURLChanged == true , addListData != null
//                  /// update video in listOfSubCategoriesForData in
//                  /// video and basic profile collection
//                  updateVideoInBazaarWalasBasicProfile(widget.listOfSubCategoriesForData);
//                }


                NavigateToBazaarSubCategorySearch(
                  categoryData: widget.categoryData,
                  category: widget.category,
                  subCategoriesList: widget.listOfSubCategories,
                  subCategoryMap: widget.subCategoryMap,
                  bazaarWalaName: widget.userName,
                  bazaarWalaPhoneNo: widget.userPhoneNo,
                ).navigateNoBrackets(context);
                //NavigateToViewProfileAsBazaarWalaSubCategories().navigateNoBrackets(context);
              },
            ),
          );
        }
      ),
    );
  }


//  /// video and location
//  updateVideoInBazaarWalasBasicProfile(List list){
//    list.forEach((subCategory) async{
//      await UpdateBazaarWalasBasicProfile(
//        userPhoneNo: widget.userPhoneNo,
//        categoryData: widget.categoryData,
//        subCategoryData: subCategory,
//      ).updateVideo(isVideo.videoURL);
//    });
//  }
//
//  updateLocationInBazaarWalasBasicProfile(List list){
//    list.forEach((subCategory) async{
//      await UpdateBazaarWalasBasicProfile(
//        userPhoneNo: widget.userPhoneNo,
//        categoryData: widget.categoryData,
//        subCategoryData: subCategory,
//      ).updateLocation(locationFromMap);
//    });
//  }


//  uploadToVideoCollection() async{
//    PushToVideoCollection(
//        userPhoneNo: widget.userPhoneNo,
//        categoryData: widget.categoryData,
//        subCategoryData: widget.,
//        videoURL: isVideo.videoURL
//    ).push();
//  }

//  pushTobazaarWalasLocation(){
//    if(locationFromMap != null){
//      widget.listOfSubCategoriesForData.forEach((subCategory) {
//        LocationService().pushBazaarWalasLocationToFirebase(
//            locationFromMap.latitude, locationFromMap.longitude,
//            widget.categoryData, userPhoneNo, subCategory, radius
//        );
//      });
//    }
//  }

 // pushToVideoBazaarWalaLocationAndBasiCProfile() async{
    //await uploadToVideoCollection();

    //await pushTobazaarWalasLocation();

//    widget.listOfSubCategoriesForData.forEach((subCategory) async{
//      await PushToBazaarWalasBasicProfile(
//        categoryData: widget.categoryData,
//        subCategoryData: subCategory,
//        userPhoneNo: widget.userPhoneNo,
//        userName: widget.userName,
//        videoURL: isVideo.videoURL,
//        longitude: locationFromMap.longitude,
//        latitude: locationFromMap.latitude,
//        radius: radius,
//      ).pushToFirebase();
//    });

  //}

//
//  /// only change in categories
//  pushSubCategoriesToFirebase(List listOfSubCategoriesData) async{
//    String userName = await UserDetails().getUserNameFuture();
//    String userNumber = await UserDetails().getUserPhoneNoFuture();
//
//
//    /// blank placeholders:
//
//    /// setting blank rating in ratings
//    await PushSubCategoriesToFirebase(category: widget.categoryData,userPhoneNo: userNumber,
//        userName: userName, listOfSubCategoriesData: widget.listOfSubCategoriesForData)
//        .createBlankRatingNumber();
//
//
//    /// setting blank review in reviews
//    await PushSubCategoriesToFirebase(category: widget.categoryData,userPhoneNo: userNumber,
//        userName: userName, listOfSubCategoriesData: widget.listOfSubCategoriesForData)
//        .createBlankReviews();
//
//
//    /// setting blank location in bazaarWalasLocation
//    await PushSubCategoriesToFirebase(category: widget.categoryData,userPhoneNo: userNumber,
//        userName: userName, listOfSubCategoriesData: widget.listOfSubCategoriesForData)
//        .blankBazaarWalasLocation();
//
//    /// blank placeholders end here
//
//
//
//    /// push to 5 collection:
//    ///
//    /// bazaarCategories
//    await PushSubCategoriesToFirebase(category: widget.categoryData,userPhoneNo: userNumber,
//        userName: userName, listOfSubCategoriesData: widget.listOfSubCategoriesForData)
//        .bazaarCategories();
//
//    /// bazaarCategoriesMetaData
//    await PushSubCategoriesToFirebase(category: widget.categoryData,userPhoneNo: userNumber,
//        userName: userName, listOfSubCategoriesData: widget.listOfSubCategoriesForData,
//        listOfSubCategories: widget.listOfSubCategories )
//        .bazaarCategoriesMetaData();
//
//
//    /// push to video collection
//    await PushSubCategoriesToFirebase(category: widget.categoryData,userPhoneNo: userNumber,
//        userName: userName, listOfSubCategoriesData: widget.listOfSubCategoriesForData,
//        videoURL: isVideo.videoURL
//      ).videoCollection();
//
//
//    /// push to bazaarwalasBasicProfile
//    await PushSubCategoriesToFirebase(category: widget.categoryData,userPhoneNo: userNumber,
//        userName: userName, listOfSubCategoriesData: widget.listOfSubCategoriesForData,
//        videoURL: isVideo.videoURL, location: locationFromMap, radius: radius
//    ).bazaarBasicProfile();
//
//
//    /// push Location
//    await PushSubCategoriesToFirebase(category: widget.categoryData,userPhoneNo: userNumber,
//        userName: userName, listOfSubCategoriesData: widget.listOfSubCategoriesForData,
//        location: locationFromMap, radius: radius
//    ).bazaarWalasLocation();
//  }
//
//
//  deleteUnselectedCategoriesFromDatabase(List deleteListData, String userNumber){
//
//    /// delete from 5 collections:
//    ///
//    DeleteSubcategriesFirebase(category: widget.categoryData,userNumber: userNumber,
//        listOfSubCategoriesData: deleteListData)
//        .bazaarCategories();
//
//    DeleteSubcategriesFirebase(category: widget.categoryData,userNumber: userNumber,
//        listOfSubCategoriesData: deleteListData)
//        .bazaarCategoriesMetadata();
//
//    DeleteSubcategriesFirebase(category: widget.categoryData,userNumber: userNumber,
//        listOfSubCategoriesData: deleteListData)
//        .bazaarBasicProfile();
//
//    /// delete from video collection
//
//
//    /// delete from bazaarWalasLocation collection
//
//
//  }
//
//
//  update(){
//
//  }
}
