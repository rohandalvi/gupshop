import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteBazaarCategories{
  String category;
  String subCategory;
  String userNumber;

  DeleteBazaarCategories({this.subCategory, this.userNumber, this.category});

  deleteACategory() async{
    await Firestore.instance.collection("bazaarCategories").document(category).collection("subCategories")
        .document(subCategory).updateData({
      userNumber : FieldValue.delete()
    });
  }

}