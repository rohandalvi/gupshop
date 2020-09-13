import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/navigators/navigateToProductDetailPage.dart';
import 'package:gupshop/widgets/customSearch.dart';
import 'package:gupshop/widgets/customText.dart';

class BazaarSubCategorySearch extends StatefulWidget {
  final String category;
  final String categoryData;
  final List<String> subCategoriesList;
  Map<String, String> subCategoryMap;
  final String bazaarWalaName;
  final String bazaarWalaPhoneNo;
  final List<String> subCategoriesListData;

  BazaarSubCategorySearch({this.subCategoriesList,
    this.category, this.subCategoryMap, this.bazaarWalaName, this.bazaarWalaPhoneNo,
    this.categoryData,this.subCategoriesListData
  });

  @override
  _BazaarSubCategorySearchState createState() => _BazaarSubCategorySearchState();
}

class _BazaarSubCategorySearchState extends State<BazaarSubCategorySearch> {
  Map<String, bool > map = new HashMap();
  List<String> listOfSubCategories = new List();
  Set tempSet = new HashSet();
  List<String> listOfSubCategoriesForData = new List();


  getCategorySizeFuture() {
    Map mapOfDocumentSnapshots = widget.subCategoriesList.asMap();
    /// initializing 'map' with false values
    mapOfDocumentSnapshots.forEach((key, value) {
      String temp = mapOfDocumentSnapshots[key];
      map.putIfAbsent(temp, () => false);
    });
  }


  @override
  void initState() {
    getCategorySizeFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: <Widget>[
          appBarBody(context),
          //showButton(), /// would show only if one or more contact is selected
        ],
      ),
    );
  }


  Widget appBarBody(BuildContext context) {
    return CustomSearch<String>(
      backButton: (){
        Navigator.pop(context);
      },
      suggestions: widget.subCategoriesList,
      //navigate: NavigateToBazaarOnBoardingHome().navigate(context),
      onSearch: searchList,
      hintText: 'Search in ${widget.category}',
      onItemFound: (String name, int index){
        return buildSubCategoryNameList(name,);
      },
      //onItemFound: ,
    );
  }

  ListTile buildSubCategoryNameList(String name,) {
    return ListTile(
      title: CustomText(text: name),
      ///displaying on the display name
      onTap: () {
        String subCategory = name;
        String subCategoryData = widget.subCategoryMap[subCategory];
        NavigateToProductDetailPage(
          sendHome: true,
          categoryData: widget.categoryData,
          category: widget.category,
          subCategory: subCategory,
          bazaarWalaPhoneNo: widget.bazaarWalaPhoneNo,
          bazaarWalaName: widget.bazaarWalaName,
          subCategoryData: subCategoryData
        ).navigateNoBrackets(context);
      }
    );
  }


  Future<List<String>> searchList(String text) async {
    List<String> list = widget.subCategoriesList;
    return list.where((l) =>
    l.toLowerCase()
        .contains(text.toLowerCase())).toList();
  }


  bool isSubCategorySelected(){
    if(map.containsValue(true)) return true;
    return false;
  }


}
