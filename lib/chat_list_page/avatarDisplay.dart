import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/colors/colorPalette.dart';

class AvatarDisplay extends StatelessWidget {
  String userPhoneNo;
  double radius;
  double innerRadius;
  bool isFirstTime;
  Map<String, ChatListCache> chatListCache;
  String conversationId;
  ChatListCache cache;

  AvatarDisplay({this.userPhoneNo, this.radius, this.innerRadius, this.conversationId, this.cache,
    this.chatListCache, this.isFirstTime,
  });

  String imageUrl;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection("profilePictures").document(userPhoneNo).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.data == null) return avatarPlaceholder(radius, innerRadius);///to avoid error - "getter do
          //String imageUrl;
          try{
            imageUrl = snapshot.data['url'];
          }
          catch (e){
            imageUrl = "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/user.png?alt=media&token=28bcfc15-31da-4847-8f7c-efdd60428714";
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
          print("imageURL in getImage : $imageUrl");
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