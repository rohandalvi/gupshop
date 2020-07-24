import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';


class CreateVideoURL{

  create(File galleryImage, String userPhoneNo, int number) async{
    String fileName = basename(galleryImage.path);
    StorageReference firebaseStorageReference= FirebaseStorage.instance.ref().child("video").child(fileName);
    StorageUploadTask uploadTask = firebaseStorageReference.putFile(galleryImage, StorageMetadata(contentType: 'video/mp4'));
    StorageTaskSnapshot videoURLFuture = await uploadTask.onComplete;
    String videoURL = await videoURLFuture.ref.getDownloadURL();
    return videoURL;
  }
}