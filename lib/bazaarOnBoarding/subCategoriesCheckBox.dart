import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarWalasBasicProfileCollection.dart';
import 'package:gupshop/bazaarCategory/homeServiceText.dart';
import 'package:gupshop/bazaarOnBoarding/pushSubCategoriesToFirebase.dart';
import 'package:gupshop/bazaarOnBoarding/subCategoryCheckBoxUI.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToBazaarOnBoardingHome.dart';
import 'package:gupshop/navigators/navigateToBazaarOnBoardingProfile.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/contactSearch/contact_search.dart';
import 'package:gupshop/retriveFromFirebase/getCategoriesFromCategoriesMetadata.dart';
import 'package:gupshop/widgets/customDialogForConfirmation.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';
import 'package:gupshop/widgets/customText.dart';

class SubCategoriesCheckBox extends StatefulWidget {
  final String category;
  final String categoryData;
  final Future<List<DocumentSnapshot>> subCategoriesListFuture;
  final List<DocumentSnapshot> subCategoriesList;
  Map<String, String> subCategoryMap;

  SubCategoriesCheckBox({this.subCategoriesList, this.subCategoriesListFuture,
    this.category, this.subCategoryMap, this.categoryData});

  @override
  _SubCategoriesCheckBoxState createState() => _SubCategoriesCheckBoxState();
}

class _SubCategoriesCheckBoxState extends State<SubCategoriesCheckBox> {
  Map<String, bool > map = new HashMap();
  List<String> listOfSubCategories = new List();
  Set tempSet = new HashSet();
  List<String> listOfSubCategoriesForData = new List();
  bool isCategorySelected = false;


  getCategorySizeFuture() {
    Map mapOfDocumentSnapshots = widget.subCategoriesList.asMap();
    /// initializing 'map' with false values
    mapOfDocumentSnapshots.forEach((key, value) {
      String temp = mapOfDocumentSnapshots[key].data["name"];
      map.putIfAbsent(temp, () => false);
    });
  }


  /// if the user is already a bazaarwala then the categories should already
  /// be selected and the forward button should also be visible.
  /// To check if the user has selected any categories, then isCategorySelected
  /// would show as true and would make the forward icon visible.
  categorySelectedCheck() async{
    List<DocumentSnapshot> dc = await GetCategoriesFromCategoriesMetadata
      (category: widget.categoryData,).selectedCategories();

    if(dc[0].data.isEmpty == true){
      setState(() {
        isCategorySelected = false;
      });
    }else{
      setState(() {
        isCategorySelected = true;
      });
    }


  }

