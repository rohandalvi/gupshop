import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';

class PushToVideoCollection{
  String userPhoneNo;
  String videoURL;
  String categoryData;
  String subCategoryData;

  PushToVideoCollection({this.userPhoneNo, this.videoURL, this.subCategoryData,
    this.categoryData
  });

  DocumentReference path(String userPhoneNo){
    DocumentReference dc = CollectionPaths.videosCollectionPath.document(userPhoneNo);
    return dc;
  }

  CollectionReference categoryDataPath(String userPhoneNo, String categoryData){
    CollectionReference dc = CollectionPaths.videosCollectionPath.document(userPhoneNo)
        .collection(categoryData);
    return dc;
  }

  setBlankVideo(){
    path(userPhoneNo).setData({}, merge: true);///creating document to avoid error document(i
  }

  push() async{
    categoryDataPath(userPhoneNo, categoryData).document(subCategoryData)
        .setData({TextConfig.url:videoURL});
  }
}