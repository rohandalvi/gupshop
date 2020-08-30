import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/customGridView.dart';
import 'package:gupshop/image/gridViewContainer.dart';
import 'package:gupshop/navigators/navigateToSubCategories.dart';
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
                  Future<List<DocumentSnapshot>> subCategoriesListFuture = BazaarCategoryTypesAndImages().getSubCategories(categoryNameForData);
                  List<DocumentSnapshot> subCategories = await subCategoriesListFuture;
                  subCategoryMap = await BazaarCategoryTypesAndImages().getSubCategoriesMap(categoryNameForData);

                  NavigateToBazaarSubCategories(
                    subCategoriesList: subCategories,
                    subCategoriesListFuture: subCategoriesListFuture,
                    category: categoryNameForData,
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
}
