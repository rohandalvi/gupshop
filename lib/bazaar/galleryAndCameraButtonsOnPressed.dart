import 'package:flutter/cupertino.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarWalasBasicProfileCollection.dart';
import 'package:gupshop/bazaar/galleryImagePickCropCreateURL.dart';
import 'package:gupshop/image/galleryCameraIconsDisplay.dart';
import 'package:gupshop/modules/userDetails.dart';

class GalleryAndCameraButtonsOnPressed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GalleryCameraIconsDisplay(
      galleryIconOnPressed: () async{
        String imageURL = GalleryImagePickCropCreateURL().pickCropReturnURL();

        /// push to bazaarWalasBasicProfile collection:

        String userPhoneNo = await UserDetails().getUserPhoneNoFuture();

        await PushToBazaarWalasBasicProfile(userPhoneNo: userPhoneNo, thumbnailPicture: imageURL).thumbnailPicture;
      },
    );
  }
}
