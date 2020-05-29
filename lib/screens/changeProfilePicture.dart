import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/widgets/buttons.dart';
import 'package:gupshop/widgets/display.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
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


    File _galleryImage ;
    // This funcion will helps you to pick and Image from Gallery
    _pickImageFromGallery() async{
      File image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);

        setState((){
        _galleryImage= image;
      });
    }


    File _cameraImage;
    // This funcion will helps you to pick and Image from Camera
    _pickImageFromCamer() async{
      File image = await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 50);

        setState(() {
          _cameraImage= image;
        });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: Display().appBar(context),
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.fromLTRB(15, 150, 0, 0),
          /*
          But this context cannot be used directly, as the context there is no context given to the scaffold
          The context in the Widget build(Buildcontext context) is the context of that build widget, but not
          of the Scaffold, we get error :
          - Scaffold.of() called with a context that does not contain a Scaffold.
          To avoid, this we wrap the widget Center with Builder, which takes context as its parameter
          */
          child: Builder(
            builder:(context)=> Center(
              child: StreamBuilder(
                stream: Firestore.instance.collection("profilePictures").document(userPhoneNo).snapshots(),
                builder: (context, snapshot) {

                  if(snapshot.data == null) return CircularProgressIndicator();//to avoid error - "getter do
                  String imageUrl = snapshot.data['url'];
                  print("imageUrl in changeProfilePage: $imageUrl");
                  return ListView(
                    children: <Widget>[
                      if(imageUrl!=null && _galleryImage == null && _cameraImage == null)
                        Container(
                          padding: EdgeInsets.only(right: 12),
                          height: 400,
                          width: 400,
                          child: Image(image: NetworkImage(imageUrl),
                          //fit: BoxFit.fill,
                      ),
                        ),
                      if(_galleryImage != null)
                        Container(
                            padding: EdgeInsets.only(right: 12),
                            height: 400,
                            width: 400,
                            child: Image.file(_galleryImage,
                              //fit:BoxFit.fill,
                            )
                        )
                      else if(_cameraImage != null) Container(
                          padding: EdgeInsets.only(right: 12),
                          height: 400,
                          width: 400,
                          child: Image.file(_cameraImage,
                            //fit: BoxFit.fill,
                          )
                      ),
//                      if(imageUrl!=null && _galleryImage == null && _cameraImage == null) Image(image: NetworkImage(imageUrl),),
//                      if(_galleryImage != null)
//                        Image.file(_galleryImage)
//                      else if(_cameraImage != null) Image.file(_cameraImage),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.photo_library),
                          onPressed: (){
                            _pickImageFromGallery();
                          },
                        ),
                        if(!(_galleryImage == null && _cameraImage == null))//show the apply button only when a new image is selected, else no need
                          //Buttons().raisedButtonMaker(context, uploadImageToFirestore(context)),
                        RaisedButton(
                          onPressed: (){
//                            if(_galleryImage != null) image = basename(_galleryImage.path);
//                            if(_cameraImage != null) image = basename(_cameraImage.path);
                              uploadImageToFirestore(context);
                          },
                          color: Colors.transparent,
                          splashColor: Colors.transparent,
                          //highlightColor: Colors.blueGrey,
                          elevation: 0,
                          hoverColor: Colors.blueGrey,
                          child: Text('Apply',style: GoogleFonts.openSans(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                        ),
                        IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: (){
                            _pickImageFromCamer();
                          },
                        ),
                      ],
                    ),

                    ],
                  );
                }
              ),
            ),
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

  Future uploadImageToFirestore(BuildContext context) async{//functionality for cameraImage is not added, thats a to do
    String fileName = basename(userPhoneNo+'ProfilePicture');
    //String fileName = basename(_galleryImage.path);
    StorageReference firebaseStorageReference= FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageReference.putFile(_galleryImage);
    StorageTaskSnapshot imageURLFuture = await uploadTask.onComplete;
    imageURL = await imageURLFuture.ref.getDownloadURL();
    print("imageurl: $imageURL");
    Firestore.instance.collection("profilePictures").document(userPhoneNo).setData({'url':imageURL});

    setState(() {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture uploaded'),));
    });
    }


}