import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/service/imagePickersDisplayPicturesFromURLorFile.dart';
import 'package:gupshop/widgets/raisedButton.dart';
import 'dart:io';

class ProfilePictureScreen extends StatefulWidget {
  String userPhoneNo;
  String imageUrl;
  bool displayPicture;
  bool applyButtons;
  bool allowListView;

  ProfilePictureScreen({this.userPhoneNo, this.imageUrl,   this.displayPicture, this.applyButtons, this.allowListView});

  @override
  _ProfilePictureScreenState createState() => _ProfilePictureScreenState(userPhoneNo: userPhoneNo, imageUrl: imageUrl, showPicture: displayPicture,  applyButtons: applyButtons, allowListView: allowListView);
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  String userPhoneNo;
  String imageUrl;
  bool showPicture;
  bool applyButtons;
  bool allowListView;


  _ProfilePictureScreenState({this.userPhoneNo, this.imageUrl,this.showPicture,this.applyButtons, this.allowListView});



  @override
  Widget build(BuildContext context) {

    if(showPicture  && applyButtons) {
      List<Widget> children = [
        Container(
          //padding: EdgeInsets.all((widget.size - 50) / 2.0),
          child : displayPicture(imageUrl, _galleryImage, _cameraImage),
        ),

        galleryApplyCameraButtons(context),
      ];
      if(allowListView) {
        return Column(/// listview substituted for Column as Column was giving renderflex overflow error
          children: children,
        );
      } else {
        return  Column(
          children: children,
        );
      }
    }
    else if(showPicture) {
      return displayPicture(imageUrl, _galleryImage, _cameraImage);
    } else return galleryApplyCameraButtons(context);

  }


  displayPicture(String imageUrl, File _galleryImage, File _cameraImage){
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
          icon: Icon(Icons.image),
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
          icon: SvgPicture.asset('images/camera1.svg',),
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

}
