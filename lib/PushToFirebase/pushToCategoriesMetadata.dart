import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';

class PushToCategoriesMatedata{
  String userNumber;

  PushToCategoriesMatedata({this.userNumber,});

  DocumentReference path(String userNumber){
    DocumentReference dc = CollectionPaths.bazaarCategoriesMetadataCollectionPath.document(userNumber);
    return dc;
  }

  push(String category, String subCategoryData, String subCategory) async{
    path(userNumber).setData({}, merge: true);///creating document to avoid error document(i
    path(userNumber).collection(category).document(subCategoryData).setData({TextConfig.name : subCategory}, merge: true);

  }
}