  @override
  void initState() {
    getCategorySizeFuture();
    categorySelectedCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: <Widget>[
          appBarBody(context),
          showButton(), /// would show only if one or more contact is selected
        ],
      ),
    );
  }


  Widget appBarBody(BuildContext context) {
    return FutureBuilder(
      future: GetCategoriesFromCategoriesMetadata(category: widget.categoryData,).getSelectedCategoriesAsMap(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if(snapshot.data != null){
            /// if the user is a bazaarwala already, then, we create a map of
            /// the selected categories and merge it with 'map'.
            /// so value: map[doc.data["name"]] will show true and false
            /// accordingly
            Map categorySelectedMap = snapshot.data;
            mergeMaps(categorySelectedMap, map);
            isCategorySelected = true;
          }
          return ContactSearch(
            suggestions: widget.subCategoriesList,
            navigate: NavigateToBazaarOnBoardingHome().navigate(context),
            onSearch: searchList,
            hintText: 'What is your speciality ?',
            onItemFound: (DocumentSnapshot doc, int index) {
                return Container(
                child: CheckboxListTile(
                    controlAffinity:ListTileControlAffinity.leading ,
                    title:CustomText(text: doc.data["name"]),
                    activeColor: primaryColor,
                    value: map[doc.data["name"]],/// if value of a key in map(a subcategory name) is false or true
                    //list[index],/// at first all the values would be false
                    onChanged: (bool val) async{
                      setState((){
                        map[doc.data["name"]] = val; /// setting the new value as selected by user
                        isCategorySelected = val;
                      });

                      String subCategoryData = widget.subCategoryMap[doc.data["name"]];

                      String isHomeServiceApplicable = HomeServiceText(categoryData:widget.categoryData,
                          subCategoryData: subCategoryData).bazaarWalasdialogText();
                      if(isHomeServiceApplicable != null){
                        bool homeService = false;

                        if(val == true){
                          homeService = await homeServiceDialog(isHomeServiceApplicable);
                        }
                        pushToBazaarWalasBasicProfile(subCategoryData, homeService);
                      }
                    }
                ),
              );
            },
            //onItemFound: ,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  mergeMaps(Map categorySelectedMap, Map blankMap){

    blankMap.forEach((key, value) {
      if(categorySelectedMap.containsKey(key)){
        blankMap[key] = true;
      }
    });
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


  pushToBazaarWalasBasicProfile(String subCategoryData, bool homeService) async{
    String userPhoneNo = await UserDetails().getUserPhoneNoFuture();
      await PushToBazaarWalasBasicProfile(
        categoryData: widget.categoryData,
        subCategoryData: subCategoryData,
        userPhoneNo: userPhoneNo,
        homeService: homeService,
      ).pushHomeService();
  }


  Future<List<DocumentSnapshot>> searchList(String text) async {
    List<DocumentSnapshot> list = await widget.subCategoriesListFuture;
    return list.where((l) =>
    l.data["name"]
        .toLowerCase()
        .contains(text.toLowerCase()) || l.documentID.contains(text)).toList();
  }


  bool isSubCategorySelectedWidget(){
    if(map.containsValue(true)) isCategorySelected = true;
    else isCategorySelected = false;
  }

  showButton() {
    return Visibility(
      visible: isCategorySelected,
      child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            height: WidgetConfig.groupIconHeight,/// to increase the size of floatingActionButton use container along with FittedBox
            width: WidgetConfig.groupIconWidth,
            child: FittedBox(
              child: CustomFloatingActionButtonWithIcon(
                  iconName: 'forward2',
                  tooltip: 'Go ahead',
                  /// create a listOfContactsSelected and send it to individualChat
                  onPressed: () async{
                    String userName = await UserDetails().getUserNameFuture();
                    String userNumber = await UserDetails().getUserPhoneNoFuture();

                    /// create subCategories list:
                    subCategoriesList();

                    /// push the subCategories to database:
                    pushSubCategoriesToFirebase();

                    /// moving on to next page:
                    NavigateToBazaarOnBoardingProfile(
                      category:widget.category,
                      categoryData: widget.categoryData,
                      listOfSubCategories: listOfSubCategories,
                      userPhoneNo: userNumber,
                      userName: userName,
                      //subCategoriesListFuture: widget.subCategoriesListFuture,
                      subCategoryMap: widget.subCategoryMap,
                      listOfSubCategoriesForData: listOfSubCategoriesForData,
                    ).navigateNoBrackets(context);
                  }
              ),
            ),
          )
      ),
    );
  }

  subCategoriesList() {
    bool isAdded;

    map.forEach((key, value) {
      if(value == true){
        isAdded = tempSet.add(key);/// adding the numbers in a set because, if the user comes back from the nameScreen then the numbers shouldnt duplicate in the list, using set ensures that.
        if(isAdded == true){/// if the set already has the number added then dont add it again in the list
          listOfSubCategories.add(key);
          listOfSubCategoriesForData.add(widget.subCategoryMap[key]);
        }
      }
    });
  }

  pushSubCategoriesToFirebase() async{
    String userName = await UserDetails().getUserNameFuture();
    String userNumber = await UserDetails().getUserPhoneNoFuture();

    PushSubCategoriesToFirebase(category: widget.categoryData,userPhoneNo: userNumber,
      userName: userName, listOfSubCategoriesData: listOfSubCategoriesForData
    ).bazaarCategories();

    PushSubCategoriesToFirebase(category: widget.categoryData,userPhoneNo: userNumber,
        userName: userName, listOfSubCategoriesData: listOfSubCategoriesForData,listOfSubCategories: listOfSubCategories ).bazaarCategoriesMetaData();

    PushSubCategoriesToFirebase(category: widget.categoryData,userPhoneNo: userNumber,
        userName: userName, listOfSubCategoriesData: listOfSubCategoriesForData).createBlankRatingNumber();

    PushSubCategoriesToFirebase(category: widget.categoryData,userPhoneNo: userNumber,
        userName: userName, listOfSubCategoriesData: listOfSubCategoriesForData).createBlankReviews();

    PushSubCategoriesToFirebase(category: widget.categoryData,userPhoneNo: userNumber,
        userName: userName, listOfSubCategoriesData: listOfSubCategoriesForData).bazaarWalasLocation();
  }
}
