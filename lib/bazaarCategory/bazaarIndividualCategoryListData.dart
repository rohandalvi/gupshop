import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/bazaarCategory/bazaarIndividualCategoryNameDpBuilder.dart';
import 'package:gupshop/bazaar/placeHolderImages.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToBazaarHomeScreen.dart';
import 'package:gupshop/navigators/navigateToHome.dart';
import 'package:gupshop/retriveFromFirebase/getBazaarWalasBasicProfileInfo.dart';
import 'package:gupshop/bazaarLocation/filterBazaarLocationData.dart';
import 'package:gupshop/service/getSharedPreferences.dart';
import 'package:gupshop/streamShortcuts/bazaarRatingNumbers.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/bazaarCategory/bazaarIndividualCategoryListDisplay.dart';
import 'package:gupshop/widgets/customText.dart';

class BazaarIndividualCategoryListData extends StatelessWidget {
  final String category;
  final String subCategory;
  final String subCategoryData;

  BazaarIndividualCategoryListData({this.category, this.subCategory, this.subCategoryData});



  Future<QuerySnapshot> getBazaarWalasInAGivenRadius;
  double latitude;
  double longitude;
  Future<dynamic> result;
  String userGeohashString;
  Future userPhoneNoFuture;
  String _userPhoneNo;
  List<DocumentSnapshot> list;

  String bazaarWalaPhoneNo;
  int numberOfBazaarWalasInList;

  getListOfBazaarWalasInAGivenRadius() async{
    var userPhoneNo = await UserDetails().getUserPhoneNoFuture();//get user phone no
    _userPhoneNo = userPhoneNo;
    var listOfbazaarwalas = await FilterBazaarLocationData(subCategory: subCategoryData).getListOfBazaarWalasInAGivenRadius(userPhoneNo, category,);
    return listOfbazaarwalas;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: CustomAppBar(
          title: CustomText(text: category.toUpperCase(),),
          onPressed: (){
           NavigateToHome(initialIndex: 1).navigateNoBrackets(context);
          }
        ),
      ),
      body: FutureBuilder(
        future: getListOfBazaarWalasInAGivenRadius(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print("snapshot.data in getListOfBazaarWalasInAGivenRadius : ${snapshot.data}");
        if (snapshot.data == null) return Container(child: Center(child: CustomText(text: 'No ${category}s near you',).bold())); //for avoding  the erro

        var list = snapshot.data;

        numberOfBazaarWalasInList = snapshot.data.length; ///for listView builder's itemcount

        return ListView.builder(
          itemCount: numberOfBazaarWalasInList,
          itemBuilder: (BuildContext context, int index) {
            bazaarWalaPhoneNo = list[index].documentID;
            return BazaarIndividualCategoryNameDpBuilder(
              bazaarWalaPhoneNo: bazaarWalaPhoneNo,
              category: category,
              subCategory: subCategory,
              subCategoryData : subCategoryData,
            );
          },

          );
        }
        return //listOfBazaarWalasPlaceholder(numberOfBazaarWalasInList, bazaarWalaPhoneNo);
          Center(child: CircularProgressIndicator());
        }
      ),
    );
  }

  listOfBazaarWalasPlaceholder(int numberOfBazaarWalasInList, String bazaarWalaPhoneNo){
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index){
          return BazaarIndividualCategoryListDisplay(
            bazaarWalaName: category.toString(),
            bazaarWalaPhoneNo: bazaarWalaPhoneNo,
            category: category,
            subCategory: subCategory,
            subCategoryData: subCategoryData,
            thumbnailPicture: PlaceHolderImages().bazaarWalaThumbnailPicture,
          );
        }
    );
  }

}
