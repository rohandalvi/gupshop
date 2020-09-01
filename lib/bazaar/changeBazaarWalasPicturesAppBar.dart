import 'package:flutter/cupertino.dart';
import 'package:gupshop/bazaar/cameraButtonOnPressed.dart';
import 'package:gupshop/bazaar/galleryButtonOnPressed.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customBottomSheet.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class ChangeBazaarWalasPicturesAppBar extends StatelessWidget {
  final int tabNumber;
  final String category;
  List<String> subCategoryDataList;

  ChangeBazaarWalasPicturesAppBar({this.tabNumber, this.category, this.subCategoryDataList});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: CustomText(text: 'Become a Bazaarwala',),
      onPressed:(){
        //Navigator.pop(context);
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
                      if(tabNumber == 0) GalleryButtonOnPressed(category: category, subCategoryDataList: subCategoryDataList).thumbnailPicture(context);
                      if(tabNumber == 1) GalleryButtonOnPressed(category: category, subCategoryDataList: subCategoryDataList).otherPictureOne(context);
                      if(tabNumber == 2) GalleryButtonOnPressed(category: category, subCategoryDataList: subCategoryDataList).otherPictureTwo(context);
                    },
                    secondIconName: 'image2vector',
                    secondIconText: 'Click image from Camera',
                    secondIconAndTextOnPressed: (){
                      if(tabNumber == 0) CameraButtonOnPressed(category: category, subCategoryDataList: subCategoryDataList).thumbnailPicture(context);
                      if(tabNumber == 1) CameraButtonOnPressed(category: category, subCategoryDataList: subCategoryDataList).otherPictureOne(context);
                      if(tabNumber == 2) CameraButtonOnPressed(category: category, subCategoryDataList: subCategoryDataList).otherPictureTwo(context);
                    },
                  ).showTwo();
                },
              );
            }
        ),
      ],
    ).noLeading();
  }
}
