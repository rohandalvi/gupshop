import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/bazaarOnBoarding/deleteSubcategoriesFirebase.dart';
import 'package:gupshop/bazaarOnBoarding/pushSubCategoriesToFirebase.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/retriveFromFirebase/getBazaarWalasBasicProfileInfo.dart';
import 'package:gupshop/updateInFirebase/updateBazaarWalasBasicProfile.dart';

class PushToFirebase{
  final List<String> listOfSubCategoriesForData;
  final List<String> listOfSubCategories;
  final List<dynamic> deleteListData;
  final List<dynamic> addListData;
  final String categoryData;
  final bool videoChanged;
  final bool locationChanged;
  final String videoURL;
  final LatLng location;
  final double radius;
  final String userPhoneNo;
  final bool isBazaarwala;
  final String aSubCategoryData;

  PushToFirebase({this.deleteListData, this.addListData,
    this.videoChanged, this.locationChanged,
    this.listOfSubCategoriesForData, this.categoryData,
    this.listOfSubCategories, this.location, this.radius,
    this.videoURL, this.userPhoneNo, this.isBazaarwala,
    this.aSubCategoryData
  });



  main() async{

    /// if not a bazaarwala
    if(isBazaarwala == false){
      if(addListData == null && deleteListData==null &&
      videoChanged == true && locationChanged == true){
        await pushSubCategoriesToFirebase(listOfSubCategoriesForData);
      }
    }else{
      /// if a bazaarwala and subCategories have been added
      /// bazaarwala == true and only addList != null
      if(addListData != null){
        await repeatAddList();
      }

      /// if a bazaarwala and subCategories have been deleted
      /// bazaarwala == true and only deleteListData != null
      if(deleteListData != null){
        await repeatDeleteList();
      }

      /// if videoChanged == true
      /// Now, videoChanged == true is set on bazaarOnBorading everytime the
      /// video is displayed even if the video is not actually changed.
      /// So this is actually a overhead.
      /// addListData == null will happen when the user has not added any
      /// new category.
      /// If the user has added a new category then the video would get pushed
      /// in repeatAddList(), hence updating here in repeatVideoChanged
      /// would be doing double work. Hence, addListData == null check
      if(videoChanged == true && addListData == null){
        /// update methods
        await repeatVideoChanged();
      }

      /// if locationChanged == true
      if(locationChanged == true && addListData == null){
        await repeatVideoChanged();
      }

    }
  }




  firstTime() async{
    ///if(addListData == null && deleteListData==null &&
    ///    isBazaarwala == false && videoChanged == true &&
    ///     locationChanged == true)
      await pushSubCategoriesToFirebase(listOfSubCategoriesForData);
  }


//  repeatNoChange(){
//    if(addListData == null && deleteListData==null &&
//        isBazaarwala == true && videoChanged == false &&
//        locationChanged == false){
//      /// do nothing
//    }
//  }

  repeatAddList() async{
    ///if(isbazaarwala == true && addListData != null)
    await pushSubCategoriesToFirebase(addListData);

  }

  repeatDeleteList() async{
    ///if(isbazaarwala == true && deleteListData != null)
    await deleteUnselectedCategoriesFromDatabase(deleteListData,
        userPhoneNo);
  }

  repeatVideoChanged() async{
    /// if videoChanged == true
    await updateVideoInBazaarWalasBasicProfile(listOfSubCategoriesForData);
  }

  repeatLocationChanged() async{
    /// if locationChanged == true
    await updateLocationInBazaarWalasBasicProfile(listOfSubCategoriesForData);
  }





