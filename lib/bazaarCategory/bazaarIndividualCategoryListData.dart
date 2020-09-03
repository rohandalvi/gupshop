import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/bazaarCategory/bazaarIndividualCategoryNameDpBuilder.dart';
import 'package:gupshop/bazaar/placeHolderImages.dart';
import 'package:gupshop/bazaarCategory/changeLocationInSearch.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToAddressList.dart';
import 'package:gupshop/navigators/navigateToSubCategorySearch.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/retriveFromFirebase/bazaarCategoryTypesAndImages.dart';
import 'package:gupshop/bazaarLocation/filterBazaarLocationData.dart';
import 'package:gupshop/usersLocation/usersLocation.dart';
import 'package:gupshop/widgets/clickableText.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/bazaarCategory/bazaarIndividualCategoryListDisplay.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class BazaarIndividualCategoryListData extends StatefulWidget {
  final String category;
  final String categoryData;
  final String subCategory;
  final String subCategoryData;
  final bool showHomeService;


  BazaarIndividualCategoryListData({this.category, this.subCategory, this.subCategoryData,
    this.categoryData,this.showHomeService,
  });

  @override
  _BazaarIndividualCategoryListDataState createState() => _BazaarIndividualCategoryListDataState();
}

class _BazaarIndividualCategoryListDataState extends State<BazaarIndividualCategoryListData> {
  Future<QuerySnapshot> getBazaarWalasInAGivenRadius;

  double latitude;

  double longitude;

  Future<dynamic> result;

  String userGeohashString;

  Future userPhoneNoFuture;

  String userPhoneNo;

  List<DocumentSnapshot> list;

  String bazaarWalaPhoneNo;

  int numberOfBazaarWalasInList;

  String userGeohash;
  String addressName = "home";


  getListOfBazaarWalasInAGivenRadius() async{
    print("userGeohash in getListOfBazaarWalasInAGivenRadius : $userGeohash");
    String userNo = await UserDetails().getUserPhoneNoFuture();//get user phone no
    userPhoneNo = userNo;

    /// if the user does not change location, then userGeohash
    /// would be null
    /// In that case, select the geoHash pushed to firebase
    /// in bazaarHome page which is the current location of the user
    if(userGeohash  == null){
      userGeohash = await FilterBazaarLocationData(subCategory: widget.subCategoryData).getUserGeohash(userPhoneNo);
    }

    var listOfbazaarwalas = await FilterBazaarLocationData(subCategory: widget.subCategoryData).getListOfBazaarWalasInAGivenRadius(userPhoneNo, widget.categoryData, userGeohash);
    return listOfbazaarwalas;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(WidgetConfig.appBarBazaarOnBoarding),
          child: CustomAppBar(
            title: CustomText(text: widget.category.toUpperCase(),),
            /// back button
            onPressed: () async{
              Future<List<DocumentSnapshot>> subCategoriesListFuture = BazaarCategoryTypesAndImages().getSubCategories(widget.categoryData);
              List<DocumentSnapshot> subCategoriesList = await subCategoriesListFuture;
              Map<String, String> subCategoryMap = await BazaarCategoryTypesAndImages().getSubCategoriesMap(widget.categoryData);

              NavigateToSubCategorySearch(
                bazaarWalaPhoneNo: bazaarWalaPhoneNo,
                subCategoryMap: subCategoryMap,
                subCategoriesList: subCategoriesList,
                subCategoriesListFuture: subCategoriesListFuture,
                category: widget.category,
                categoryData: widget.categoryData,
              ).navigateNoBrackets(context);
             //NavigateToHome(initialIndex: 1).navigateNoBrackets(context);
            },
            actions: <Widget>[
              CustomIconButton(
                iconNameInImageFolder: 'locationPin',
                onPressed: (){
                  NavigateToAddressList(userPhoneNo: userPhoneNo).navigateNoBrackets(context);
                },
              ),
              changeLocation(context),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            ClickableText(
                text : "Showing results for : ${addressName.toUpperCase()}",
              onTap: (){

              },
            ),
            FutureBuilder(
              future: getListOfBazaarWalasInAGivenRadius(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null) return Container(child: Center(child: CustomText(text: 'No ${widget.category}s near you',).bold())); //for avoding  the erro

              var list = snapshot.data;

              numberOfBazaarWalasInList = snapshot.data.length; ///for listView builder's itemcount

              return ListView.builder(
                shrinkWrap: true,/// required to show the address widget
                itemCount: numberOfBazaarWalasInList,
                itemBuilder: (BuildContext context, int index) {
                  bazaarWalaPhoneNo = list[index].documentID;
                  return BazaarIndividualCategoryNameDpBuilder(
                    bazaarWalaPhoneNo: bazaarWalaPhoneNo,
                    category: widget.category,
                    categoryData: widget.categoryData,
                    subCategory: widget.subCategory,
                    subCategoryData : widget.subCategoryData,
                    showHomeService: widget.showHomeService,
                  );
                },

                );
              }
              return //listOfBazaarWalasPlaceholder(numberOfBazaarWalasInList, bazaarWalaPhoneNo);
                Center(child: CircularProgressIndicator());
              }
            ),
          ],
        ),
      ),
    );
  }

  listOfBazaarWalasPlaceholder(int numberOfBazaarWalasInList, String bazaarWalaPhoneNo){
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index){
          return BazaarIndividualCategoryListDisplay(
            bazaarWalaName: widget.category.toString(),
            bazaarWalaPhoneNo: bazaarWalaPhoneNo,
            category: widget.category,
            categoryData: widget.categoryData,
            subCategory: widget.subCategory,
            subCategoryData: widget.subCategoryData,
            thumbnailPicture: PlaceHolderImages().bazaarWalaThumbnailPicture,
          );
        }
    );
  }

  changeLocation(BuildContext context){
    return CustomIconButton(
      iconNameInImageFolder: 'location',
      onPressed: () async{
        String userPhoneNo = await UserDetails().getUserPhoneNoFuture();
        String tempHash = await ChangeLocationInSearch(userNumber: userPhoneNo)
            .getNewUserGeohash(context);

        print("tempHash : $tempHash");

        String tempAddressName = await UsersLocation().getAddressName(userPhoneNo, tempHash);
        setState(() {
          userGeohash = tempHash;
          addressName = tempAddressName;
        });
      },
    );
  }
}
