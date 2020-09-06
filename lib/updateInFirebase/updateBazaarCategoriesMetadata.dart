import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateBazaarCategoriesMetadata{
  String userNumber;
  String category;
  String subCategory;

  UpdateBazaarCategoriesMetadata({this.subCategory, this.userNumber, this.category});

  deleteASubcategory(){
    Firestore.instance.collection("bazaarCategoriesMetadata").document(userNumber)
        .collection(category).document(subCategory).delete();
  }

}