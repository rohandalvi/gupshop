import 'package:flutter/cupertino.dart';
import 'package:gupshop/bazaar/cameraButtonOnPressed.dart';
import 'package:gupshop/bazaar/galleryButtonOnPressed.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customBottomSheet.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class ChangeBazaarWalasPicturesAppBar extends StatelessWidget {
  final int tabNumber;
  final String categoryData;
  List<String> subCategoryDataList;

  final ValueChanged<String> thumbnailPicture;
  final ValueChanged<String> otherPictureOne;
  final ValueChanged<String> otherPictureTwo;

  ChangeBazaarWalasPicturesAppBar({this.tabNumber, this.categoryData,
    this.subCategoryDataList, this.thumbnailPicture, this.otherPictureTwo, this.otherPictureOne});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: CustomText(text: 'Add pictures',),
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
                iconNameInImageFolder: 'plus',
                onPressed: (){
                  CustomBottomSheet(
                    customContext: context,
                    firstIconName: 'photoGallery',
                    firstIconText: 'Pick image from  Gallery',
                    firstIconAndTextOnPressed: () async{
                      if(tabNumber == 0) {
                        String imageURL = await GalleryButtonOnPressed(categoryData: categoryData, subCategoryDataList: subCategoryDataList).thumbnailPicture(context);
                        print("imageURL in firstIconAndTextOnPressed : $imageURL");
                        thumbnailPicture(imageURL);
                      }
                      if(tabNumber == 1){
                        String imageURL =await GalleryButtonOnPressed(categoryData: categoryData, subCategoryDataList: subCategoryDataList).otherPictureOne(context);
                        otherPictureOne(imageURL);
                      }
                      if(tabNumber == 2){
                        String imageURL =await GalleryButtonOnPressed(categoryData: categoryData,
                            subCategoryDataList: subCategoryDataList).otherPictureTwo(context);
                        otherPictureTwo(imageURL);
                      }
                    },
                    secondIconName: 'image2vector',
                    secondIconText: 'Click image from Camera',
                    secondIconAndTextOnPressed: (){
                      if(tabNumber == 0) CameraButtonOnPressed(categoryData: categoryData, subCategoryDataList: subCategoryDataList).thumbnailPicture(context);
                      if(tabNumber == 1) CameraButtonOnPressed(categoryData: categoryData, subCategoryDataList: subCategoryDataList).otherPictureOne(context);
                      if(tabNumber == 2) CameraButtonOnPressed(categoryData: categoryData, subCategoryDataList: subCategoryDataList).otherPictureTwo(context);
                    },
                  ).showTwo();
                },
              );
            }
        ),
      ],
    );
  }
}
