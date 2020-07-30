import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gupshop/bazaar/galleryAndCameraButtonsOnPressed.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customBottomSheet.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class ChangeBazaarWalasPicturesBottomBar extends StatelessWidget {

  final int tabNumber;

  ChangeBazaarWalasPicturesBottomBar({this.tabNumber});

  @override
  Widget build(BuildContext context) {
        /// CustomIconButton needs to be wrapped in a builder to pass
        /// the context to CustomBottomSheet else it gives the error:
        /// no scaffold found
    return Builder(
            builder: (context) {
              return CustomFloatingActionButton(
                child: IconButton(
                    icon: SvgPicture.asset('images/editPencil.svg',)
                  //SvgPicture.asset('images/downChevron.svg',)
                ),
                onPressed: (){
                  CustomBottomSheet(
                    customContext: context,
                    firstIconName: 'photoGallery',
                    firstIconText: 'Pick image from  Gallery',
                    firstIconAndTextOnPressed: (){
                      print("tabNumber : $tabNumber");
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
        );
  }
}
