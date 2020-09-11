import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteBazaarCategoriesMetadata{
  String userNumber;
  String category;
  String subCategory;

  DeleteBazaarCategoriesMetadata({this.subCategory, this.userNumber, this.category});

  deleteASubcategory(){
    Firestore.instance.collection("bazaarCategoriesMetadata").document(userNumber)
        .collection(category).document(subCategory).delete();
  }

}