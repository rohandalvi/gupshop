import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/changeBazaarWalasPicturesDisplay.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/retriveFromFirebase/getBazaarWalasBasicProfileInfo.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';

class ChangeBazaarWalasPicturesFetchDataAndDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserDetails().getUserPhoneNoFuture(),
      builder: (BuildContext context, AsyncSnapshot userNumberSnapshot) {
        if (userNumberSnapshot.connectionState == ConnectionState.done) {

          String userNumber = userNumberSnapshot.data;

          return FutureBuilder(
            future: GetBazaarWalasBasicProfileInfo(userNumber: userNumber).getPictureListAndVideo(),
            builder: (BuildContext context, AsyncSnapshot picturesSnapshot) {
              if (picturesSnapshot.connectionState == ConnectionState.done) {
                String thumbnailPicture = picturesSnapshot.data["thumbnailPicture"];
                String otherPictureOne = picturesSnapshot.data["otherPictureOne"];
                String otherPictureTwo = picturesSnapshot.data["otherPictureTwo"];

                if(thumbnailPicture == null) thumbnailPicture =
                "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/pictureFrame.png?alt=media&token=d1167b50-9af6-4670-84aa-93ea4d55a8d3";

                if(otherPictureOne == null) otherPictureOne =
                "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/pictureFrame.png?alt=media&token=d1167b50-9af6-4670-84aa-93ea4d55a8d3";

                if(otherPictureTwo == null) otherPictureTwo =
                "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/pictureFrame.png?alt=media&token=d1167b50-9af6-4670-84aa-93ea4d55a8d3";

                return ChangeBazaarWalasPicturesDisplay(
                  thumbnailPicture: thumbnailPicture,
                  otherPictureOne: otherPictureOne,
                  otherPictureTwo: otherPictureTwo,
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
