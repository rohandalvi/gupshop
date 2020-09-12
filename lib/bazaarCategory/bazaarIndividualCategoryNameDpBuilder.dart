import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarCategory/bazaarIndividualCategoryListDisplay.dart';
import 'package:gupshop/bazaarCategory/homeServiceText.dart';
import 'package:gupshop/placeholders/imagePlaceholder.dart';
import 'package:gupshop/retriveFromFirebase/getBazaarWalasBasicProfileInfo.dart';
import 'package:gupshop/streamShortcuts/bazaarRatingNumbers.dart';

class BazaarIndividualCategoryNameDpBuilder extends StatelessWidget {
  String bazaarWalaPhoneNo;
  String category;
  String categoryData;
  String subCategory;
  String subCategoryData;
  bool showHomeService;

  BazaarIndividualCategoryNameDpBuilder({this.bazaarWalaPhoneNo, this.category,
    this.subCategory, this.subCategoryData, this.categoryData, this.showHomeService
  });

  String name;
  String thumbnailPicture;
  bool homeService;
  String homeServiceText;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetBazaarWalasBasicProfileInfo(userNumber: bazaarWalaPhoneNo,
          categoryData: categoryData,
          subCategoryData: subCategoryData)
          .getNameThumbnailPictureHomeService(),
      builder: (BuildContext context, AsyncSnapshot nameSnapshot) {
        if (nameSnapshot.connectionState == ConnectionState.done) {
          name = nameSnapshot.data["name"];
          thumbnailPicture = nameSnapshot.data["thumbnailPicture"];
          homeService = nameSnapshot.data["homeService"];

          /// if homeService applicable and provides homeService:
          if (nameSnapshot.data["homeService"] == true) {
            homeServiceText = HomeServiceText(
                categoryData: categoryData, subCategoryData: subCategoryData)
                .uiDisplayText();
          }

          /// if homeService applicable and does not provides homeService:
          else if (nameSnapshot.data["homeService"] == false) {
            homeServiceText = HomeServiceText(
                categoryData: categoryData, subCategoryData: subCategoryData)
                .uiDisplayTextNo();
          }

          /// if homeService is not applicable:
          //else homeServiceText = null;

          if (thumbnailPicture == null)
            thumbnailPicture = ImagePlaceholder.photoFrame;

          return BazaarIndividualCategoryListDisplay(
            bazaarWalaName: name,
            bazaarWalaPhoneNo: bazaarWalaPhoneNo,
            category: category,
            categoryData: categoryData,
            thumbnailPicture: thumbnailPicture,
            subCategory: subCategory,
            subCategoryData: subCategoryData,
            homeServiceText: homeServiceText,
            homeServiceBool: homeService,
            showHomeServices: showHomeService,
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
