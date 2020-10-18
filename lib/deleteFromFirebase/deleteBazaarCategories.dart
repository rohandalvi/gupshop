import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';

class DeleteBazaarCategories{
  String category;
  String subCategory;
  String userNumber;

  DeleteBazaarCategories({this.subCategory, this.userNumber, this.category});

  CollectionReference path(){
    CollectionReference dc = CollectionPaths.bazaarCategoriesCollectionPath;
    return dc;
  }

  deleteACategory() async{
    await path().document(category).collection(TextConfig.subCategoriesBazaarCategories)
        .document(subCategory).updateData({
      userNumber : FieldValue.delete()
    });
  }

}