import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/bazaar/placeHolderImages.dart';
import 'package:gupshop/navigators/navigateToBazaarHomeScreen.dart';
import 'package:gupshop/navigators/navigateToHome.dart';
import 'package:gupshop/retriveFromFirebase/getBazaarWalasBasicProfileInfo.dart';
import 'package:gupshop/service/filterBazaarWalas.dart';
import 'package:gupshop/service/getSharedPreferences.dart';
import 'package:gupshop/streamShortcuts/bazaarRatingNumbers.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/bazaar/bazaarIndividualCategoryListDisplay.dart';
import 'package:gupshop/widgets/customText.dart';

class BazaarIndividualCategoryListData extends StatelessWidget {
  final String category;

  BazaarIndividualCategoryListData({this.category});

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
    var userPhoneNo = await GetSharedPreferences().getUserPhoneNoFuture();//get user phone no
    _userPhoneNo = userPhoneNo;
    var listOfbazaarwalas = await FilterBazaarWalasState().getListOfBazaarWalasInAGivenRadius(userPhoneNo, category);
    return listOfbazaarwalas;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: CustomAppBar(
          title: CustomText(text: category.toUpperCase(), fontSize: 20,),
          onPressed: (){
           NavigateToHome(initialIndex: 1).navigateNoBrackets(context);
          }
        ),
      ),
      body: FutureBuilder(
            future: getListOfBazaarWalasInAGivenRadius(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.data == null)
          return Container(child: Center(child: CustomText(text: 'No ${category}s near you', fontSize: 35,).bold())); //for avoding  the erro

        bazaarWalaPhoneNo = snapshot.data[0].documentID;
        numberOfBazaarWalasInList = snapshot.data.length; ///for listView builder's itemcount

        return ListView.builder(
          itemCount: numberOfBazaarWalasInList,
          itemBuilder: (BuildContext context, int index) {
            return StreamBuilder( ///use bazaarcategory to display people insted becuase bazaarwalabasicprofile is categorized by phoneNumber now
                stream: BazaarRatingNumbers(userNumber: bazaarWalaPhoneNo, categoryName: category).getRatingSnapshot(),
                builder: (context, streamSnapshot) {
                  if (streamSnapshot.data == null) return CircularProgressIndicator(); //v v imp
                  String name;
                  String thumbnailPicture;

                  return FutureBuilder(
                    future: GetBazaarWalasBasicProfileInfo(userNumber: bazaarWalaPhoneNo).getNameAndThumbnailPicture(),
                    builder: (BuildContext context, AsyncSnapshot nameSnapshot) {
                      if (nameSnapshot.connectionState == ConnectionState.done) {
                        name = nameSnapshot.data["name"];
                        thumbnailPicture = nameSnapshot.data["thumbnailPicture"];
                        return BazaarIndividualCategoryListDisplay(
                          bazaarWalaName: name,
                          bazaarWalaPhoneNo: bazaarWalaPhoneNo,
                          category: category,
                          thumbnailPicture: thumbnailPicture,
                        );
                      }
                      return Center(child: CircularProgressIndicator());
//                        BazaarIndividualCategoryListDisplay(
//                        bazaarWalaName: category.toString(),
//                        bazaarWalaPhoneNo: bazaarWalaPhoneNo,
//                        category: category,
//                        thumbnailPicture: PlaceHolderImages().bazaarWalaThumbnailPicture,
//                      );
                    },
                  );
                }
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
            thumbnailPicture: PlaceHolderImages().bazaarWalaThumbnailPicture,
          );
        }
    );
  }

}
