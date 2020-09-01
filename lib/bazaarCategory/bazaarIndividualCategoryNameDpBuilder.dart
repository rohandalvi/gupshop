import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarCategory/bazaarIndividualCategoryListDisplay.dart';
import 'package:gupshop/bazaar/placeHolderImages.dart';
import 'package:gupshop/retriveFromFirebase/getBazaarWalasBasicProfileInfo.dart';
import 'package:gupshop/streamShortcuts/bazaarRatingNumbers.dart';

class BazaarIndividualCategoryNameDpBuilder extends StatelessWidget {
  String bazaarWalaPhoneNo;
  String category;
  String categoryData;
  String subCategory;
  String subCategoryData;

  BazaarIndividualCategoryNameDpBuilder({this.bazaarWalaPhoneNo, this.category,
    this.subCategory, this.subCategoryData, this.categoryData});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder( ///use bazaarcategory to display people insted becuase bazaarwalabasicprofile is categorized by phoneNumber now
        stream: BazaarRatingNumbers(userNumber: bazaarWalaPhoneNo, categoryName: category, subCategory: subCategory).getRatingSnapshot(),
        builder: (context, streamSnapshot) {
          print("categoryData in BazaarIndividualCategoryNameDpBuilder: $categoryData");
          print("category in BazaarIndividualCategoryNameDpBuilder: $category");
          if (streamSnapshot.data == null) return Center(child: CircularProgressIndicator()); //v v imp
          String name;
          String thumbnailPicture;

          print("bazaarWalaPhoneNo before futurebuilder: $bazaarWalaPhoneNo");
          return FutureBuilder(
            future: GetBazaarWalasBasicProfileInfo(
                userNumber: bazaarWalaPhoneNo,
              categoryData: categoryData,
              subCategoryData: subCategoryData
            ).getNameAndThumbnailPicture(),
            builder: (BuildContext context, AsyncSnapshot nameSnapshot) {

              if (nameSnapshot.connectionState == ConnectionState.done) {
                name = nameSnapshot.data["name"];
                thumbnailPicture = nameSnapshot.data["thumbnailPicture"];

                if(thumbnailPicture == null ) thumbnailPicture = PlaceHolderImages().noDpPlaceholder;

                return BazaarIndividualCategoryListDisplay(
                  bazaarWalaName: name,
                  bazaarWalaPhoneNo: bazaarWalaPhoneNo,
                  category: category,
                  categoryData: categoryData,
                  thumbnailPicture: thumbnailPicture,
                  subCategory: subCategory,
                  subCategoryData: subCategoryData,
                );
              }
              return Center(child: CircularProgressIndicator());
//                        BazaarIndividualCategoryListDisplay(
//                        bazaarWalaName: category.toString(),
//                        bazaarWalaPhoneNo: bazaarWalaPhoneNo,
//                        category: category,
//                        thumbnailPicture: PlaceHolderImages().bazaarWalaThumbnailPicture,
//                      );
            },
          );
        }
    );
  }
}
