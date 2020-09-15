import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/customDialogBox.dart';
import 'package:gupshop/widgets/customFlushBar.dart';
import 'package:gupshop/widgets/customText.dart';
import 'dart:io';
import 'package:path/path.dart';


class CreateVideoURL{

//  create(File galleryImage, String userPhoneNo, int number) async{
//    String fileName = basename(galleryImage.path);
//    StorageReference firebaseStorageReference= FirebaseStorage.instance.ref().child("video").child(fileName);
//    StorageUploadTask uploadTask = firebaseStorageReference.putFile(galleryImage, StorageMetadata(contentType: 'video/mp4'));
//    StorageTaskSnapshot videoURLFuture = await uploadTask.onComplete;
//    String videoURL = await videoURLFuture.ref.getDownloadURL();
//    return videoURL;
//  }

  create(BuildContext context, File galleryImage, String userPhoneNo, int number) async{
    String fileName = basename(galleryImage.path);
    StorageReference firebaseStorageReference= FirebaseStorage.instance.ref().child("video").child(fileName);
    StorageUploadTask uploadTask = firebaseStorageReference.putFile(galleryImage, StorageMetadata(contentType: 'video/mp4'));
    bool delay = false;
    if(uploadTask.isInProgress){
      /// show progress indicator
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('Downloading'),
            content: Text('Video download in progress...'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Alert me on completion'),
                onPressed: (){
                  delay = true;
                  Navigator.of(context).pop();
                }
              )
            ],
          ));
    }
    if(uploadTask.isCanceled){
      print("cancled");
    }
    if(uploadTask.isPaused){}

    StorageTaskSnapshot videoURLFuture = await uploadTask.onComplete;
    if(delay == false){
      Navigator.of(context).pop();
    }else{
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('Alert'),
            content: Text('Download complete'),
            actions: <Widget>[
              CupertinoDialogAction(
                  child: Text('OK'),
                  onPressed: (){
                    delay = true;
                    Navigator.of(context).pop();
                  }
              )
            ],
          ));
    }

    String videoURL = await videoURLFuture.ref.getDownloadURL();
    return videoURL;
//    if(uploadTask.isSuccessful){
//    }
  }
}