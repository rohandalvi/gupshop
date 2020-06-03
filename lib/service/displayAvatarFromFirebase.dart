import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/colorPalette.dart';
import 'package:gupshop/widgets/displayPicture.dart';
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
    print("friendNo in getProfilePicture(): $userPhoneNo");
    DocumentReference isProfilePictureAdded = Firestore.instance.collection("profilePictures").document(userPhoneNo);
    print("isProfilepictureAdded: ${isProfilePictureAdded.snapshots()}");
    return StreamBuilder(
        stream: Firestore.instance.collection("profilePictures").document(userPhoneNo).snapshots(),
        builder: (context, snapshot) {
//                    print("snapshot in getProfilePic: ${snapshot.data['url']}");
          if(snapshot.data == null) return CircularProgressIndicator();//to avoid error - "getter do
          print("imageUrl in sideMenu: ${snapshot.data['url']}");
          imageUrl = snapshot.data['url'];
          return DisplayPicture(
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


  displayAvatarFromFirebase(String userPhoneNo, double radius){
    String imageUrl;
    print("friendNo in getProfilePicture(): $userPhoneNo");
    DocumentReference isProfilePictureAdded = Firestore.instance.collection("profilePictures").document(userPhoneNo);
    print("isProfilepictureAdded: ${isProfilePictureAdded.snapshots()}");
    return StreamBuilder(
        stream: Firestore.instance.collection("profilePictures").document(userPhoneNo).snapshots(),
        builder: (context, snapshot) {
//                    print("snapshot in getProfilePic: ${snapshot.data['url']}");
          if(snapshot.data == null) return CircularProgressIndicator();//to avoid error - "getter do
          //print("imageUrl in sideMenu: ${snapshot.data['url']}");
          imageUrl = snapshot.data['url'];
          print("imageUrl in displayAvatar: $imageUrl");
          return customCircleAvatar(imageUrl, radius);
//            CircleAvatar(
//            backgroundImage: NetworkImage(imageUrl),
//          );


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

  customCircleAvatar(String image, double radius){
    print("imageurl in customCircleAvatar: $image");
    return CircleAvatar(
      radius: radius,
      child: FadeInImage.memoryNetwork(
        image: 'images/transparent.jpeg',
        placeholder: kTransparentImage,
      ),
      backgroundImage: NetworkImage(image),
      foregroundColor: ourBlack,
      backgroundColor: Colors.white,

    );
  }
}