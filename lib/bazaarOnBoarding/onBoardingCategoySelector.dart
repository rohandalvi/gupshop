import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/customGridView.dart';
import 'package:gupshop/image/gridViewContainer.dart';

class OnBoardingCategorySelector extends StatelessWidget {

  //OnBoardingCategorySelector({});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("bazaarCategoryTypesAndImages").snapshots(),
        builder: (context, snapshot) {
          if(snapshot.data == null) return CircularProgressIndicator();//for avoding  the error

          int categoryLength = snapshot.data.documents.length;//for using in
          return CustomGridView(
            itemCount: categoryLength,
            itemBuilder: (BuildContext context, int index){
              String catergoryName = snapshot.data.documents[index].data['name'];
              String categoryNameForBazaarIndividualCategoryList = snapshot.data.documents[index].documentID;
              String imageURL = snapshot.data.documents[index].data['icon'];

              return GridViewContainer(
                onPictureTap: (){
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
