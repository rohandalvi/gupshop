import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarCategory/bazaarIndividualCategoryListData.dart';
import 'package:gupshop/bazaarCategory/changeLocationInSearch.dart';
import 'package:gupshop/bazaarHomeService/homeServiceText.dart';
import 'package:gupshop/contactSearch/contact_search.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/responsive/bazaarAndMapConfig.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/retriveFromFirebase/getUsersLocation.dart';
import 'package:gupshop/widgets/customDialogForConfirmation.dart';
import 'package:gupshop/widgets/customShowDialog.dart';
import 'package:gupshop/widgets/customText.dart';

class SubCategorySearch extends StatefulWidget {
  final String category;
  final String categoryData;
  final Future<List<DocumentSnapshot>> subCategoriesListFuture;
  final List<DocumentSnapshot> subCategoriesList;
  Map<String, String> subCategoryMap;
  final String bazaarWalaName;
  final String bazaarWalaPhoneNo;

  SubCategorySearch({this.subCategoriesList, this.subCategoriesListFuture,
    this.category, this.subCategoryMap, this.bazaarWalaName, this.bazaarWalaPhoneNo,
    this.categoryData,
  });

  @override
  _SubCategorySearchState createState() => _SubCategorySearchState();
}

class _SubCategorySearchState extends State<SubCategorySearch> {
  Map<String, bool > map = new HashMap();
  List<String> listOfSubCategories = new List();
  Set tempSet = new HashSet();
  List<String> listOfSubCategoriesForData = new List();
  bool showHomeService;
  List<String> userGeohash;
  String addressName;


  getCategorySizeFuture() {
    Map mapOfDocumentSnapshots = widget.subCategoriesList.asMap();
    /// initializing 'mapOfDocumentSnapshots' with false values
    mapOfDocumentSnapshots.forEach((key, value) {
      String temp = mapOfDocumentSnapshots[key].data[TextConfig.subCategorySearchName];
      map.putIfAbsent(temp, () => false);
    });
  }

  homeLocationSet() async{
    String userPhoneNo = await UserDetails().getUserPhoneNoFuture();
    String userName = await UserDetails().getUserNameFuture();
    var homeAddress = await GetUsersLocation(userPhoneNo: userPhoneNo)
        .getHomeAddress();

    if(homeAddress == null){
      CustomShowDialog().withActions(
        context,
        TextConfig.locationNotFound,
        barrierDismissible: false,
        actions: <Widget>[
          FlatButton(
              onPressed: (){
                Map<String,dynamic> navigatorMap = new Map();
                navigatorMap[TextConfig.initialIndex] = 1;
                navigatorMap[TextConfig.userPhoneNo] = userPhoneNo;
                navigatorMap[TextConfig.userName] = userName;

                Navigator.pushNamed(context, NavigatorConfig.home, arguments: navigatorMap);
                //NavigateToHome(initialIndex: 1).navigateNoBrackets(context),
              },
              child: CustomText(text:'OK')
          ),
        ],
      );
    }
  }


