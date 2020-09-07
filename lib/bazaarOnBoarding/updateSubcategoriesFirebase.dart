import 'package:gupshop/updateInFirebase/updateBazaarCategories.dart';
import 'package:gupshop/updateInFirebase/updateBazaarCategoriesMetadata.dart';

class UpdateSubcategriesFirebase{
  List listOfSubCategoriesData;
  String userNumber;
  String category;


  UpdateSubcategriesFirebase({this.listOfSubCategoriesData, this.userNumber,
    this.category
  });


  bazaarCategories(){
    listOfSubCategoriesData.forEach((subCategory) {
      UpdateBazaarCategories(
        userNumber: userNumber,
        category: category,
        subCategory: subCategory
      ).deleteACategory();
    });
  }

  bazaarCategoriesMetadata(){
    listOfSubCategoriesData.forEach((subCategory) {
      UpdateBazaarCategoriesMetadata(
          userNumber: userNumber,
          category: category,
          subCategory: subCategory
      ).deleteASubcategory();
    });
  }

  bazaarBasicProfile(){

  }
}