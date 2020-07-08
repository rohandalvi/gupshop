//import 'dart:html';
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/screens/productDetail.dart';
import 'package:gupshop/service/checkBoxCategorySelector.dart';
import 'package:gupshop/service/geolocation_service.dart';
import 'package:gupshop/service/imagePickersDisplayPicturesFromURLorFile.dart';
import 'package:gupshop/service/videoPicker.dart';
import 'package:gupshop/widgets/colorPalette.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart';

// bazaarHomeScreen=>
// =>CheckBoxCategorySelector
class BazaarProfilePage extends StatefulWidget {
  final String userPhoneNo;
  final String userName;

  BazaarProfilePage({@required this.userPhoneNo, @required this.userName});

  @override
  _BazaarProfilePageState createState() => _BazaarProfilePageState(userName: userName, userPhoneNo: userPhoneNo);
}

class _BazaarProfilePageState extends State<BazaarProfilePage> {
  final String userPhoneNo;
  final String userName;

  _BazaarProfilePageState({@required this.userPhoneNo, @required this.userName});

  Position _bazaarWalaLocation;

  /// for _pickVideoFromGallery
  File video;
  String videoURL;


  List<bool> inputs = new List<bool>();
  int categorySize;

  bool isSelected = false;

  double latitude;
  double longitude;
  bool saveButtonVisible = false;


  File _cameraVideo;
  VideoPlayerController _cameraVideoPlayerController;


  getCategorySizeFuture() async{
    QuerySnapshot querySnapshot = await Firestore.instance.collection("bazaarCategoryTypesAndImages").getDocuments();

    if(querySnapshot == null) return CircularProgressIndicator();//to avoid red screen(error)

    int size = querySnapshot.documents.length;
    return size;
  }

  initializeList(List<bool>inputs ) async{
    int size = await getCategorySizeFuture();
    setState(() {
      for(int i =0; i<size; i++){//initializing the array inputs to false for showing nothing selected when the checkbox pops up for the 1st time
        inputs.add(false);
      }
    });
  }


