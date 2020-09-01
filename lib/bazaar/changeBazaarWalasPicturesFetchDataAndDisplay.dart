import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/changeBazaarWalasPicturesDisplay.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/retriveFromFirebase/getBazaarWalasBasicProfileInfo.dart';

class ChangeBazaarWalasPicturesFetchDataAndDisplay extends StatelessWidget {
  final List<String> subCategoriesList;
  final Map<String, String> subCategoryMap;
  final String userName;
  final String userPhoneNo;
  final String category;
  final String categoryData;

  ChangeBazaarWalasPicturesFetchDataAndDisplay({this.subCategoriesList,
    this.category, this.subCategoryMap, this.userPhoneNo, this.userName,
    this.categoryData,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserDetails().getUserPhoneNoFuture(),
      builder: (BuildContext context, AsyncSnapshot userNumberSnapshot) {
        if (userNumberSnapshot.connectionState == ConnectionState.done) {

          String userNumber = userNumberSnapshot.data;

          return FutureBuilder(
            future: GetBazaarWalasBasicProfileInfo(userNumber: userNumber).getPictureListAndVideo(),
            builder: (BuildContext context, AsyncSnapshot picturesSnapshot) {
              if (picturesSnapshot.connectionState == ConnectionState.done) {
                String thumbnailPicture = picturesSnapshot.data["thumbnailPicture"];
                String otherPictureOne = picturesSnapshot.data["otherPictureOne"];
                String otherPictureTwo = picturesSnapshot.data["otherPictureTwo"];

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
                  subCategoriesList: subCategoriesList,
                  subCategoryMap: subCategoryMap,
                  userPhoneNo: userPhoneNo,
                  userName: userName,
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
