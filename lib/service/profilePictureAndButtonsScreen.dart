import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/models/chat_List.dart';
import 'package:gupshop/screens/home.dart';
import 'package:gupshop/service/imagePickersDisplayPicturesFromURLorFile.dart';
import 'package:gupshop/widgets/customSnackBar.dart';
import 'package:gupshop/widgets/raisedButton.dart';
import 'dart:io';
import 'package:get/get.dart';

import 'package:gupshop/widgets/sideMenu.dart';

class ProfilePictureAndButtonsScreen extends StatefulWidget {
  String userPhoneNo;
  String imageUrl;
  bool displayPicture;
  bool applyButtons;
  bool allowListView;

  ProfilePictureAndButtonsScreen({this.userPhoneNo, this.imageUrl,   this.displayPicture, this.applyButtons, this.allowListView});

  @override
  _ProfilePictureAndButtonsScreenState createState() => _ProfilePictureAndButtonsScreenState(userPhoneNo: userPhoneNo, imageUrl: imageUrl, showPicture: displayPicture,  applyButtons: applyButtons, allowListView: allowListView);
}

class _ProfilePictureAndButtonsScreenState extends State<ProfilePictureAndButtonsScreen> {
  String userPhoneNo;
  String imageUrl;
  bool showPicture;
  bool applyButtons;
  bool allowListView;

  bool isClicked = false;

  _ProfilePictureAndButtonsScreenState({this.userPhoneNo, this.imageUrl,this.showPicture,this.applyButtons, this.allowListView});



  @override
  Widget build(BuildContext context) {

    if(showPicture  && applyButtons) {
      List<Widget> children = [
        Container(
          //padding: EdgeInsets.all((widget.size - 50) / 2.0),//make child as cirularprogressindicator
//          child : GestureDetector(
//            child: displayPicture(imageUrl, _galleryImage, _cameraImage),
//            onTap: (){
////              snackBar(context, _galleryImage, _cameraImage);
//            },
//          ),

        ),
//        Spacer(
//          flex: 4,
//        ),


        snackBar(context, _galleryImage, _cameraImage),

        //galleryApplyCameraButtons(context),
      ];
      if(allowListView) {
        return displayPic(context, _galleryImage, _cameraImage);
//        return Column(/// listview substituted for Column as Column was giving renderflex overflow error
//          children: children,
//        );
      }
      else {
        return  Column(
          children: children,
        );
      }
    }
    else if(showPicture) {
      //return displayPicture(imageUrl, _galleryImage, _cameraImage, );
    } else return galleryApplyCameraButtons(context, _galleryImage, _cameraImage );

  }

