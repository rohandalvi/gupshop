import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarCategories.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarRatingNumbers.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarReviewsCollection.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarWalasBasicProfileCollection.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarWalasLocation.dart';
import 'package:gupshop/PushToFirebase/pushToCategoriesMetadata.dart';
import 'package:gupshop/PushToFirebase/pushToVideoCollection.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarTrace.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarTrace.dart';
import 'package:gupshop/location/location_service.dart';

/// this class is a helper for PushToFirebase class
class PushSubCategoriesToFirebase{
  String category;
  String userName;
  String userPhoneNo;
  List<String> listOfSubCategoriesData;
  List<String> listOfSubCategories;
  String videoURL;
  LatLng location;
  double radius;
  final Map<String, bool> homeServiceMap;

  PushSubCategoriesToFirebase({this.category, this.userName, this.userPhoneNo,
    this.listOfSubCategoriesData, this.listOfSubCategories, this.videoURL,
    this.location, this.radius, this.homeServiceMap
  });


  bazaarCategories(){
    listOfSubCategoriesData.forEach((element) {
      PushToBazaarCategories().addUser(category,element, userName, userPhoneNo);
    });
  }

  bazaarCategoriesMetaData(){
    for(int i = 0; i<listOfSubCategoriesData.length; i++){
      String subCategory = listOfSubCategories[i];
      String subCategoryData = listOfSubCategoriesData[i];
      PushToCategoriesMatedata(userNumber: userPhoneNo,)
          .push(category,subCategoryData,subCategory);
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

  bazaarBasicProfile() {
    listOfSubCategoriesData.forEach((element) {
      PushToBazaarWalasBasicProfile(
          categoryData: category,
          subCategoryData: element,
          userPhoneNo: userPhoneNo,
          userName: userName,
          videoURL: videoURL,
          longitude: location.longitude,
          latitude: location.latitude,
          radius: radius,
      ).pushToFirebase();
    });
  }


  blankBazaarWalasLocation(){
    listOfSubCategoriesData.forEach((element) {
      PushToBazaarWalasLocation(category: category,
          subCategory:element, userNumber: userPhoneNo).setBlankLocation();
    });
  }

  bazaarWalasLocation(){
    ///Trace:
    BazaarTrace(category: category).locationAdded(location);

    listOfSubCategoriesData.forEach((subCategory) {
      LocationService().pushBazaarWalasLocationToFirebase(
          location.latitude, location.longitude,
          category, userPhoneNo, subCategory, radius
      );
    });
  }

  videoCollection(){
    listOfSubCategoriesData.forEach((element) {
      PushToVideoCollection(
          userPhoneNo: userPhoneNo,
          categoryData: category,
          subCategoryData: element,
          videoURL: videoURL
      ).push();
    });
  }

  homeService(){
    print("homeServiceMap in PushSubCategoriesToFirebase : $homeServiceMap");
    homeServiceMap.forEach((subCategoryData, homeService) {
      PushToBazaarWalasBasicProfile(
        categoryData: category,
        subCategoryData: subCategoryData,
        userPhoneNo: userPhoneNo,
        homeService: homeService,
      ).pushHomeService();
    });

  }
}