  @override
  void initState() {
    //getUserPhone();
    initializeList(inputs);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: CustomAppBar(
            title: CustomText(text: 'Become a Bazaarwala', fontSize: 20,),
            onPressed:(){
             Navigator.pop(context);
          },),
        ),
      backgroundColor: Colors.white,
      body:
//          padding: EdgeInsets.fromLTRB(15, 150, 0, 0),
          ListView(
            children: <Widget>[
              if(video != null || _cameraVideo != null) CustomVideoPlayer(videoURL: videoURL),
              createSpaceBetweenButtons(15),
              pageSubtitle(),
              setVideoFromGallery(),
              or(),
              setVideoFromCamera(),
              setLocation(context),
              or(),
              setLocationOtherThanCurrentAsHome(),
              getCategories(context),
              showSaveButton(context),
//            if(moveForward(isSelected))
//              showSaveButton(context),
            ]
          ),
    );
  }


  createSpaceBetweenButtons(double height){
    return SizedBox(
      height: height,
    );
  }



  pageSubtitle(){
    return CustomText(text: 'Advertisement : ',);
  }


  setVideoFromGallery(){
    return CustomRaisedButton(
      onPressed: (){
        _pickVideoFromGallery();
      },
      child: Text("Choose a video from Gallery",style: GoogleFonts.openSans()),
    );
  }
  /// used in setVideoFromGallery(),
  _pickVideoFromGallery() async{
    File _video = await VideoPicker().pickVideoFromGallery();
    video = _video;
    videoURL = await ImagesPickersDisplayPictureURLorFile().getVideoURL(video, userPhoneNo, null);
    setState(() {

    });
  }


  or(){
    return Text('or',style: GoogleFonts.openSans());
  }


  setVideoFromCamera(){
    return RaisedButton(
      onPressed: (){
        _pickVideoFromCamer();
      },
      child: Text("Record from camera",style: GoogleFonts.openSans()),
    );
  }
  _pickVideoFromCamer() async{
//    File video = await ImagePicker.pickVideo(source: ImageSource.camera);
//    _cameraVideo = video;
//    _cameraVideoPlayerController = VideoPlayerController.file(_cameraVideo)..initialize().then((_){
//      setState(() {});
//      _cameraVideoPlayerController.play();
//    });

    File _video = await VideoPicker().pickVideoFromCamer();
    _cameraVideo = _video;
    print("_cameraVideo: $_cameraVideo");
    videoURL = await ImagesPickersDisplayPictureURLorFile().getVideoURL(_cameraVideo, userPhoneNo, null);
    setState(() {

    });
  }


  setLocation(BuildContext context){/// use usersLocation.dart
    return RaisedButton(
      onPressed: () async{
        Position location  = await GeolocationServiceState().getLocation();//setting user's location
          setState(() {
            _bazaarWalaLocation = location;

            latitude = _bazaarWalaLocation.latitude;
            longitude =  _bazaarWalaLocation.longitude;

            Flushbar( /// for the flushBar if the user enters wrong verification code
              icon: SvgPicture.asset(
                'images/stopHand.svg',
                width: 30,
                height: 30,
              ),
              backgroundColor: Colors.white,
              duration: Duration(seconds: 5),
              forwardAnimationCurve: Curves.decelerate,
              reverseAnimationCurve: Curves.easeOut,
              titleText: Text(
                'Currenr Location saved as Home Location',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ourBlack,
                  ),
                ),
              ),
              message: "Please enter your name to move forward",
            )..show(context);
            //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Currenr Location saved as Home Location '),));

          });

        setState(() {

        });

      },
      child: Text("Click to set current location as home location",style: GoogleFonts.openSans()),
    );
  }

  setLocationOtherThanCurrentAsHome(){
    return CustomRaisedButton(
      onPressed: (){
        Future<Position> location  = GeolocationServiceState().getLocation();//setting user's location
        location.then((val){
          setState(() {
            _bazaarWalaLocation = val;
            print("val in _bazaarWalaLocation: $val");
            print("_bazaarWalaLocation in initstate = $_bazaarWalaLocation");
            latitude = _bazaarWalaLocation.latitude;
            longitude =  _bazaarWalaLocation.longitude;

          });
        });
      },
      child: Text("Click to set other location as home location",style: GoogleFonts.openSans()),
    );
  }



  getCategories(BuildContext context){
    return CustomRaisedButton(
      onPressed: () async{
        bool _isSelected = await _categorySelectorCheckListDialogBox(context);
        setState(() {
          print("_isSelected: $_isSelected");
          isSelected = _isSelected;
        });
      },
      child: Text("Select from category",style: GoogleFonts.openSans()),
    );
  }
  Future<bool> _categorySelectorCheckListDialogBox(BuildContext context){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: StatefulBuilder(
              builder: (context, StateSetter setState){
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance.collection("bazaarCategoryTypesAndImages").snapshots(),
                        builder: (context, snapshot) {

                          if(snapshot.data == null) return CircularProgressIndicator();

                          QuerySnapshot querySnapshot = snapshot.data;

                          List<DocumentSnapshot> listOfDocumentSnapshot = snapshot.data.documents;
                          print("listOfDocumentSnapshot: ${querySnapshot.documents[4].data["name"]}");

                          int categoryLength = snapshot.data.documents.length;

                          //A RenderFlex overflowed by 299361 pixels on the bottom.
                          //solution - use Container and constraints
                          return Container(//toDo- make the size of the container flexible
                            height: 300,
                            width: 300,
                            child: ListView.builder(
                                itemCount: categoryLength,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {

                                  print("categoryLength in itembuilder:  $categoryLength");
                                  print("name $index : ${querySnapshot.documents[index].data["name"]}");
                                  //RenderFlex children have non-zero flex but incoming height constraints are unbounded.
                                  return Container(//container was wrapped with sized box before, but we dont need it because we are using column and  flexible which are giving sizes
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 1,
                                          child: CheckboxListTile(
                                            title: Text(querySnapshot.documents[index].data["name"]),
                                            value: inputs[index],
                                            //controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (bool val){
                                              setState(() {
                                                inputs[index] = val;
                                                isSelected = ifNoCategorySelected();
                                                print("isSelected: $isSelected");
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                            ),
                          );
                        }
                    ),
                    MaterialButton(
                      onPressed: (){
                        // pushCategorySelectedToFirebase();
                        if(ifNoCategorySelected() == true){
                          Navigator.of(context).pop(true);
                        }
                        else Navigator.of(context).pop(false);
                      },
                      child: ifNoCategorySelected() ? Text("Save") : null,
                      //child: ifNoCategorySelected() ? Text("Save") : Text("Required"),//flip and show save once and required once
                    ),
                  ],
                );
              },
            ),
          );
        }
    );
  }

  bool ifNoCategorySelected(){
    for(int i=0; i<inputs.length; i++){
      if(inputs[i] == true){
        return true;
      }
    }
    return false;
  }

  void itemChange(bool val, int indexVal){
    setState(() {
      inputs[indexVal] = val;
    });
  }


  bool moveForward(bool isSelected) {
    bool result;
      result = ((video != null || _cameraVideo != null) && isSelected == true && _bazaarWalaLocation != null);
    print("Video : $video} and Camera: $_cameraVideo and IsSelected: $isSelected and bazaarwalalocation: $_bazaarWalaLocation");
    print("result : $result");
    print("bazaarwala location : $_bazaarWalaLocation");
    print("latitude: $latitude");
    print("result : $result");
    setState(() {
      saveButtonVisible = result;
    });
    return saveButtonVisible;
  }



  showSaveButton(BuildContext context){
    print("in showSaveButton");
    bool isVisible;
    setState(() {
      isVisible = moveForward(isSelected);
      print("isVisible: $isVisible");
    });
    return Visibility(
      visible: isVisible,
      child: CustomRaisedButton(
        onPressed: (){
          uploadVideoToFirestore(context);
          pushCategorySelectedToFirebase();
          pushBazaarWalasLocationToFirebase();

          Navigator.push(
              context,
              MaterialPageRoute(//todo- category is hardcoded here, we need to one category to ProductDetail page from the categories selected
                builder: (context) => ProductDetail(productWalaName: userName, category: 'KamWali',),//pass Name() here and pass Home()in name_screen
              )
          );
        },
        child: CustomText(text: 'Save',),
      ),
    );
  }

  pushBazaarWalasLocationToFirebase(){
    GeolocationServiceState().pushBazaarWalasLocationToFirebase(latitude, longitude);
  }


  Future uploadVideoToFirestore(BuildContext context) async{
    String fileName = basename(userPhoneNo+'bazaarProfilePicture');
    //String fileName = basename(_galleryImage.path);
    StorageReference firebaseStorageReference= FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageReference.putFile(video);
    StorageTaskSnapshot imageURLFuture = await uploadTask.onComplete;
    String videoURL = await imageURLFuture.ref.getDownloadURL();
    Firestore.instance.collection("videos").document(userPhoneNo).setData({'url':videoURL});

    setState(() {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile created successufully'),));
    });
  }


  pushCategorySelectedToFirebase() async{
    QuerySnapshot querySnapshot = await Firestore.instance.collection("bazaarCategories").getDocuments();

    if(querySnapshot == null) return CircularProgressIndicator();//to avoid red screen(error)

    String categoryName;

    for(int i=0; i<inputs.length; i++){
      if(inputs[i] == true) {//if any cateogry is selected it would be true in input array
        categoryName = querySnapshot.documents[i].documentID;
        print("category name : $categoryName");

        String phoneNo = userPhoneNo;
        print("userPhoneNo: $userPhoneNo");
        print("userName: $userName");

        //then push it to firebase:
        //1. push the name and the number of the bazaarwala to the bazaarCategories collection under that specific category document
        //bWC => category => number->name,rating
        //2. push the name and number to bazaarWalasBasicProfile
        //bWBP => number => ?  => category => name, rating
        var result = {
          userPhoneNo: {
            'name': userName
          }
        };

        Firestore.instance.collection("bazaarCategories").document(categoryName).setData(result);
        Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo).setData({});
        Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo).collection(userName).document(categoryName).setData({});
      }
    }
  }

}
