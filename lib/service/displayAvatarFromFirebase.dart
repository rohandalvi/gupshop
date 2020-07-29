import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/image/displayCircularPicture.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:transparent_image/transparent_image.dart';

class DisplayAvatarFromFirebase{


//  displayPicture(String userPhoneNo, double radius) async{
//    var imageUrl = await getImageUrl(userPhoneNo, radius);
//    print("displayPicture imageurl: $imageUrl");
//    return DisplayPicture(
//      height: 370,
//      width: 370,
//      image: NetworkImage(imageUrl),
//    ).smallSizePicture(35);
//  }

//  getImageUrl(String userPhoneNo, double radius) async{
////    String imageUrl;
//    print("friendNo in getProfilePicture(): $userPhoneNo");
//    DocumentReference isProfilePictureAdded = Firestore.instance.collection("profilePictures").document(userPhoneNo);
//    print("isProfilepictureAdded: ${isProfilePictureAdded.snapshots()}");
//    StreamBuilder(
//        stream: Firestore.instance.collection("profilePictures").document(userPhoneNo).snapshots(),
//        builder: (context, snapshot) {
////                    print("snapshot in getProfilePic: ${snapshot.data['url']}");
//    //  if(snapshot.data == null) return CircularProgressIndicator();//to avoid error - "getter do
//    print("imageUrl in sideMenu: ${snapshot.data['url']}");
//    String imageUrl = snapshot.data['url'];
//    //return imageUrl;
//    }
//
////                      Container(
//////                      height:
//////                      MediaQuery.of(context).size.height / 1.25,
//////                      width:
//////                      MediaQuery.of(context).size.width / 1.25,
//////                      child: Image(
//////                        image: Image.network(snapshot.data),
//////                      ),
////                      decoration: new BoxDecoration(
////                        shape: BoxShape.circle,
////                        image: imageUrl==null?  new DecorationImage(
////                          image: AssetImage('images/sampleProfilePicture.jpeg'),
////                          fit: BoxFit.cover,
////                          //new AssetImage('images/sampleProfilePicture.jpeg'),
////                        ):
////                        new DecorationImage(
////                            image: NetworkImage(imageUrl),
////                          fit: BoxFit.cover,
////                            //new AssetImage('images/sampleProfilePicture.jpeg'),
////                        ),
////                      ),
////                    );
//    );
//  }

  getProfilePicture(String userPhoneNo, double radius){
    String imageUrl;
    //print("friendNo in getProfilePicture(): $userPhoneNo");
    DocumentReference isProfilePictureAdded = Firestore.instance.collection("profilePictures").document(userPhoneNo);
    //print("isProfilepictureAdded: ${isProfilePictureAdded.snapshots()}");
    return StreamBuilder(
        stream: Firestore.instance.collection("profilePictures").document(userPhoneNo).snapshots(),
        builder: (context, snapshot) {
//                    print("snapshot in getProfilePic: ${snapshot.data['url']}");
          if(snapshot.data == null) return CircularProgressIndicator();//to avoid error - "getter do
          print("imageUrl in sideMenu: ${snapshot.data['url']}");
          imageUrl = snapshot.data['url'];
          return DisplayCircularPicture(
              height: 370,
              width: 370,
              image: NetworkImage(imageUrl),
            ).smallSizePicture(35);


//                      Container(
////                      height:
////                      MediaQuery.of(context).size.height / 1.25,
////                      width:
////                      MediaQuery.of(context).size.width / 1.25,
////                      child: Image(
////                        image: Image.network(snapshot.data),
////                      ),
//                      decoration: new BoxDecoration(
//                        shape: BoxShape.circle,
//                        image: imageUrl==null?  new DecorationImage(
//                          image: AssetImage('images/sampleProfilePicture.jpeg'),
//                          fit: BoxFit.cover,
//                          //new AssetImage('images/sampleProfilePicture.jpeg'),
//                        ):
//                        new DecorationImage(
//                            image: NetworkImage(imageUrl),
//                          fit: BoxFit.cover,
//                            //new AssetImage('images/sampleProfilePicture.jpeg'),
//                        ),
//                      ),
//                    );
        }
    );
  }


  displayAvatarFromFirebase(String userPhoneNo, double radius, double innerRadius, bool isFirstTime){
    DocumentReference isProfilePictureAdded = Firestore.instance.collection("profilePictures").document(userPhoneNo);
    return StreamBuilder(
        stream: Firestore.instance.collection("profilePictures").document(userPhoneNo).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.data == null) return CircularProgressIndicator();///to avoid error - "getter do
          //print("snapshot in displayAvatarFromFirebase: ${snapshot.data['url']}");

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
//          if(snapshot.data['url'] == null){
//            imageUrl = "images/user.png";
//            isFirstTime = true;
//          } else imageUrl = snapshot.data['url'];

//          String imageUrl = snapshot.data['url'];

          return customCircleAvatar(imageUrl, radius, innerRadius);
        }
    );
  }

  customCircleAvatar(String image, double radius, double innerRadius){
    //print("imageurl in customCircleAvatar: $image");
    return CircleAvatar(
      radius: radius,
      backgroundColor: ourBlack,
      child: CircleAvatar(
        radius: innerRadius,
        //radius - 4,
//        foregroundColor: Colors.black,
//        backgroundColor: Colors.black,
//        child: isFirstTime == false ?
//        FadeInImage.memoryNetwork(
//          image: 'images/user.png',
//          //'images/transparent.jpeg',
//          placeholder: kTransparentImage,
//        ):
//        FadeInImage.assetNetwork(
//          image: 'images/user.png',
//          //'images/transparent.jpeg',
//          placeholder: 'images/whiteBackground.png',
//        )
        backgroundImage:
        //isFirstTime == true ? AssetImage(image):
            NetworkImage(image),
        backgroundColor: Colors.white,
      ),
//      backgroundImage: NetworkImage(image),


    );
  }
}