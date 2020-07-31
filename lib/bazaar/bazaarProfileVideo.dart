import 'package:flutter/cupertino.dart';
import 'package:gupshop/widgets/customBottomSheet.dart';
import 'package:gupshop/widgets/customIconButton.dart';

class BazaarProfileVideo extends StatelessWidget {
  final VoidCallback firstIconAndTextOnPressed;
  final VoidCallback secondIconAndTextOnPressed;

  BazaarProfileVideo({this.secondIconAndTextOnPressed, this.firstIconAndTextOnPressed});

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          return CustomIconButton(
            iconNameInImageFolder: 'videoCamera',
            onPressed: (){
              CustomBottomSheet(
                customContext: context,
                firstIconName: 'photoGallery',
                firstIconText: 'Pick video from  Gallery',
                firstIconAndTextOnPressed: firstIconAndTextOnPressed,
                secondIconName: 'image2vector',
                secondIconText: 'Record video from Camera',
                secondIconAndTextOnPressed: secondIconAndTextOnPressed,
              ).showTwo();
            },
          );
        }
    );
  }

}
