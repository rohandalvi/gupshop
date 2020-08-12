import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/image/displayCircularPicture.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:transparent_image/transparent_image.dart';

class DisplayAvatarFromFirebase{

  getProfilePicture(String userPhoneNo, double radius){
    String imageUrl;
    DocumentReference isProfilePictureAdded = Firestore.instance.collection("profilePictures").document(userPhoneNo);
    return StreamBuilder(
        stream: Firestore.instance.collection("profilePictures").document(userPhoneNo).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.data == null) return CircularProgressIndicator();//to avoid error - "getter do
          print("imageUrl in sideMenu: ${snapshot.data['url']}");
          imageUrl = snapshot.data['url'];
          return DisplayCircularPicture(
              height: 370,
              width: 370,
              image: NetworkImage(imageUrl),
            ).smallSizePicture(35);
        }
    );
  }


  displayAvatarFromFirebase(String userPhoneNo, double radius, double innerRadius, bool isFirstTime){
    DocumentReference isProfilePictureAdded = Firestore.instance.collection("profilePictures").document(userPhoneNo);
    return StreamBuilder(
        stream: Firestore.instance.collection("profilePictures").document(userPhoneNo).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.data == null) return avatarPlaceholder(radius, innerRadius);///to avoid error - "getter do

          /// because for the first time user, if he hasnt put any profile picture,
          /// then there wont be any 'url' in firebase.
          /// So, we  would always get a null pointer even if we try to do this:
          ///   if(snapshot.data['url'] == null) {
          ///            imageUrl = 'images/user.png';
          ///            isFirstTime = true;
          ///          }else imageUrl = snapshot.data['url'];
          ///
          /// So we use a try catch insted
          String imageUrl;
          try{
            imageUrl = snapshot.data['url'];
          }
          catch (e){
            print("in catch");
            imageUrl = 'images/user.png';
            isFirstTime = true;
          }
          return customCircleAvatar(imageUrl, radius, innerRadius);
        }
    );
  }

  customCircleAvatar(String image, double radius, double innerRadius){
    return CircleAvatar(
      radius: radius,
      backgroundColor: ourBlack,
      child: CircleAvatar(
        radius: innerRadius,
        backgroundImage: NetworkImage(image),
        backgroundColor: Colors.white,
      ),
    );
  }

  avatarPlaceholder(double radius, double innerRadius){
    return CircleAvatar(
      radius: radius,
      backgroundColor: ourBlack,
      child: CircleAvatar(
        radius: innerRadius,
        backgroundImage: AssetImage('images/user.png'),
        backgroundColor: Colors.white,
      ),
    );
  }
}