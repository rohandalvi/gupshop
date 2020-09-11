import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarOnBoarding/subCategoriesCheckBox.dart';
import 'package:gupshop/retriveFromFirebase/getCategoriesFromCategoriesMetadata.dart';

class SubCategoryCheckBoxData extends StatefulWidget {
  final String categoryData;
  final String category;
  final Future<List<DocumentSnapshot>> subCategoriesListFuture;
  final List<DocumentSnapshot> subCategoriesList;

  Map<String, String> subCategoryMap;

  SubCategoryCheckBoxData({this.categoryData, this.subCategoriesList, this.subCategoriesListFuture,
    this.category, this.subCategoryMap,});

  @override
  _SubCategoryCheckBoxDataState createState() => _SubCategoryCheckBoxDataState();
}

class _SubCategoryCheckBoxDataState extends State<SubCategoryCheckBoxData> {

  Map<String, bool > map = new HashMap();
  bool isBazaarwala;

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
  Widget build(BuildContext context) {
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
            isBazaarwala = true;
          }
          return SubCategoriesCheckBox(
            map: map,
            subCategoriesList: widget.subCategoriesList,
            subCategoriesListFuture: widget.subCategoriesListFuture,
            category: widget.category,
            categoryData: widget.categoryData,
            subCategoryMap: widget.subCategoryMap,
            isBazaarwala: isBazaarwala,
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
}
