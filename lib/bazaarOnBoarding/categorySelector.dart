import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/customGridView.dart';
import 'package:gupshop/image/gridViewContainer.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToBazaarAdvertisement.dart';
import 'package:gupshop/navigators/navigateToBazaarOnBoardingProfile.dart';
import 'package:gupshop/navigators/navigateToSubCategoriesCheckBoxData.dart';
import 'package:gupshop/retriveFromFirebase/bazaarCategoryTypesAndImages.dart';

class CategorySelector extends StatelessWidget {

  Map<String, String> subCategoryMap = new HashMap();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: BazaarCategoryTypesAndImages().getStream(),
        builder: (context, snapshot) {
          if(snapshot.data == null) return CircularProgressIndicator();//for avoding  the error

          int categoryLength = snapshot.data.documents.length;//for using in
          return CustomGridView(
            itemCount: categoryLength,
            itemBuilder: (BuildContext context, int index){
              String catergoryName = snapshot.data.documents[index].data['name'];
              String imageURL = snapshot.data.documents[index].data['icon'];
              String categoryNameForData = snapshot.data.documents[index].documentID;


              return GridViewContainer(
                /// on tapping the image/category show subcategories with checkbox
                onPictureTap: () async{
                  String userNumber = await UserDetails().getUserPhoneNoFuture();
                  String userName = await UserDetails().getUserNameFuture();

                  Future<List<DocumentSnapshot>> subCategoriesListFuture = BazaarCategoryTypesAndImages().getSubCategories(categoryNameForData);
                  List<DocumentSnapshot> subCategories = await subCategoriesListFuture;
                  subCategoryMap = await BazaarCategoryTypesAndImages().getSubCategoriesMap(categoryNameForData);

                  NavigateToBazaarSubCategoriesCheckBoxData(
                    subCategoriesList: subCategories,
                    subCategoriesListFuture: subCategoriesListFuture,
                    category: catergoryName,
                    categoryData: categoryNameForData,
                    subCategoryMap: subCategoryMap,
                  ).navigateNoBrackets(context);
                },
                imageName: catergoryName,
                imageURL: imageURL,
              );
            },
          );
        }
    );
  }

  navigateIfDeliveryErrands(BuildContext context, String catergoryName,
      String categoryNameForData, String userNumber, String userName
      ){

    List<String> listOfSubCategories = new List();
    listOfSubCategories.add("Delivery/Errands");

    List<String> listOfSubCategoriesForData = new List();
    listOfSubCategoriesForData.add("deliveryErrands");

    Map<String, String> subCategoryMap = new HashMap();

    subCategoryMap[listOfSubCategories[0]] = listOfSubCategoriesForData[0];

    NavigateToBazaarOnBoardingProfile(
      category:catergoryName,
      categoryData: categoryNameForData,
      listOfSubCategories: listOfSubCategories,
      userPhoneNo: userNumber,
      userName: userName,
      subCategoryMap: subCategoryMap,
      listOfSubCategoriesForData: listOfSubCategoriesForData,
    ).navigateNoBrackets(context);
  }
}
