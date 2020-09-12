import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/bazaarOnBoarding/changeBazaarWalasPicturesDisplay.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/placeholders/imagePlaceholder.dart';
import 'package:gupshop/retriveFromFirebase/getBazaarWalasBasicProfileInfo.dart';

class ChangeBazaarWalasPicturesFetchDataAndDisplay extends StatelessWidget {
  final List<String> subCategoriesList;
  final List<String> subCategoriesListData;
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
  final bool isBazaarwala;
  final String aSubCategoryData;


  ChangeBazaarWalasPicturesFetchDataAndDisplay({this.subCategoriesList,
    this.category, this.subCategoryMap, this.userPhoneNo, this.userName,
    this.categoryData, this.subCategoriesListData,this.addListData,
    this.deleteListData, this.locationChanged, this.videoChanged,
    this.location, this.videoURL, this.radius,this.isBazaarwala,
    this.aSubCategoryData
  });

  @override
  Widget build(BuildContext context) {
      return FutureBuilder(
        future: GetBazaarWalasBasicProfileInfo(userNumber: userPhoneNo,
            categoryData:categoryData,subCategoryData:aSubCategoryData).getPictureListAndVideo(),
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


            if(thumbnailPicture == null) thumbnailPicture = ImagePlaceholder.photoFrame;

            if(otherPictureOne == null) otherPictureOne = ImagePlaceholder.photoFrame;

            if(otherPictureTwo == null) otherPictureTwo = ImagePlaceholder.photoFrame;
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
              isBazaarwala: isBazaarwala,
              aSubCategoryData: aSubCategoryData,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
  }
}
