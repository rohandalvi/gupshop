import 'package:gupshop/PushToFirebase/pushToBazaarCategories.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarRatingNumbers.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarReviewsCollection.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarWalasLocation.dart';
import 'package:gupshop/PushToFirebase/pushToCategoriesMetadata.dart';

class PushSubCategoriesToFirebase{
  String category;
  String userName;
  String userPhoneNo;
  List<String> list;

  PushSubCategoriesToFirebase({this.category, this.userName, this.userPhoneNo, this.list});

  bazaarCategories(){
    list.forEach((element) {
      PushToBazaarCategories().addUser(category,element, userName, userPhoneNo);
    });
  }

  bazaarCategoriesMetaData(){
    list.forEach((subCategory) {
      PushToCategoriesMatedata(userNumber: userPhoneNo,).push(category,subCategory,);
    });
  }

  createBlankRatingNumber(){
    list.forEach((element) {
      PushToBazaarRatingNumber(category: category, subCategory:element,
          userNumber: userPhoneNo ).push();
    });

  }

  createBlankReviews(){
    list.forEach((element) {
      PushToBazaarReviewsCollection(productWalaNumber: userPhoneNo,
        category: category, subCategory: element).setBlankReviews();
    });
  }

  bazaarBasicProfile(){

  }

  bazaarWalasLocation(){
    list.forEach((element) {
      PushToBazaarWalasLocation(category: category,
          subCategory:element, userNumber: userPhoneNo).setBlankLocation();
    });
  }
}