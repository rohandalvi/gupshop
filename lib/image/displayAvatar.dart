import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/image/displayCircularPicture.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:transparent_image/transparent_image.dart';

class DisplayAvatar{
  String imageUrl;

  DisplayAvatar({this.imageUrl});

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

          try{
            imageUrl = snapshot.data['url'];
          }
          catch (e){
            print("in catch");
            imageUrl = "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/user.png?alt=media&token=28bcfc15-31da-4847-8f7c-efdd60428714";
            //imageUrl = 'images/user.png';
            isFirstTime = true;
          }

          print("imageURL in displayAvatar : $imageUrl");
          return customCircleAvatar(imageUrl, radius, innerRadius);
        }
    );
  }

  displayAvatarFromProfilePictures(String userPhoneNo, double radius, double innerRadius,
      bool isFirstTime, Map<String, ChatListCache> chatListCache, String conversationId,
      ChatListCache cache){
    print("avatar cache in displayAvatar : $chatListCache");
    DocumentReference isProfilePictureAdded = Firestore.instance.collection("profilePictures").document(userPhoneNo);
    return StreamBuilder(
        stream: Firestore.instance.collection("profilePictures").document(userPhoneNo).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.data == null) return avatarPlaceholder(radius, innerRadius);///to avoid error - "getter do
          //String imageUrl;
          try{
            imageUrl = snapshot.data['url'];
          }
          catch (e){
            print("in catch");
            imageUrl = "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/user.png?alt=media&token=28bcfc15-31da-4847-8f7c-efdd60428714";
            //imageUrl = 'images/user.png';
            isFirstTime = true;
          }
          CircleAvatar avatar=  customCircleAvatar(imageUrl, radius, innerRadius);

          /// this streambuilder will be called only in two cases:
          /// 1. first time to populate the cache
          /// 2. when the streambuilder listens any change(this will occur when
          /// a user has changed his profile picture)
          ///
          /// so, if it is case 1 , add the avatar to cache.
          /// if it is case 2, remove the old avatar, so a new call to
          /// streambuilder will be made the next time the page is called
          if(chatListCache.containsKey(conversationId)){
            chatListCache.remove(conversationId);
          }else {
            cache.circleAvatar = avatar;
            chatListCache[conversationId] = cache;
          }
          return avatar;
        }
    );
  }

  CircleAvatar customCircleAvatar(String image, double radius, double innerRadius){
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