import 'package:cloud_firestore/cloud_firestore.dart';

class PushToVideoCollection{
  String userPhoneNo;
  String videoURL;
  String categoryData;
  String subCategoryData;

  PushToVideoCollection({this.userPhoneNo, this.videoURL, this.subCategoryData,
    this.categoryData
  });


  push() async{
    Firestore.instance.collection("videos").document(userPhoneNo)
        .collection(categoryData).document(subCategoryData)
        .setData({'url':videoURL});
  }
}