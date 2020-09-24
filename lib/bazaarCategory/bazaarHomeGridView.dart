import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/image/gridViewContainer.dart';
import 'package:gupshop/bazaar/customGridView.dart';
import 'package:gupshop/navigators/navigateToSubCategorySearch.dart';
import 'package:gupshop/retriveFromFirebase/bazaarCategoryTypesAndImages.dart';

class BazaarHomeGridView extends StatefulWidget {
  @override
  _BazaarHomeGridViewState createState() => _BazaarHomeGridViewState();
}


class _BazaarHomeGridViewState extends State<BazaarHomeGridView> {
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
              String categoryNameForData = snapshot.data.documents[index].documentID;
              String imageURL = snapshot.data.documents[index].data['icon'];

              return GridViewContainer(
                onPictureTap: () async{
                  Future<List<DocumentSnapshot>> subCategoriesListFuture = BazaarCategoryTypesAndImages().getSubCategories(categoryNameForData);
                  List<DocumentSnapshot> subCategories = await subCategoriesListFuture;
                  subCategoryMap = await BazaarCategoryTypesAndImages().getSubCategoriesMap(categoryNameForData);


                  /// sending to search subCategory page:
                  NavigateToSubCategorySearch(
                    subCategoriesListFuture: subCategoriesListFuture,
                    subCategoriesList: subCategories,
                    subCategoryMap: subCategoryMap,
                    category: catergoryName,
                    categoryData: categoryNameForData
                  ).navigateNoBrackets(context);


//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => BazaarIndividualCategoryListData(
//                          category : catergoryName,
//                          //category: categoryNameForBazaarIndividualCategoryList,
//                        ),//pass Name() here and pass Home()in name_screen
//                      )
//                  );
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

