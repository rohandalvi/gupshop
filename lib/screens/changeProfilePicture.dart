import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/service/pictureUploader.dart';
import 'package:gupshop/widgets/raisedButton.dart';
import 'package:gupshop/widgets/display.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeProfilePicture extends StatefulWidget {
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
          child: Builder(
            builder:(context)=> Center(
              child: StreamBuilder(
                  stream: Firestore.instance.collection("profilePictures").document(userPhoneNo).snapshots(),
                  builder: (context, snapshot) {

                    if(snapshot.data == null) return CircularProgressIndicator();//to avoid error - "getter do
                    String imageUrl = snapshot.data['url'];

                    return ListView(/// listview substituted for Column as Column was giving renderflex overflow error
                      children: <Widget>[
                        displayPicture(imageUrl),
                        galleryApplyCameraButtons(context),
                      ],
                    );
                  }
              ),
            ),
          ),
        ),
      );
    }

    displayPicture(String imageUrl){
      if(imageUrl!=null && _galleryImage == null && _cameraImage == null)
        return PictureUploaderState().displayPictureFromURL(imageUrl);
      if(_galleryImage != null)
        return PictureUploaderState().displayPictureFromFile(_galleryImage);
      else if(_cameraImage != null)
        return PictureUploaderState().displayPictureFromFile(_cameraImage);
    }



    Widget galleryApplyCameraButtons(BuildContext context){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: () {
              _pickImageFromGallery();
            },
          ),
          if(!(_galleryImage == null && _cameraImage == null))///show the apply button only when a new image is selected, else no need
            CreateRaisedButton(
              child: Text('Apply',style: GoogleFonts.openSans(
                  color: Theme.of(context).primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  )),
                onPressed: (){
                  File image;
                  if(_galleryImage == null) {
                    image = _cameraImage;
                  }
                  else{
                    image = _galleryImage;
                  }
                  PictureUploaderState().uploadImageToFirestore(context, userPhoneNo, image);
                  Navigator.pop(context);///go back to sidemenu button on pressing apply button
                }
            ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: (){
              _pickImageFromCamer();
            },
          ),
        ],
      );
    }




    /// Comment block for :
    ///    _pickImageFromGallery()
    ///    _pickImageFromCamer()
    ///
    ///    if the user selects gallery image and then goes to select the
    ///   camera image then it shows up but it does not get actually pushed to firebase
    ///   because in galleryApplyCameraButtons() in CreateRaisedButton we are checking if
    ///   _galleryImage is null then that means the user has not selected the gallery
    ///   image and so display the image picked up by camera.
    ///   But if the user picks up the image from gallery first(_gallery != null now)
    ///   then again goes to camera and clicks an image(_camera != null) but now _gallery is
    ///   also not equal to null which means the display will still show gallery image even
    ///   though the user has selected the camera image. So, we need to tell the UI that the user
    ///    has selected the camera image. Now here, selecting the camera image is important,if
    ///   the user just goes into camera and comes back then the _cameraImage should stay stull.
    ///   For this we are checking:
    ///   if(tempImage != null){
    ///   _galleryImage =  null;
    ///   }
    ///   meaning, if the the camera has picked up the image, then only make the gallery image
    ///    null and then the display will show the freshly clicked image by the user.
    File _galleryImage ;
    /// This funcion will helps you to pick and Image from Gallery
    _pickImageFromGallery() async{
      File tempImage = await PictureUploaderState().pickImageFromGallery();

        setState((){
        _galleryImage= tempImage;
        if(tempImage != null){
          _cameraImage =  null;
        }
      });
    }


    File _cameraImage;
    /// This funcion will helps you to pick and Image from Camera
    _pickImageFromCamer() async{
      File tempImage = await PictureUploaderState().pickImageFromCamer();

        setState(() {
          _cameraImage= tempImage;
          if(tempImage != null){
            _galleryImage = null;
          }
        });
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