import 'package:gupshop/PushToFirebase/pushToBazaarCategories.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarRatingNumbers.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarReviewsCollection.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarWalasLocation.dart';
import 'package:gupshop/PushToFirebase/pushToCategoriesMetadata.dart';

class PushSubCategoriesToFirebase{
  String category;
  String userName;
  String userPhoneNo;
  List<String> listOfSubCategoriesData;
  List<String> listOfSubCategories;


  PushSubCategoriesToFirebase({this.category, this.userName, this.userPhoneNo, this.listOfSubCategoriesData, this.listOfSubCategories});

  bazaarCategories(){
    listOfSubCategoriesData.forEach((element) {
      PushToBazaarCategories().addUser(category,element, userName, userPhoneNo);
    });
  }

  bazaarCategoriesMetaData(){
    for(int i = 0; i<listOfSubCategoriesData.length; i++){
      String subCategory = listOfSubCategories[i];
      String subCategoryData = listOfSubCategoriesData[i];
      PushToCategoriesMatedata(userNumber: userPhoneNo,).push(category,subCategoryData,subCategory);
    }

//    listOfSubCategoriesData.forEach((subCategoryData) {
//      PushToCategoriesMatedata(userNumber: userPhoneNo,).push(category,subCategoryData,subCategory);
//    });
  }

  createBlankRatingNumber(){
    listOfSubCategoriesData.forEach((element) {
      PushToBazaarRatingNumber(category: category, subCategory:element,
          userNumber: userPhoneNo ).push();
    });

  }

  createBlankReviews(){
    listOfSubCategoriesData.forEach((element) {
      PushToBazaarReviewsCollection(productWalaNumber: userPhoneNo,
        category: category, subCategory: element).setBlankReviews();
    });
  }

  bazaarBasicProfile(){

  }

  bazaarWalasLocation(){
    listOfSubCategoriesData.forEach((element) {
      PushToBazaarWalasLocation(category: category,
          subCategory:element, userNumber: userPhoneNo).setBlankLocation();
    });
  }
}