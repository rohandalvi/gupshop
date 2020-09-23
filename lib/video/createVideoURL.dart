import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    bool cancel = false;
    bool isComplete = false;

    if(uploadTask.isInProgress){
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return StreamBuilder<StorageTaskEvent>(
                stream: uploadTask.events,
                builder: (context, AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
                  var progress = 0;
                  if (asyncSnapshot.hasData){
                    final StorageTaskEvent event = asyncSnapshot.data;
                    final StorageTaskSnapshot snapshot = event.snapshot;
                    progress = ((snapshot.bytesTransferred /
                        snapshot.totalByteCount) * 100).toInt();
                  }

                  return CupertinoAlertDialog(
                    title: Text('Upload $progress %'),
                    content: Text('Video upload in progress...'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                          child: Text('Alert me on completion'),
                          onPressed: () {
                            delay = true;
                            Navigator.of(context).pop();
                          }
                      ),
                      CupertinoDialogAction(
                          child: Text('Cancel'),
                          onPressed: () {
                            cancel = true;
                            Navigator.of(context).pop();
                          }
                      )
                    ],
                  );
                }
            );
          }
      );
    }



    StorageTaskSnapshot videoURLFuture = await uploadTask.onComplete;
    /// if the user doesnt select alreat me later option then delay == false.
    /// This happens in two cases:
    /// - if the user doesnt do anything and wait for the video to upload
    /// - if the user cancels the upload
    ///   In this case we dont want to pop the navigator or mark the uploadtask
    ///   as isComplete.
    ///   So check both the cases
    if(delay == false && cancel == false){
      Navigator.of(context).pop();
      isComplete = true;
    }else if(delay == true) {
      /// awaiting for the showDialog is important because the value of isComplete
      /// does not get updated by the showDialog and the method  never returns
      /// the videoURL
      await showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('Alert'),
            content: Text('Upload complete'),
            actions: <Widget>[
              CupertinoDialogAction(
                  child: Text('OK'),
                  onPressed: () {
                    delay = true;
                    isComplete = true;
                    Navigator.of(context).pop();
                  }
              )
            ],
          ));
    }


    if(isComplete == true){
      String videoURL = await videoURLFuture.ref.getDownloadURL();
      return videoURL;
    }
  }
}