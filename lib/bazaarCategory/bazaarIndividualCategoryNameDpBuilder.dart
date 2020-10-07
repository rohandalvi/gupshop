import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarCategory/bazaarIndividualCategoryListDisplay.dart';
import 'package:gupshop/bazaarHomeService/homeServiceText.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/retriveFromFirebase/getBazaarWalasBasicProfileInfo.dart';

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
  String businessName;
  String displayName;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetBazaarWalasBasicProfileInfo(userNumber: bazaarWalaPhoneNo,
          categoryData: categoryData,
          subCategoryData: subCategoryData)
          .getNameThumbnailPictureHomeService(),
      builder: (BuildContext context, AsyncSnapshot nameSnapshot) {
        if (nameSnapshot.connectionState == ConnectionState.done) {
          businessName = nameSnapshot.data[TextConfig.businessName];
          name = nameSnapshot.data[TextConfig.namebazaawalasBasicProfile];
          if(businessName != null){
            displayName = businessName;
          }else displayName = name;
          thumbnailPicture = nameSnapshot.data[TextConfig.thumbnailPicture];
          homeService = nameSnapshot.data[TextConfig.homeService];

          /// if homeService applicable and provides homeService:
          if (nameSnapshot.data[TextConfig.homeService] == true) {
            homeServiceText = HomeServiceText(
                categoryData: categoryData, subCategoryData: subCategoryData)
                .uiDisplayText();
          }

          /// if homeService applicable and does not provides homeService:
          else if (nameSnapshot.data[TextConfig.homeService] == false) {
            homeServiceText = HomeServiceText(
                categoryData: categoryData, subCategoryData: subCategoryData)
                .uiDisplayTextNo();
          }

          /// if homeService is not applicable:
          //else homeServiceText = null;

          if (thumbnailPicture == null)
            thumbnailPicture = ImageConfig.photoFrame;

          return BazaarIndividualCategoryListDisplay(
            bazaarWalaName: displayName,
            //bazaarWalaName: name,
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
