import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';

class CreateImageURL{
  create(File galleryImage) async{
    String fileName = basename(galleryImage.path);
    StorageReference firebaseStorageReference= FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageReference.putFile(galleryImage);
    StorageTaskSnapshot imageURLFuture = await uploadTask.onComplete;
    String imageURL = await imageURLFuture.ref.getDownloadURL();
    return imageURL;
  }
}