import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/bazaarOnBoarding/changeBazaarWalasPicturesDisplay.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/retriveFromFirebase/getBazaarWalasBasicProfileInfo.dart';

class ChangeBazaarWalasPicturesFetchDataAndDisplay extends StatelessWidget {
  final List<String> subCategoriesList;
  final List<String> subCategoriesListData;
  final Map<String, String> subCategoryMap;
  final String userName;
  final String userPhoneNo;
  final String category;
  final String categoryData;
  final List<String> deleteListData;
  final List<String> addListData;
  final bool videoChanged;
  final bool locationChanged;
  final String videoURL;
  final LatLng location;
  final double radius;


  ChangeBazaarWalasPicturesFetchDataAndDisplay({this.subCategoriesList,
    this.category, this.subCategoryMap, this.userPhoneNo, this.userName,
    this.categoryData, this.subCategoriesListData,this.addListData,
    this.deleteListData, this.locationChanged, this.videoChanged,
    this.location, this.videoURL, this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserDetails().getUserPhoneNoFuture(),
      builder: (BuildContext context, AsyncSnapshot userNumberSnapshot) {
        if (userNumberSnapshot.connectionState == ConnectionState.done) {

          String userNumber = userNumberSnapshot.data;
          String subCategoryData = subCategoriesListData[0];

          return FutureBuilder(
            future: GetBazaarWalasBasicProfileInfo(userNumber: userNumber,
                categoryData:categoryData,subCategoryData:subCategoryData).getPictureListAndVideo(),
            builder: (BuildContext context, AsyncSnapshot picturesSnapshot) {
              if (picturesSnapshot.connectionState == ConnectionState.done) {
                String thumbnailPicture;
                String otherPictureOne;
                String otherPictureTwo;

                if(picturesSnapshot.data == null){
                  thumbnailPicture  = null;
                  otherPictureTwo = null;
                  otherPictureTwo = null;
                }else{
                  thumbnailPicture = picturesSnapshot.data["thumbnailPicture"];
                  otherPictureOne = picturesSnapshot.data["otherPictureOne"];
                  otherPictureTwo = picturesSnapshot.data["otherPictureTwo"];
                }


                if(thumbnailPicture == null) thumbnailPicture =
                "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/pictureFrame.png?alt=media&token=d1167b50-9af6-4670-84aa-93ea4d55a8d3";

                if(otherPictureOne == null) otherPictureOne =
                "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/pictureFrame.png?alt=media&token=d1167b50-9af6-4670-84aa-93ea4d55a8d3";

                if(otherPictureTwo == null) otherPictureTwo =
                "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/pictureFrame.png?alt=media&token=d1167b50-9af6-4670-84aa-93ea4d55a8d3";

                return ChangeBazaarWalasPicturesDisplay(
                  thumbnailPicture: thumbnailPicture,
                  otherPictureOne: otherPictureOne,
                  otherPictureTwo: otherPictureTwo,
                  category: category,
                  categoryData: categoryData,
                  listOfSubCategories: subCategoriesList,
                  subCategoryMap: subCategoryMap,
                  userPhoneNo: userPhoneNo,
                  userName: userName,
                  listOfSubCategoriesForData: subCategoriesListData,
                  addListData: addListData,
                  deleteListData: deleteListData,
                  videoChanged: videoChanged,
                  videoURL: videoURL,
                  locationChanged: locationChanged,
                  location: location,
                  radius: radius,
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
