
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';


class CropImage{
  crop(File tempImage) async{
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: tempImage.path,
      aspectRatio: CropAspectRatio(
        ratioX: 1.0,
        ratioY: 1.0,
      ),
      maxWidth: WidgetConfig.fiveHundredTwelveWidth,
      maxHeight: WidgetConfig.fiveHundredTwelveHeight,
    );

    return croppedImage;
  }
}