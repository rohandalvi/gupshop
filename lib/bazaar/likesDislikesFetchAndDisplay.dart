import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/likesDislikesDisplay.dart';
import 'package:gupshop/retriveFromFirebase/retriveLikesDislikesFromBazaarRatingNumbers.dart';

class LikesDislikesFetchAndDisplay extends StatelessWidget {
  final String productWalaNumber;
  final String category;
  final String subCategory;

  LikesDislikesFetchAndDisplay({@required this.productWalaNumber, @required this.category, @required this.subCategory});


  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        FutureBuilder(
          future: RetriveLikesAndDislikesFromBazaarRatingNumbers().numberOfLikes(productWalaNumber, category, subCategory),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
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
          future: RetriveLikesAndDislikesFromBazaarRatingNumbers().numberOfDislikes(productWalaNumber, category, subCategory),
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
