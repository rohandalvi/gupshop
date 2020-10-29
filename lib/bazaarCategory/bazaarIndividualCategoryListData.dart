import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/bazaarCategory/bazaarIndividualCategoryNameDpBuilder.dart';
import 'package:gupshop/bazaarCategory/changeLocationInSearch.dart';
import 'package:gupshop/bazaarCategory/noSubcategoryText.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/location/locationPermissionHandler.dart';

import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/notifications/IRules.dart';
import 'package:gupshop/notifications/NotificationEventType.dart';
import 'package:gupshop/notifications/application/notificationConsumerMethods.dart';


import 'package:gupshop/responsive/bazaarAndMapConfig.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/retriveFromFirebase/bazaarCategoryTypesAndImages.dart';
import 'package:gupshop/bazaarLocation/filterBazaarLocationData.dart';
import 'package:gupshop/retriveFromFirebase/getUsersLocation.dart';

import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/bazaarCategory/bazaarIndividualCategoryListDisplay.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customRichText.dart';
import 'package:gupshop/widgets/customShowDialog.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/paddedMarginedContainer.dart';

class BazaarIndividualCategoryListData extends StatefulWidget implements IRules{
  final String category;
  final String categoryData;
  final String subCategory;
  final String subCategoryData;
  final bool showHomeService;

  List<String> userGeohash;
  String addressName;


  BazaarIndividualCategoryListData({this.category, this.subCategory, this.subCategoryData,
    this.categoryData,this.showHomeService,this.userGeohash, this.addressName,
  });

  @override
  _BazaarIndividualCategoryListDataState createState() => _BazaarIndividualCategoryListDataState();

  @override
  bool apply(NotificationEventType eventType, String conversationId) {
    return true;
  }
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

    /// first check if user has given permission to access location
    var permission = await LocationPermissionHandler().handlePermissions(context);
    if(permission == true){
      String userNo = await UserDetails().getUserPhoneNoFuture();//get user phone no
      userPhoneNo = userNo;
      print("in getListOfBazaarWalasInAGivenRadius : ${widget.userGeohash}");

      /// if the user does not change location, then userGeohash
      /// would be null
      /// In that case, select the geoHash pushed to firebase
      /// in bazaarHome page which is the current location of the user
      ///
      /// userGeohash will have value inherited from prior class only in
      /// case of drivers and errandRunners
      if(widget.userGeohash  == null){
        widget.userGeohash = await FilterBazaarLocationData(subCategory: widget.subCategoryData).getUserGeohashList(userPhoneNo);
      }

      var listOfbazaarwalas = await FilterBazaarLocationData(subCategory: widget.subCategoryData).getListOfBazaarWalasInAGivenRadius(userPhoneNo, widget.categoryData, widget.userGeohash);
      return listOfbazaarwalas;
    }
  }


  @override
  void initState() {

    notificationInit();

    if(widget.addressName == null){
      widget.addressName = TextConfig.usersLocationCollectionHome;/// home
    }
    super.initState();
  }


  /// navigator methods:
  notificationInit(){
    NotificationConsumerMethods().notificationInit(
        runtimeType: this.widget.runtimeType,
        widget: this.widget,
        onSelectNotificationFromConsumer: onSelectNotification
    );
  }


  /// when the user taps the notification:
  Future<void> onSelectNotification(String payload) async{
    String userName = await UserDetails().getUserNameFuture();
    String userNumber = await UserDetails().getUserPhoneNoFuture();

    NotificationConsumerMethods(
        userName: userName,
        userPhoneNo: userNumber,
        customContext: context
    ).onSelectNotification(payload);
  }

  @override
  Widget build(BuildContext context) {
    print("in BazaarIndividualCategoryListData build");
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

              Map<String,dynamic> navigatorMap = new Map();
              navigatorMap[TextConfig.bazaarWalaPhoneNo] = bazaarWalaPhoneNo;
              navigatorMap[TextConfig.subCategoryMap] = subCategoryMap;
              navigatorMap[TextConfig.subCategoriesList] = subCategoriesList;
              navigatorMap[TextConfig.subCategoriesListFuture] = subCategoriesListFuture;
              navigatorMap[TextConfig.category] = widget.category;
              navigatorMap[TextConfig.categoryData] = widget.categoryData;

              Navigator.pushNamed(context, NavigatorConfig.subCategorySearch, arguments: navigatorMap);
            },
            actions: <Widget>[
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


              List<DocumentSnapshot> list = snapshot.data;

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
    return Flexible(/// for responsiveness
      child: Padding(
        padding: EdgeInsets.all(PaddingConfig.eight),
        child: Wrap(
          children: <Widget>[
            Container(
              child: CustomRichText(
                children: <TextSpan>[
                  CustomText(text: TextConfig.showingResultsFor,).richText(),
                  CustomText(
                    text: widget.addressName,textColor: primaryColor,
                    onTap: () async{
                      Map<String,dynamic> navigatorMap = new Map();
                      navigatorMap[TextConfig.userPhoneNo] = userPhoneNo;

                      /// changing from bool to dynamic else was getting error
                      /// type 'MaterialPageRoute<dynamic>' is not a subtype of type 'Route<bool>'
                      /// While this loses some type safety, s works fine for now.
                      dynamic tempIsAddressChanged = await Navigator.pushNamed(context, NavigatorConfig.addressList, arguments: navigatorMap);
                      //await NavigateToAddressList(userPhoneNo: userPhoneNo).navigateNoBrackets(context);
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
                  ).richText(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  noBazaarwalaWidget(String noBazaarwalaText){
    /// this expanded makes the text to appear in the center, remove this and
    /// the text appears on the top of the screen
    return Expanded(
      child: Center(
        child: PaddedMarginedContainer(
          child :  FittedBox(/// to avoid overflow in any device, to make it responsive
            child: CustomRichText(
              children: <TextSpan>[
                CustomText(text: TextConfig.no,).richText(),
                CustomText(text: noBazaarwalaText,textColor: primaryColor,
                  fontSize: WidgetConfig.bigFontSize,).richText(),
                CustomText(text: TextConfig.nearYou,).richText(),
              ],
            ),
          ),
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
            thumbnailPicture: ImageConfig.bazaarWalaThumbnailPicture,
          );
        }
    );
  }

  changeLocation(BuildContext context){
    return CustomIconButton(
      iconNameInImageFolder: IconConfig.location,
      onPressed: () async{
        /// first check if user has given permission to access location
        var permission = await LocationPermissionHandler().handlePermissions(context);
        if(permission == true){

          /// placeholder till map is generated:
          /// show a dialog box with CircularProgressIndicator
          CustomShowDialog().main(context, BazaarConfig.loadingMap, barrierDismissible: false);

          String userPhoneNo = await UserDetails().getUserPhoneNoFuture();
          Map<String, dynamic> userGeohashAndAddressMap = await ChangeLocationInSearch(
              userNumber: userPhoneNo)
              .getNewUserGeohash(context);

          List<String> tempHash = userGeohashAndAddressMap[TextConfig.usersLocationCollectionGeoHashList];

          /// for exiting dialog:
          Navigator.pop(context);

          String addressNameForAddress = userGeohashAndAddressMap[TextConfig.changeLocationInSearchAddressName];
          String tempAddressName = await GetUsersLocation(userPhoneNo: userPhoneNo).getAddressFromAddressName(addressNameForAddress);
          setState(() {
            widget.userGeohash = tempHash;
            widget.addressName = tempAddressName;
          });
        }
      },
    );
  }
}
