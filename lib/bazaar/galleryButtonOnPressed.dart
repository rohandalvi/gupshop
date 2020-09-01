import 'package:flutter/cupertino.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarWalasBasicProfileCollection.dart';
import 'package:gupshop/bazaar/galleryImagePickCropCreateURL.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToChangeBazaarPicturesFetchAndDisplay.dart';

class GalleryButtonOnPressed{
  String category;
  List<String> subCategoryDataList;

  GalleryButtonOnPressed({this.category, this.subCategoryDataList});


    thumbnailPicture(BuildContext context) async {
        String imageURL = await GalleryImagePickCropCreateURL().pickCropReturnURL();

        /// push to bazaarWalasBasicProfile collection:

        String userPhoneNo = await UserDetails().getUserPhoneNoFuture();
        if(imageURL != null){
          subCategoryDataList.forEach((subCategory) {
            PushToBazaarWalasBasicProfile(userPhoneNo: userPhoneNo, thumbnailPicture: imageURL).pushThumbnailPicture(category, subCategory);
          });

        }
        NavigateToChangeBazaarProfilePicturesFetchAndDisplay().navigateNoBrackets(context);

    }

    otherPictureOne(BuildContext context) async {
      String imageURL = await GalleryImagePickCropCreateURL().pickCropReturnURL();

      /// push to bazaarWalasBasicProfile collection:

      String userPhoneNo = await UserDetails().getUserPhoneNoFuture();

      if(imageURL != null){
        subCategoryDataList.forEach((subCategory) {
          PushToBazaarWalasBasicProfile(userPhoneNo: userPhoneNo, otherPictureOne: imageURL).pushOtherPictureOne(category, subCategory);
        });

      }
      NavigateToChangeBazaarProfilePicturesFetchAndDisplay().navigateNoBrackets(context);
    }

    otherPictureTwo(BuildContext context) async {
      String imageURL = await GalleryImagePickCropCreateURL().pickCropReturnURL();

      /// push to bazaarWalasBasicProfile collection:

      String userPhoneNo = await UserDetails().getUserPhoneNoFuture();

      if(imageURL != null){
        subCategoryDataList.forEach((subCategory) {
          PushToBazaarWalasBasicProfile(userPhoneNo: userPhoneNo, otherPictureTwo: imageURL).pushOtherPictureTwo(category, subCategory);
        });

      }
      NavigateToChangeBazaarProfilePicturesFetchAndDisplay().navigateNoBrackets(context);
    }
}
