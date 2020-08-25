import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/group/createGroup.dart';
import 'package:gupshop/navigators/navigateToBazaarOnBoardingHome.dart';
import 'package:gupshop/widgets/contact_search.dart';
import 'package:gupshop/widgets/customText.dart';

class SubCategories extends StatelessWidget {
  final Future<List<DocumentSnapshot>> subCategoriesListFuture;
  final List<DocumentSnapshot> subCategoriesList;

  SubCategories({this.subCategoriesList, this.subCategoriesListFuture});

  @override
  Widget build(BuildContext context) {
    return ContactSearch(
      //searchSuggestions: suggestions(),
      navigate: NavigateToBazaarOnBoardingHome().navigate(context),
      onSearch: searchList,
      onItemFound: (DocumentSnapshot doc, int index){
        return buildListTile(doc, context);
      },
      //onItemFound: ,
    );
  }

  ListTile buildListTile(DocumentSnapshot doc, BuildContext context) {
    return ListTile(
        title: CustomText(text:  doc.data["name"]),
        ///displaying on the display name
        onTap: () {
        },
      );
  }

  Future<List<DocumentSnapshot>> searchList(String text) async {
    return subCategoriesListFuture;
  }

  suggestions(){
    return subCategoriesList;
  }

}