  displayPic(BuildContext context, File _galleryImage, File _cameraImage){
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Container(
              //padding: EdgeInsets.only(top: 10),//make child as cirularprogressindicator
              child : GestureDetector(
                  child: displayPicture(imageUrl, _galleryImage, _cameraImage),
                  onTap: (){
                    if(isClicked == false){
                      isClicked = true;
                      print("in tap");
                      print("in snackbarbutton method");
                      return Flushbar(
                        padding : EdgeInsets.all(10),
                        borderRadius: 8,
                        backgroundColor: Colors.white,
//                backgroundGradient: LinearGradient(
//                  colors: [Colors.white],
//                ),
//            boxShadows: [
//              BoxShadow(
//                color: Colors.white,
//                //offset: Offset(3, 3),
//                //blurRadius: 3,
//              ),
//            ],

                        dismissDirection: FlushbarDismissDirection.HORIZONTAL,

                        forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
                        titleText: galleryApplyCameraButtons(context, _galleryImage, _cameraImage),
                        message: 'Change',


                      )..show(context);
                    } return Container();
                  },
                )

              );
          }
        );
  }

  displayPicture(String imageUrl, File _galleryImage, File _cameraImage){
    if(imageUrl!=null && _galleryImage == null && _cameraImage == null)
      return ImagesPickersDisplayPictureURLorFile().displayPictureFromURL(imageUrl);
    if(_galleryImage != null){
//      CreateRaisedButton(
//        onPressed: (){},
//        child: Text('Change'),
//      );
      //return ImagesPickersDisplayPictureURLorFile().displayPictureFromFile(_galleryImage);
      return showPictureAndChangeButton(_galleryImage);
    }

    else if(_cameraImage != null)
      return showPictureAndChangeButton(_cameraImage);
  }

  showPictureAndChangeButton(File image){
    return ListView(
      children: <Widget>[
        ImagesPickersDisplayPictureURLorFile().displayPictureFromFile(image),
        CreateRaisedButton(
          onPressed: (){
            ImagesPickersDisplayPictureURLorFile().uploadImageToFirestore(context, userPhoneNo, image);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(userName: "Purva Dalvi",userPhoneNo: userPhoneNo,),//pass Name() here and pass Home()in name_screen
                )
            );
//            Navigator.pop(context);
            //Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
//            Get.back();
          },
          child: IconButton(
            icon: SvgPicture.asset('images/done.svg',),
          ),
        ),
      ],
    );
  }


  Widget galleryApplyCameraButtons(BuildContext context, File _galleryImage, File _cameraImage ){
    print("in galleryApplyCameraButtons");
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: SvgPicture.asset('images/photoGallery.svg',),
              onPressed: () {

//                File tempImage = await ImagesPickersDisplayPictureURLorFile().pickImageFromGallery();
//                print("tempImage outside setstate: $tempImage");
//
//                setState((){
//                  _galleryImage= tempImage;
//                  print("tempimage = $tempImage");
//                  if(tempImage != null){
//                    _cameraImage =  null;
//                    print("cameraImage: $_cameraImage");
//                  }
//                });

                _pickImageFromGallery(setState);
              },
            ),
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
            IconButton(
              icon: SvgPicture.asset('images/image2vector.svg',),
              onPressed: (){
                _pickImageFromCamer(setState);
              },
            ),
          ],
        );
  }

  File _galleryImage ;
  /// This funcion will helps you to pick and Image from Gallery
  _pickImageFromGallery(StateSetter setState) async{
    File tempImage = await ImagesPickersDisplayPictureURLorFile().pickImageFromGallery();
    print("tempImage outside setstate: $tempImage");

    setState((){
      if(tempImage != null){
        _galleryImage= tempImage;
      }
      print("tempimage = $tempImage");
//      if(tempImage != null){
//        _cameraImage =  null;
//        print("cameraImage: $_cameraImage");
//      }
    });
  }





  snackBar(BuildContext context,File _galleryImage, File _cameraImage ){
    print("in snackbar");
    print("rohan");
    return CustomSnackBar(context: context, buttons: galleryApplyCameraButtons(context, _galleryImage, _cameraImage),);

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
//  File _galleryImage ;
//  /// This funcion will helps you to pick and Image from Gallery
//  _pickImageFromGallery() async{
//    File tempImage = await ImagesPickersDisplayPictureURLorFile().pickImageFromGallery();
//    print("tempImage outside setstate: $tempImage");
//
//    setState((){
//      _galleryImage= tempImage;
//      print("tempimage = $tempImage");
//      if(tempImage != null){
//        _cameraImage =  null;
//        print("cameraImage: $_cameraImage");
//      }
//    });
//  }


  File _cameraImage;
  /// This funcion will helps you to pick and Image from Camera
  _pickImageFromCamer(StateSetter setState) async{
    File tempImage = await ImagesPickersDisplayPictureURLorFile().pickImageFromCamer();

    setState(() {
      if(tempImage != null){
        _cameraImage= tempImage;
      }
      print("tempimage = $tempImage");
//      if(tempImage != null){
//        _galleryImage = null;
//        print("galleryImage: $_galleryImage");
//      }
    });
  }

}
