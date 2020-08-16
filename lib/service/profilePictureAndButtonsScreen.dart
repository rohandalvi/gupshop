import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/image/cropImage.dart';
import 'package:gupshop/image/pickImageFromCamera.dart';
import 'package:gupshop/image/pickImageFromGallery.dart';
import 'package:gupshop/screens/home.dart';
import 'package:gupshop/widgets/customNavigators.dart';
import 'package:gupshop/image/imagePickersDisplayPicturesFromURLorFile.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';

import 'custoImageCropper.dart';


class ProfilePictureAndButtonsScreen extends StatefulWidget {
  String userName;
  String userPhoneNo;
  String imageUrl;
  double height;
  double width;
  bool viewingFriendsProfile;
  String groupConversationId;
  Map<String, ChatListCache> chatListCache;
  String conversationId;
  //bool displayPicture;
  //bool applyButtons;
  //bool allowListView;

  ProfilePictureAndButtonsScreen({this.userPhoneNo, this.imageUrl, this.height, this.width, this.userName,
    this.viewingFriendsProfile, this.groupConversationId, this.chatListCache, this.conversationId});

  @override
  _ProfilePictureAndButtonsScreenState createState() => _ProfilePictureAndButtonsScreenState(userPhoneNo: userPhoneNo, imageUrl: imageUrl, height: height, width:width, userName: userName, viewingFriendsProfile: viewingFriendsProfile, groupConversationId: groupConversationId);
}

class _ProfilePictureAndButtonsScreenState extends State<ProfilePictureAndButtonsScreen> {
  String userName;
  String userPhoneNo;
  String imageUrl;
  double height;
  double width;
  bool viewingFriendsProfile;
  String groupConversationId;
//  bool showPicture;
//  bool applyButtons;
//  bool allowListView;

  bool isClicked = false;

  File _galleryImage ;
  File _cameraImage;
  bool profilePictureChanged;

  _ProfilePictureAndButtonsScreenState({this.userPhoneNo, this.imageUrl, this.height, this.width,
    this.userName, this.viewingFriendsProfile, this.groupConversationId,});



  @override
  Widget build(BuildContext context) {
        return dpAndOptions();
          //pictureAndFlushbar(context, _galleryImage, _cameraImage);
  }

  dpAndOptions(){
    return Scaffold(
      body: displayPicture(imageUrl, _galleryImage, _cameraImage, height, width, context),
      bottomSheet: Visibility(
          visible: viewingFriendsProfile == false,
          child: galleryApplyCameraButtons(context, _galleryImage, _cameraImage)
      ),
    );
  }

  ///uses displayPicture and galleryApplyCameraButtons methods
  ///when the user taps the picture then only the galleryApplyCameraButtons get displayed
//  pictureAndFlushbar(BuildContext context, File _galleryImage, File _cameraImage){
//            return Container(
//              //padding: EdgeInsets.only(top: 10),//make child as cirularprogressindicator
//              child : GestureDetector(
//                  child: displayPicture(imageUrl, _galleryImage, _cameraImage, height, width, context),
//
//                  onTap: (){
//                    if(isClicked == false && viewingFriendsProfile == false){
//                      isClicked = true;
//                      return Flushbar(
//                        padding : EdgeInsets.all(10),
//                        borderRadius: 8,
//                        backgroundColor: Colors.white,
//
//                        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
//
//                        forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
//                        titleText: galleryApplyCameraButtons(context, _galleryImage, _cameraImage),
//                        message: 'Change',
//
//                      )..show(context);
//                    } return Container();
//                  },
//                )
//
//              );
//  }


  ///when the image gets displayed in the changeProfilePage then that would be the image
  ///as set by the user previously(in nameScreen or later). It would be in imageURL. It
  ///would be passed on by the database using streambuilder from the changeProfilePage.
  ///So, if if the user hasnt selected any image from gallery or camera, show that image
  ///
  /// else show the image selected by him.
  /// if(_galleryImage != null) ==>
  /// it would be null in 2 situations:
  ///   1. the user has not tapped the gallery icon at all
  ///   2. the user has tapped the gallery icon but came out of it without selecting any
  ///       image
  /// same logic applies to camera
  ///
  /// So only when the user has selected the gallery image or the camera image, the only
  /// that image gets displayed
  displayPicture(String imageUrl, File _galleryImage, File _cameraImage, double height, double width, BuildContext context){
    if(imageUrl!=null && _galleryImage == null && _cameraImage == null) return ImagesPickersDisplayPictureURLorFile().displayPictureFromURL(imageUrl, height, width);
    if(_galleryImage != null) return showPictureAndChangeButton(_galleryImage, height, width, context);
    else if(_cameraImage != null)
      return showPictureAndChangeButton(_cameraImage,  height, width, context);
  }


