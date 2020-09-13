import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarProductDetails/likesDislikesDisplay.dart';
import 'package:gupshop/retriveFromFirebase/retriveLikesDislikesFromBazaarRatingNumbers.dart';

class LikesDislikesFetchAndDisplay extends StatelessWidget {
  final String productWalaNumber;
  final String categoryData;
  final String subCategoryData;

  LikesDislikesFetchAndDisplay({@required this.productWalaNumber, @required this.categoryData, @required this.subCategoryData});


  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        FutureBuilder(
          future: RetriveLikesAndDislikesFromBazaarRatingNumbers().numberOfLikes(productWalaNumber, categoryData, subCategoryData),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print("snapshot.data in LikesDislikesFetchAndDisplay : ${snapshot.data}");
              int likes = snapshot.data;
              if(likes == null) {likes = 0;}
               return LikesDislikesDisplay(likes:likes);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        FutureBuilder(
          future: RetriveLikesAndDislikesFromBazaarRatingNumbers().numberOfDislikes(productWalaNumber, categoryData, subCategoryData),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              int disLikes = snapshot.data;
              if(disLikes == null) {disLikes = 0;}
              return LikesDislikesDisplay(dislikes: disLikes,);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ],
    );
  }
}
