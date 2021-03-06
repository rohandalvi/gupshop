import 'package:flutter/cupertino.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarWalasBasicProfileCollection.dart';
import 'package:gupshop/bazaar/cameraImagePickCropCreateURL.dart';
import 'package:gupshop/modules/userDetails.dart';


class CameraButtonOnPressed{
  String categoryData;
  List<String> subCategoryDataList;

  CameraButtonOnPressed({this.subCategoryDataList, this.categoryData});

  thumbnailPicture(BuildContext context) async {
    String imageURL = await CameraImagePickCropCreateURL().pickCropReturnURL(context);

    /// push to bazaarWalasBasicProfile collection:
    String userPhoneNo = await UserDetails().getUserPhoneNoFuture();

    if(imageURL != null){
      subCategoryDataList.forEach((subCategory) {
        PushToBazaarWalasBasicProfile(userPhoneNo: userPhoneNo, thumbnailPicture: imageURL).pushThumbnailPicture(categoryData, subCategory);
      });

    }
    Navigator.pop(context);
    return imageURL;
    //NavigateToChangeBazaarProfilePicturesFetchAndDisplay().navigateNoBrackets(context);

  }


  otherPictureOne(BuildContext context) async {
    String imageURL = await CameraImagePickCropCreateURL().pickCropReturnURL(context);

    /// push to bazaarWalasBasicProfile collection:
    String userPhoneNo = await UserDetails().getUserPhoneNoFuture();

    if(imageURL != null){
      subCategoryDataList.forEach((subCategory) {
        PushToBazaarWalasBasicProfile(userPhoneNo: userPhoneNo, otherPictureOne: imageURL).pushOtherPictureOne(categoryData, subCategory);
      });

    }
    Navigator.pop(context);
    return imageURL;
    //NavigateToChangeBazaarProfilePicturesFetchAndDisplay().navigateNoBrackets(context);
  }


  otherPictureTwo(BuildContext context) async {
    String imageURL = await CameraImagePickCropCreateURL().pickCropReturnURL(context);

    /// push to bazaarWalasBasicProfile collection:
    String userPhoneNo = await UserDetails().getUserPhoneNoFuture();

    if(imageURL != null){
      subCategoryDataList.forEach((subCategory) {
        PushToBazaarWalasBasicProfile(userPhoneNo: userPhoneNo, otherPictureTwo: imageURL).pushOtherPictureTwo(categoryData, subCategory);
      });

    }
    Navigator.pop(context);
    return imageURL;
   // NavigateToChangeBazaarProfilePicturesFetchAndDisplay().navigateNoBrackets(context);
  }
}
