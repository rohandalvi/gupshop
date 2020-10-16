import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/PushToFirebase/pushToCategoriesMetadata.dart';

class DeleteBazaarCategoriesMetadata{
  String userNumber;
  String category;
  String subCategory;

  DeleteBazaarCategoriesMetadata({this.subCategory, this.userNumber, this.category});

  CollectionReference path(String userNumber){
    CollectionReference cr = PushToCategoriesMatedata().path(userNumber).collection(category);
    return cr;
  }

  deleteASubcategory(){
    path(userNumber).document(subCategory).delete();
  }

}