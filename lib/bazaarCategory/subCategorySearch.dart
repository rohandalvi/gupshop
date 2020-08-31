import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/navigators/navigateToBazaarOnBoardingHome.dart';
import 'package:gupshop/navigators/navigateToProductDetailPage.dart';
import 'package:gupshop/contactSearch/contact_search.dart';
import 'package:gupshop/widgets/customText.dart';

class SubCategorySearch extends StatefulWidget {
  final String category;
  final Future<List<DocumentSnapshot>> subCategoriesListFuture;
  final List<DocumentSnapshot> subCategoriesList;
  Map<String, String> subCategoryMap;
  final String bazaarWalaName;
  final String bazaarWalaPhoneNo;

  SubCategorySearch({this.subCategoriesList, this.subCategoriesListFuture,
    this.category, this.subCategoryMap, this.bazaarWalaName, this.bazaarWalaPhoneNo});

  @override
  _SubCategorySearchState createState() => _SubCategorySearchState();
}

class _SubCategorySearchState extends State<SubCategorySearch> {
  Map<String, bool > map = new HashMap();
  List<String> listOfSubCategories = new List();
  Set tempSet = new HashSet();
  List<String> listOfSubCategoriesForData = new List();


  getCategorySizeFuture() {
    Map mapOfDocumentSnapshots = widget.subCategoriesList.asMap();
    /// initializing 'map' with false values
    mapOfDocumentSnapshots.forEach((key, value) {
      String temp = mapOfDocumentSnapshots[key].data["name"];
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
    return Stack(
      children: <Widget>[
        appBarBody(context),
        //showButton(), /// would show only if one or more contact is selected
      ],
    );
  }


  Widget appBarBody(BuildContext context) {
    return ContactSearch(
      suggestions: widget.subCategoriesList,
      navigate: NavigateToBazaarOnBoardingHome().navigate(context),
      onSearch: searchList,
      hintText: 'Search in ${widget.category} ?',
      onItemFound: (DocumentSnapshot doc, int index){
        return buildSubCategoryNameList(doc,);
      },
      //onItemFound: ,
    );
  }

  ListTile buildSubCategoryNameList(DocumentSnapshot doc,) {
    return ListTile(
      title: CustomText(text: doc.data["name"]),
      ///displaying on the display name
      onTap: () {
        String subCategory = doc.data["name"];
        NavigateToProductDetailPage(
          category: widget.category,
          subCategory: subCategory,
          bazaarWalaPhoneNo: widget.bazaarWalaPhoneNo,
          bazaarWalaName: widget.bazaarWalaName,
        ).navigateNoBrackets(context);
      }
    );
  }


  Future<List<DocumentSnapshot>> searchList(String text) async {
    List<DocumentSnapshot> list = await widget.subCategoriesListFuture;
    return list.where((l) =>
    l.data["name"]
        .toLowerCase()
        .contains(text.toLowerCase()) || l.documentID.contains(text)).toList();
  }


  bool isSubCategorySelected(){
    if(map.containsValue(true)) return true;
    return false;
  }


}
