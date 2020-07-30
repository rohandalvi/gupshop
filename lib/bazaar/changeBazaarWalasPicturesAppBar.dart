import 'package:flutter/cupertino.dart';
import 'package:gupshop/bazaar/galleryAndCameraButtonsOnPressed.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customBottomSheet.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class ChangeBazaarWalasPicturesAppBar extends StatelessWidget {
  final int tabNumber;

  ChangeBazaarWalasPicturesAppBar({this.tabNumber});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: CustomText(text: 'Become a Bazaarwala', fontSize: 20,),
      onPressed:(){
        Navigator.pop(context);
      },
      actions: <Widget>[
        /// CustomIconButton needs to be wrapped in a builder to pass
        /// the context to CustomBottomSheet else it gives the error:
        /// no scaffold found
        Builder(
            builder: (context) {
              return CustomIconButton(
                iconNameInImageFolder: 'editPencil',
                onPressed: (){
                  CustomBottomSheet(
                    customContext: context,
                    firstIconName: 'photoGallery',
                    firstIconText: 'Pick image from  Gallery',
                    firstIconAndTextOnPressed: (){
                      if(tabNumber == 0) GalleryAndCameraButtonsOnPressed().thumbnailPicture(context);
                      if(tabNumber == 1) GalleryAndCameraButtonsOnPressed().otherPictureOne(context);
                      if(tabNumber == 2) GalleryAndCameraButtonsOnPressed().otherPictureTwo(context);
                    },
                    secondIconName: 'image2vector',
                    secondIconText: 'Click image from Camera',
                    secondIconAndTextOnPressed: (){},
                  ).showTwo();
                },
              );
            }
        ),
      ],
    );
  }
}