  ///show the tick button only when either one of the image, galley or camera is
  ///selected by the user
  ///
  /// How- when the user selects the image, then it would be a File image only because
  /// he would be selecting from camera or gallery and the imagePicker method gives back
  /// a File.
  /// So that file would be passed to imagePicker method and it would be displayed along
  /// with the tick button
  /// Any image selected will show a tick button, as long as an image is selected
  showPictureAndChangeButton(File image, double height, double width, BuildContext context){
    return ImagesPickersDisplayPictureURLorFile().displayPictureFromFile(image, height, width);
  }


  Widget galleryApplyCameraButtons(BuildContext context, File _galleryImage, File _cameraImage ){
    print("in galleryApplyCameraButtons");
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: SvgPicture.asset('images/photoGallery.svg',),
              onPressed: () async{
                File tempImage = await _pickImageFromGallery(setState);
                if(userName != null && tempImage != null){
//                if(userName != null){
                  if(groupConversationId != null){
                    await ImagesPickersDisplayPictureURLorFile().uploadImageToFirestore(context, groupConversationId, tempImage);
                  }
                  else{
                    await ImagesPickersDisplayPictureURLorFile().uploadImageToFirestore(context, userPhoneNo, tempImage);
                    CustomNavigator().navigateToHome(context, userName, userPhoneNo);
                  }

                  widget.chatListCache.remove(widget.conversationId);
                  profilePictureChanged = true;

                }
              },
            ),

            IconButton(
              icon: SvgPicture.asset('images/image2vector.svg',),
              onPressed: () async{
                File tempImage = await _pickImageFromCamer(setState);
                if(userName != null && tempImage != null){
                //if(userName != null){
                  if(groupConversationId != null){
                    await ImagesPickersDisplayPictureURLorFile().uploadImageToFirestore(context, groupConversationId, tempImage);
                  }
                  else{
                    await ImagesPickersDisplayPictureURLorFile().uploadImageToFirestore(context, userPhoneNo, tempImage);
                    print("in onPressed of showPictureAndChangeButton: $userName");
                    CustomNavigator().navigateToHome(context, userName, userPhoneNo);
                  }
                  widget.chatListCache.remove(widget.conversationId);
                  profilePictureChanged = true;
                }
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

  /// This funcion will helps you to pick and Image from Gallery
  ///
  /// if(tempImage != null){
  ///        _cameraImage= tempImage;
  ///      }
  /// if the user goes to the camera/gallery and doesnt pick any image then the varibale
  /// File tempImage would be null.
  _pickImageFromGallery(StateSetter setState) async{
    File tempImage = await PickImageFromGallery().pick();

    File croppedImage = await CropImage().crop(tempImage);

    setState((){
      if(tempImage != null){
        _galleryImage= croppedImage;
      }
    });

    return _galleryImage;
  }


  /// This funcion will helps you to pick and Image from Camera
  _pickImageFromCamer(StateSetter setState) async{
    File tempImage = await PickImageFromCamera().pick();

    File croppedImage = await CropImage().crop(tempImage);

    setState(() {
      if(tempImage != null){
        _cameraImage= croppedImage;
      }
    });

    return _cameraImage;
  }
}



///this was the code written to show apply button when flushbar was not used
//            if(!(_galleryImage == null && _cameraImage == null))///show the apply button only when a new image is selected, else no need
//              CreateRaisedButton(
//                  child: Text('Apply',style: GoogleFonts.openSans(
//                    color: Theme.of(context).primaryColor,
//                    fontSize: 15,
//                    fontWeight: FontWeight.bold,
//                  )),
//                  onPressed: (){
//                    File image;
//                    if(_galleryImage == null) {
//                      print("_galleryImage");
//                      image = _cameraImage;
//                    }
//                    else{
//                      print("_cameraImage");
//                      image = _galleryImage;
//                    }
//                    ImagesPickersDisplayPictureURLorFile().uploadImageToFirestore(context, userPhoneNo, image);
//                    Navigator.pop(context);///go back to sidemenu button on pressing apply button
//                  }
//              ),