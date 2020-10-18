import 'package:flutter/cupertino.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarWalasBasicProfileCollection.dart';
import 'package:gupshop/bazaar/galleryImagePickCropCreateURL.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToChangeBazaarPicturesFetchAndDisplay.dart';

class GalleryButtonOnPressed{
  String categoryData;
  List<String> subCategoryDataList;

  GalleryButtonOnPressed({this.categoryData, this.subCategoryDataList});


    thumbnailPicture(BuildContext context) async {
        String imageURL = await GalleryImagePickCropCreateURL().pickCropReturnURL(context);

        /// push to bazaarWalasBasicProfile collection:

        String userPhoneNo = await UserDetails().getUserPhoneNoFuture();
        if(imageURL != null){
          subCategoryDataList.forEach((subCategory) {
            PushToBazaarWalasBasicProfile(userPhoneNo: userPhoneNo, thumbnailPicture: imageURL).pushThumbnailPicture(categoryData, subCategory);
          });
          Navigator.pop(context,);
          return imageURL;
        }Navigator.pop(context,);


        //NavigateToChangeBazaarProfilePicturesFetchAndDisplay().navigateNoBrackets(context);

    }

    otherPictureOne(BuildContext context) async {
      String imageURL = await GalleryImagePickCropCreateURL().pickCropReturnURL(context);

      /// push to bazaarWalasBasicProfile collection:

      String userPhoneNo = await UserDetails().getUserPhoneNoFuture();

      if(imageURL != null){
        subCategoryDataList.forEach((subCategory) {
          PushToBazaarWalasBasicProfile(userPhoneNo: userPhoneNo, otherPictureOne: imageURL).pushOtherPictureOne(categoryData, subCategory);
        });
        Navigator.pop(context);
        return imageURL;
      }
      Navigator.pop(context);
      //NavigateToChangeBazaarProfilePicturesFetchAndDisplay().navigateNoBrackets(context);
    }

    otherPictureTwo(BuildContext context) async {
      String imageURL = await GalleryImagePickCropCreateURL().pickCropReturnURL(context);

      /// push to bazaarWalasBasicProfile collection:

      String userPhoneNo = await UserDetails().getUserPhoneNoFuture();

      if(imageURL != null){
        subCategoryDataList.forEach((subCategory) {
          PushToBazaarWalasBasicProfile(userPhoneNo: userPhoneNo, otherPictureTwo: imageURL).pushOtherPictureTwo(categoryData, subCategory);
        });
        Navigator.pop(context);
        return imageURL;
      }
      Navigator.pop(context);
      //NavigateToChangeBazaarProfilePicturesFetchAndDisplay().navigateNoBrackets(context);
    }
}
