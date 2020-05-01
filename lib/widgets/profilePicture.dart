import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePicture {


  String userPhoneNo;

  getUserPhoneNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userPhoneNo = prefs.getString('userPhoneNo');

    print("userPhoneNo in Profile Picture: $userPhoneNo");
    print("prefs: $prefs");
  }



  getUserProfilePicture(){
    getUserPhoneNo();
    print("are we getting data: ${Firestore.instance.collection("profilePictures").document(userPhoneNo)}");
    return StreamBuilder(
        stream: Firestore.instance.collection("profilePictures").document(userPhoneNo).snapshots(),
        builder: (context, snapshot) {
          //if(snapshot.data == null) return CircularProgressIndicator();//to avoid error - "getter do
          print("imageUrl in sideMenu: ${snapshot.data['url']}");
          String imageUrl = snapshot.data['url'];
          return Container(
//                      height:
//                      MediaQuery.of(context).size.height / 1.25,
//                      width:
//                      MediaQuery.of(context).size.width / 1.25,
//                      child: Image(
//                        image: Image.network(snapshot.data),
//                      ),
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  image: NetworkImage(imageUrl),
                  //new AssetImage('images/sampleProfilePicture.jpeg'),
                )
            ),
          );
        }
    );
  }

}