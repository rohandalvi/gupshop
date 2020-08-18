import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/bazaarIndividualCategoryListDisplay.dart';
import 'package:gupshop/bazaar/placeHolderImages.dart';
import 'package:gupshop/retriveFromFirebase/getBazaarWalasBasicProfileInfo.dart';
import 'package:gupshop/streamShortcuts/bazaarRatingNumbers.dart';

class BazaarIndividualCategoryNameDpBuilder extends StatelessWidget {
  String bazaarWalaPhoneNo;
  String category;

  BazaarIndividualCategoryNameDpBuilder({this.bazaarWalaPhoneNo, this.category});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder( ///use bazaarcategory to display people insted becuase bazaarwalabasicprofile is categorized by phoneNumber now
        stream: BazaarRatingNumbers(userNumber: bazaarWalaPhoneNo, categoryName: category).getRatingSnapshot(),
        builder: (context, streamSnapshot) {
          print("bazaarWalaPhoneNo in streambuilder: $bazaarWalaPhoneNo");
          if (streamSnapshot.data == null) return Center(child: CircularProgressIndicator()); //v v imp
          String name;
          String thumbnailPicture;

          print("bazaarWalaPhoneNo before futurebuilder: $bazaarWalaPhoneNo");
          return FutureBuilder(
            future: GetBazaarWalasBasicProfileInfo(userNumber: bazaarWalaPhoneNo).getNameAndThumbnailPicture(),
            builder: (BuildContext context, AsyncSnapshot nameSnapshot) {

              if (nameSnapshot.connectionState == ConnectionState.done) {
                name = nameSnapshot.data["name"];
                thumbnailPicture = nameSnapshot.data["thumbnailPicture"];

                if(thumbnailPicture == null ) thumbnailPicture = PlaceHolderImages().noDpPlaceholder;

                return BazaarIndividualCategoryListDisplay(
                  bazaarWalaName: name,
                  bazaarWalaPhoneNo: bazaarWalaPhoneNo,
                  category: category,
                  thumbnailPicture: thumbnailPicture,
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
