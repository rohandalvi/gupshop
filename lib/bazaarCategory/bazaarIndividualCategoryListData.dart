import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/bazaarCategory/bazaarIndividualCategoryNameDpBuilder.dart';
import 'package:gupshop/bazaarCategory/changeLocationInSearch.dart';
import 'package:gupshop/bazaarCategory/noSubcategoryText.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToAddressList.dart';
import 'package:gupshop/navigators/navigateToSubCategorySearch.dart';
import 'package:gupshop/placeholders/imagePlaceholder.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/retriveFromFirebase/bazaarCategoryTypesAndImages.dart';
import 'package:gupshop/bazaarLocation/filterBazaarLocationData.dart';
import 'package:gupshop/usersLocation/usersLocation.dart';
import 'package:gupshop/widgets/clickableText.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/bazaarCategory/bazaarIndividualCategoryListDisplay.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customRichText.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/paddedMarginedContainer.dart';

class BazaarIndividualCategoryListData extends StatefulWidget {
  final String category;
  final String categoryData;
  final String subCategory;
  final String subCategoryData;
  final bool showHomeService;

  String userGeohash;
  String addressName;


  BazaarIndividualCategoryListData({this.category, this.subCategory, this.subCategoryData,
    this.categoryData,this.showHomeService,this.userGeohash, this.addressName,
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

  bool isAddressChanged;


  getListOfBazaarWalasInAGivenRadius() async{
    print("userGeohash in getListOfBazaarWalasInAGivenRadius : ${widget.userGeohash}");
    String userNo = await UserDetails().getUserPhoneNoFuture();//get user phone no
    userPhoneNo = userNo;

    /// if the user does not change location, then userGeohash
    /// would be null
    /// In that case, select the geoHash pushed to firebase
    /// in bazaarHome page which is the current location of the user
    if(widget.userGeohash  == null){
      widget.userGeohash = await FilterBazaarLocationData(subCategory: widget.subCategoryData).getUserGeohash(userPhoneNo);
    }

    var listOfbazaarwalas = await FilterBazaarLocationData(subCategory: widget.subCategoryData).getListOfBazaarWalasInAGivenRadius(userPhoneNo, widget.categoryData, widget.userGeohash);
    return listOfbazaarwalas;
  }


  @override
  void initState() {
    if(widget.addressName == null){
      widget.addressName = 'home';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(WidgetConfig.appBarSeventy),
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
                onPressed: () async{
                  bool tempIsAddressChanged = await NavigateToAddressList(userPhoneNo: userPhoneNo).navigateNoBrackets(context);
                  if(tempIsAddressChanged == true){
                    setState(() {
                      isAddressChanged = tempIsAddressChanged;

                      /// if the user does not change location, then userGeohash
                      /// would be null
                      /// In that case, select the geoHash pushed to firebase
                      /// in bazaarHome page which is the current location of the user
                      ///
                      /// But, if the user changes the home location , then
                      /// the userGeohash wont be null, it would be the previous
                      /// home location, so set it to null
                      widget.userGeohash = null;
                    });
                  }
                },
              ),
              changeLocation(context),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            showResultsWidget(),
            FutureBuilder(
              future: getListOfBazaarWalasInAGivenRadius(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null || snapshot.data.isEmpty ){
                //String parameter = NoSubCategoryText().getCategoryDataName(widget.categoryData);
                String noBazaarwalaText = NoSubCategoryText().getText(widget.categoryData);
                return noBazaarwalaWidget(noBazaarwalaText); //for avoding  the erro
              }


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

  showResultsWidget() {
    return Padding(
      padding: EdgeInsets.all(PaddingConfig.eight),
      child: Container(
        child: CustomRichText(
          children: <TextSpan>[
            CustomText(text: 'Showing results for : ',).richText(),
            CustomText(text: widget.addressName,textColor: primaryColor,).richText(),
          ],
        ),
      ),
    );
  }

  noBazaarwalaWidget(String noBazaarwalaText){
    return PaddedMarginedContainer(
      child :  CustomRichText(
        children: <TextSpan>[
          CustomText(text: 'No ',).richText(),
          CustomText(text: noBazaarwalaText,textColor: primaryColor,
            fontSize: TextConfig().bigFontSize,).richText(),
          CustomText(text: ' near you',).richText(),
        ],
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
            thumbnailPicture: ImagePlaceholder.bazaarWalaThumbnailPicture,
          );
        }
    );
  }

  changeLocation(BuildContext context){
    return CustomIconButton(
      iconNameInImageFolder: 'location',
      onPressed: () async{
        //bool showBackButton = false;
        String userPhoneNo = await UserDetails().getUserPhoneNoFuture();
        String tempHash = await ChangeLocationInSearch(
            userNumber: userPhoneNo)
            .getNewUserGeohash(context);

        String tempAddressName = await UsersLocation().getAddress(userPhoneNo, tempHash);
        setState(() {
          widget.userGeohash = tempHash;
          widget.addressName = tempAddressName;
        });
      },
    );
  }
}
