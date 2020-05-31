import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/service/profilePictureAndButtonsScreen.dart';
import 'package:gupshop/widgets/display.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeProfilePicture extends StatefulWidget {
  final double size = 550;

  @override
  _ChangeProfilePictureState createState() => _ChangeProfilePictureState();
}

class _ChangeProfilePictureState extends State<ChangeProfilePicture> {

    String imageURL;
    String userPhoneNo;


    @override
    void initState() {
      getUserPhone();
      super.initState();
    }

    ///This class is a display class for profile picture and buttons.
    ///the profile picture and buttons are made in ProfilePictureAndButtonsScreen.



    /// For snackbar: This context cannot be used directly, as the context there is no context given to the scaffold
    /// The context in the Widget build(Buildcontext context) is the context of that build widget, but not
    /// of the Scaffold, we get error :
    /// - Scaffold.of() called with a context that does not contain a Scaffold.
    /// To avoid, this we wrap the widget Center with Builder, which takes context as its parameter
    /// Update: As we no longer user the snackbar we dont need the  Builder
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: Display().appBar(context),
        backgroundColor: Colors.white,
        body: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: StreamBuilder(
                  stream: Firestore.instance.collection("profilePictures").document(userPhoneNo).snapshots(),
                  builder: (context, snapshot) {

                    if(snapshot.data == null) return CircularProgressIndicator();//to avoid error - "getter do
                    String imageUrl = snapshot.data['url'];

                    return ProfilePictureAndButtonsScreen(userPhoneNo: userPhoneNo, imageUrl: imageUrl, displayPicture: true, applyButtons: true, allowListView: true);
                  }
              ),
        ),
      );
    }












  /*
  When apply button is pressed on change profile page then the image gets stored in firestore storage
  How:
    Use path for making a simple path of the image file
    Create an instance of StorageRefrence and pass the path to it//get the file name
    Use StorageUploadTask putFile  method to on the StorageRefrence instance//put it to firebase
    Use StorageTaskSnapshot on the the StorageUploadTask above//to know then the task is completed
    Then setState()//to display the image
   */
  /*
    But this context cannot be used directly, as the context there is no context given to the scaffold
    The context in the Widget build(Buildcontext context) is the context of that build widget, but not
    of the Scaffold, we get error :
    - Scaffold.of() called with a context that does not contain a Scaffold.
    To avoid, this we wrap the widget Center with Builder, which takes context as its parameter
   */


    Future<void> getUserPhone() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userPhoneNo = prefs.getString('userPhoneNo');
      setState(() {
        this.userPhoneNo = userPhoneNo;
      });
      print("userPhoneNo: $userPhoneNo");
      print("prefs: $prefs");
    }


}