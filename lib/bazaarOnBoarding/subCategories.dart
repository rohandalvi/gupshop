import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/navigators/navigateToBazaarOnBoardingHome.dart';
import 'package:gupshop/widgets/contact_search.dart';
import 'package:gupshop/widgets/customText.dart';

class SubCategories extends StatefulWidget {
  final Future<List<DocumentSnapshot>> subCategoriesListFuture;
  final List<DocumentSnapshot> subCategoriesList;

  SubCategories({this.subCategoriesList, this.subCategoriesListFuture});

  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  Map<String, bool > map = new HashMap();


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
    return ContactSearch(
      suggestions: widget.subCategoriesList,
      navigate: NavigateToBazaarOnBoardingHome().navigate(context),
      onSearch: searchList,
      onItemFound: (DocumentSnapshot doc, int index){
        return Container(
          child: CheckboxListTile(
            controlAffinity:ListTileControlAffinity.leading ,
            title:CustomText(text: doc.data["name"]),
            activeColor: primaryColor,
            value: map[doc.data["name"]],/// if value of a key in map(a phonenumber) is false or true
            //list[index],/// at first all the values would be false
            onChanged: (bool val){
              setState(() {
                map[doc.data["name"]] = val; /// setting the new value as selected by user
              });
            }
          ),
        );
      },
      //onItemFound: ,
    );
  }


  Future<List<DocumentSnapshot>> searchList(String text) async {
    return widget.subCategoriesListFuture;
  }

  suggestions(){
    return widget.subCategoriesList;
  }
}