  /// only change in categories
  pushSubCategoriesToFirebase(List listOfSubCategoriesData) async{
    String userName = await UserDetails().getUserNameFuture();
    String userNumber = await UserDetails().getUserPhoneNoFuture();



    /// blank placeholders: ////////////////////////////////////////////////////

    /// setting blank rating in ratings
    await PushSubCategoriesToFirebase(category: categoryData,userPhoneNo: userNumber,
        userName: userName, listOfSubCategoriesData: listOfSubCategoriesForData)
        .createBlankRatingNumber();


    /// setting blank review in reviews
    await PushSubCategoriesToFirebase(category: categoryData,userPhoneNo: userNumber,
        userName: userName, listOfSubCategoriesData:listOfSubCategoriesForData)
        .createBlankReviews();


    /// setting blank location in bazaarWalasLocation
    await PushSubCategoriesToFirebase(category: categoryData,userPhoneNo: userNumber,
        userName: userName, listOfSubCategoriesData: listOfSubCategoriesForData)
        .blankBazaarWalasLocation();

    /// blank placeholders end here /////////////////////////////////////////////



    /// push to 5 collections:
    /// bazaarCategories
    await PushSubCategoriesToFirebase(category: categoryData,userPhoneNo: userNumber,
        userName: userName, listOfSubCategoriesData:listOfSubCategoriesForData)
        .bazaarCategories();

    /// bazaarCategoriesMetaData
    await PushSubCategoriesToFirebase(category: categoryData,userPhoneNo: userNumber,
        userName: userName, listOfSubCategoriesData: listOfSubCategoriesForData,
        listOfSubCategories: listOfSubCategories )
        .bazaarCategoriesMetaData();


    /// push to video collection
    await PushSubCategoriesToFirebase(category: categoryData,userPhoneNo: userNumber,
        userName: userName, listOfSubCategoriesData: listOfSubCategoriesForData,
        videoURL: videoURL
    ).videoCollection();


    /// push to bazaarwalasBasicProfile
    await PushSubCategoriesToFirebase(category: categoryData,userPhoneNo: userNumber,
        userName: userName, listOfSubCategoriesData: listOfSubCategoriesForData,
        videoURL: videoURL, location: location, radius: radius
    ).bazaarBasicProfile();


    /// push Location
    await PushSubCategoriesToFirebase(category: categoryData,userPhoneNo: userNumber,
        userName: userName, listOfSubCategoriesData: listOfSubCategoriesForData,
        location: location, radius: radius
    ).bazaarWalasLocation();
  }


  deleteUnselectedCategoriesFromDatabase(List deleteListData, String userNumber) async{
    print("deleteList in deleteUnselectedCategoriesFromDatabase : ${deleteListData}");

    /// delete from 5 collections:
    await DeleteSubcategriesFirebase(category: categoryData,userNumber: userNumber,
        listOfSubCategoriesData: deleteListData)
        .bazaarCategories();

    await DeleteSubcategriesFirebase(category: categoryData,userNumber: userNumber,
        listOfSubCategoriesData: deleteListData)
        .bazaarCategoriesMetadata();

    await DeleteSubcategriesFirebase(category: categoryData,userNumber: userNumber,
        listOfSubCategoriesData: deleteListData)
        .bazaarBasicProfile();

    /// delete from video collection
    await DeleteSubcategriesFirebase(category: categoryData,userNumber: userNumber,
        listOfSubCategoriesData: deleteListData)
        .videos();

    /// delete from bazaarWalasLocation collection
    await DeleteSubcategriesFirebase(category: categoryData,userNumber: userNumber,
        listOfSubCategoriesData: deleteListData)
        .bazaarWalasLocation();
  }



  /// video and location
  updateVideoInBazaarWalasBasicProfile(List list){
    list.forEach((subCategory) async{
      await UpdateBazaarWalasBasicProfile(
        userPhoneNo: userPhoneNo,
        categoryData: categoryData,
        subCategoryData: subCategory,
      ).updateVideo(videoURL);
    });
  }

  updateLocationInBazaarWalasBasicProfile(List list){
    list.forEach((subCategory) async{
      await UpdateBazaarWalasBasicProfile(
        userPhoneNo: userPhoneNo,
        categoryData: categoryData,
        subCategoryData: subCategory,
      ).updateLocation(location);
    });
  }



  isSubCategoryBazaarwalaWidget() async{
    bool isSubCategoryBazaarwala = await GetBazaarWalasBasicProfileInfo(
      userNumber: userPhoneNo,
      categoryData: categoryData,
      subCategoryData: listOfSubCategoriesForData[0],
    ).getIsBazaarwala();
    return isSubCategoryBazaarwala;
  }
}