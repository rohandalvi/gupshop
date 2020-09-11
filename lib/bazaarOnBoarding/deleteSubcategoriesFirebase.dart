import 'package:gupshop/deleteFromFirebase/deleteBazaarCategories.dart';
import 'package:gupshop/deleteFromFirebase/deleteFromBazaarwalasBasicProfile.dart';
import 'package:gupshop/updateInFirebase/deleteBazaarCategoriesMetadata.dart';

class DeleteSubcategriesFirebase{
  List listOfSubCategoriesData;
  String userNumber;
  String category;


  DeleteSubcategriesFirebase({this.listOfSubCategoriesData, this.userNumber,
    this.category
  });


  bazaarCategories(){
    listOfSubCategoriesData.forEach((subCategory) {
      DeleteBazaarCategories(
        userNumber: userNumber,
        category: category,
        subCategory: subCategory
      ).deleteACategory();
    });
  }

  bazaarCategoriesMetadata(){
    listOfSubCategoriesData.forEach((subCategory) {
      DeleteBazaarCategoriesMetadata(
          userNumber: userNumber,
          category: category,
          subCategory: subCategory
      ).deleteASubcategory();
    });
  }

  bazaarBasicProfile(){
    print("deleteList in bazaarBasicProfile : ${listOfSubCategoriesData}");
    listOfSubCategoriesData.forEach((subCategory) {
      DeleteFromBazaarWalasBasicProfile(
          userPhoneNo: userNumber,
          categoryData: category,
          subCategoryData: subCategory
      ).deleteSubcategory();
    });
  }
}