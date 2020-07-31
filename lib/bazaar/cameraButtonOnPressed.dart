import 'package:flutter/cupertino.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarWalasBasicProfileCollection.dart';
import 'package:gupshop/bazaar/cameraImagePickCropCreateURL.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToChangeBazaarPicturesFetchAndDisplay.dart';

class CameraButtonOnPressed{

  thumbnailPicture(BuildContext context) async {
    String imageURL = await CameraImagePickCropCreateURL().pickCropReturnURL();

    /// push to bazaarWalasBasicProfile collection:
    String userPhoneNo = await UserDetails().getUserPhoneNoFuture();

    if(imageURL != null){
      PushToBazaarWalasBasicProfile(userPhoneNo: userPhoneNo, thumbnailPicture: imageURL).pushThumbnailPicture();
    }
    NavigateToChangeBazaarProfilePicturesFetchAndDisplay().navigateNoBrackets(context);

  }


  otherPictureOne(BuildContext context) async {
    String imageURL = await CameraImagePickCropCreateURL().pickCropReturnURL();

    /// push to bazaarWalasBasicProfile collection:
    String userPhoneNo = await UserDetails().getUserPhoneNoFuture();

    if(imageURL != null){
      PushToBazaarWalasBasicProfile(userPhoneNo: userPhoneNo, otherPictureOne: imageURL).pushOtherPictureOne();
    }
    NavigateToChangeBazaarProfilePicturesFetchAndDisplay().navigateNoBrackets(context);
  }


  otherPictureTwo(BuildContext context) async {
    String imageURL = await CameraImagePickCropCreateURL().pickCropReturnURL();

    /// push to bazaarWalasBasicProfile collection:
    String userPhoneNo = await UserDetails().getUserPhoneNoFuture();

    if(imageURL != null){
      PushToBazaarWalasBasicProfile(userPhoneNo: userPhoneNo, otherPictureTwo: imageURL).pushOtherPictureTwo();
    }
    NavigateToChangeBazaarProfilePicturesFetchAndDisplay().navigateNoBrackets(context);
  }
}