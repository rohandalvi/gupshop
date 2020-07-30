import 'package:flutter/cupertino.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarWalasBasicProfileCollection.dart';
import 'package:gupshop/bazaar/galleryImagePickCropCreateURL.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToChangeBazaarPicturesFetchAndDisplay.dart';

class GalleryButtonOnPressed{

    thumbnailPicture(BuildContext context) async {
        String imageURL = await GalleryImagePickCropCreateURL().pickCropReturnURL();

        /// push to bazaarWalasBasicProfile collection:

        String userPhoneNo = await UserDetails().getUserPhoneNoFuture();

        PushToBazaarWalasBasicProfile(userPhoneNo: userPhoneNo, thumbnailPicture: imageURL).pushThumbnailPicture();
        NavigateToChangeBazaarProfilePicturesFetchAndDisplay().navigateNoBrackets(context);

    }

    otherPictureOne(BuildContext context) async {
      String imageURL = await GalleryImagePickCropCreateURL().pickCropReturnURL();

      /// push to bazaarWalasBasicProfile collection:

      String userPhoneNo = await UserDetails().getUserPhoneNoFuture();

      PushToBazaarWalasBasicProfile(userPhoneNo: userPhoneNo, otherPictureOne: imageURL).pushOtherPictureOne();
      NavigateToChangeBazaarProfilePicturesFetchAndDisplay().navigateNoBrackets(context);
    }

    otherPictureTwo(BuildContext context) async {
      String imageURL = await GalleryImagePickCropCreateURL().pickCropReturnURL();

      /// push to bazaarWalasBasicProfile collection:

      String userPhoneNo = await UserDetails().getUserPhoneNoFuture();

      PushToBazaarWalasBasicProfile(userPhoneNo: userPhoneNo, otherPictureTwo: imageURL).pushOtherPictureTwo();
      NavigateToChangeBazaarProfilePicturesFetchAndDisplay().navigateNoBrackets(context);
    }
}