  @override
  void initState() {
    homeLocationSet();
    getCategorySizeFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: <Widget>[
//          FutureBuilder(
//            future: GetUsersLocation(userPhoneNo: widget.userPhoneNo)
//                .getHomeAddress(),
//            builder: (BuildContext context, AsyncSnapshot snapshot) {
//              if (snapshot.connectionState == ConnectionState.done) {
//                if(snapshot.data == null){
//                  CustomShowDialog().withActions(
//                      context,
//                      "Unable to find location",
//                      barrierDismissible: false,
//                      actions: <Widget>[
//                        FlatButton(
//                            onPressed: () => Navigator.of(context).pop(true),
//                            child: CustomText(text:'OK')
//                        ),
//                    ],
//                  );
//                  return appBarBody(context);
//                }else return appBarBody(context);
//              }
//              return Center(
//                child: CircularProgressIndicator(),
//              );
//            },
//          )
          appBarBody(context),
          //showButton(), /// would show only if one or more contact is selected
        ],
      ),
    );
  }


  Widget appBarBody(BuildContext context) {
    return ContactSearch(
      suggestions: widget.subCategoriesList,
      navigate: () async{
        String userPhoneNo = await UserDetails().getUserPhoneNoFuture();
        String userName = await UserDetails().getUserNameFuture();

        Map<String,dynamic> navigatorMap = new Map();
        navigatorMap[TextConfig.initialIndex] = 1;
        navigatorMap[TextConfig.userPhoneNo] = userPhoneNo;
        navigatorMap[TextConfig.userName] = userName;

        Navigator.pushNamed(context, NavigatorConfig.home, arguments: navigatorMap);
      },
      //navigate: NavigateToBazaarOnBoardingHome().navigate(context),
      onSearch: searchList,
      hintText: TextConfig.getsubcategorySearchHintText(widget.category),
      onItemFound: (DocumentSnapshot doc, int index){
        return buildSubCategoryNameList(doc,);
      },
      //onItemFound: ,
    );
  }

  ListTile buildSubCategoryNameList(DocumentSnapshot doc,) {
    return ListTile(
      title: CustomText(text: doc.data[TextConfig.subCategorySearchName]),
      ///displaying on the display name
      onTap: () async{
        String subCategory = doc.data[TextConfig.subCategorySearchName];
        String subCategoryData = widget.subCategoryMap[subCategory];
        bool showHomeService;

        String isHomeServiceApplicable = HomeServiceText(categoryData:widget.categoryData,
            subCategoryData: subCategoryData).userDialogDisplayText();
        if(isHomeServiceApplicable != null){
          showHomeService = await homeServiceDialog(isHomeServiceApplicable);
        }


        /// for drivers and delivery/errands
        if(widget.categoryData == HomeServiceText.deliveryErrands || widget.categoryData == HomeServiceText.drivers){
//        if(widget.categoryData == "deliveryErrands" || widget.categoryData == 'drivers'){

          Map<String, dynamic> userGeohashAndAddressMap = await getLocation();
          userGeohash = userGeohashAndAddressMap[TextConfig.usersLocationCollectionGeoHashList];
          /// for exiting dialog:
          Navigator.pop(context);

//          addressName = await getAddressName(userGeohash);
          String addressNameForAddress = userGeohashAndAddressMap[TextConfig.changeLocationInSearchAddressName];

          String userPhoneNo = await UserDetails().getUserPhoneNoFuture();
          addressName = await GetUsersLocation(userPhoneNo: userPhoneNo).getAddressFromAddressName(addressNameForAddress);
        }


        /// for all categories except drivers and delivery/errands
        Map<String,dynamic> navigatorMap = new Map();
        navigatorMap[TextConfig.category] = widget.category;
        navigatorMap[TextConfig.categoryData] = widget.categoryData;
        navigatorMap[TextConfig.subCategory] = subCategory;
        navigatorMap[TextConfig.subCategoryData] = subCategoryData;
        navigatorMap[TextConfig.showHomeService] = showHomeService;
        navigatorMap[TextConfig.userGeohash] = userGeohash;
        navigatorMap[TextConfig.addressName] = addressName;


        Navigator.pushNamed(context, NavigatorConfig.bazaarIndividualCategoryListData, arguments: navigatorMap);
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//              builder: (context) => BazaarIndividualCategoryListData(
//                category : widget.category,
//                categoryData: widget.categoryData,
//                subCategory: subCategory,
//                subCategoryData: subCategoryData,
//                showHomeService: showHomeService,
//                userGeohash: userGeohash,
//                addressName: addressName,
//                //category: categoryNameForBazaarIndividualCategoryList,
//              ),//pass Name() here and pass Home()in name_screen
//            )
//        );

      }
    );
  }

  homeServiceDialog(String homeServiceText) async{
    bool temp = await CustomDialogForConfirmation(
      /// from homeServiceText
      title: homeServiceText,
      content: "",
      barrierDismissible: false,
    ).dialog(context);
    return temp;
  }


  Future<List<DocumentSnapshot>> searchList(String text) async {
    List<DocumentSnapshot> list = await widget.subCategoriesListFuture;
    return list.where((l) =>
    l.data[TextConfig.subCategorySearchName]
        .toLowerCase()
        .contains(text.toLowerCase()) || l.documentID.contains(text)).toList();
  }


  bool isSubCategorySelected(){
    if(map.containsValue(true)) return true;
    return false;
  }


  /// for adding Picking location in case of drivers and delivery/errands
  getLocation() async{
    String userPhoneNo = await UserDetails().getUserPhoneNoFuture();
    String placeholder = BazaarConfig(category: widget.category, categoryData: widget.categoryData).getPickLocation();
    //bool showBackButton = false;

    CustomShowDialog().main(context, BazaarConfig.loadingMap, barrierDismissible: false);
    Map<String, dynamic> result = await ChangeLocationInSearch(userNumber: userPhoneNo,
        placeholder: placeholder, )
        .getNewUserGeohash(context);

    return result;
  }

  getPlaceholderName(){

  }


//  getAddressName(List<String> userGeohash) async{
//    String userPhoneNo = await UserDetails().getUserPhoneNoFuture();
//
//    return await UsersLocation().getAddress(userPhoneNo, userGeohash);
//  }
}
