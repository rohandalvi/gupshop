import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/displayPicture.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';


class CropImage{
  crop(File tempImage) async{
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: tempImage.path,
      aspectRatio: CropAspectRatio(
        ratioX: 1.0,
        ratioY: 1.0,
      ),
      maxWidth: 512,
      maxHeight: 512,
    );

    return croppedImage;
  }
}