//import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/service/checkBoxCategorySelector.dart';
import 'package:gupshop/service/geolocation_service.dart';
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

  File _video;
  VideoPlayerController _videoPlayerController;
  bool isVideo = false;
  dynamic _pickImageError;
  bool selected = false; //for checkbox

  List<bool> inputs = new List<bool>();
  int categorySize;

  final _formKey = GlobalKey<FormState>();



//  _pickVideoFromGallery() async{
//    if(_videoPlayerController != null){
//      _videoPlayerController.setVolume(0);
//      _videoPlayerController.removeListener(_onVideoControllerUpdate);
//    }
//    if(isVideo){
//      ImagePicker.pickVideo(source: ImageSource.gallery).then((File file){
//        if(file != null && mounted){
//          setState(() {
//            _videoPlayerController = VideoPlayerController.file(file)
//              ..addListener(_onVideoControllerUpdate)
//              ..setVolume(1.0)
//              ..initialize()
//              ..setLooping(false)
//              ..play();
//          });
//        }
//      });
//    } else {
//      try{
//        _video = await ImagePicker.pickVideo(source: ImageSource.gallery);
//      }catch(e){
//        _pickImageError = e;
//      }
//      setState(() {});
//    }
//  }

//  void _onVideoControllerUpdate(){
//    setState(() {});
//  }



  _pickVideoFromGallery() async{
    File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    _video = video;
//    _videoPlayerController = VideoPlayerController.asset('videos/LevenworthVideo.mp4')..initialize().then((_){;
    _videoPlayerController = VideoPlayerController.file(_video)..initialize().then((_){
      setState(() {
        _videoPlayerController.play();
      });

    });
  }


  File _cameraVideo;
  VideoPlayerController _cameraVideoPlayerController;

  _pickVideoFromCamer() async{
    File video = await ImagePicker.pickVideo(source: ImageSource.camera);
    _cameraVideo = video;
    _cameraVideoPlayerController = VideoPlayerController.file(_cameraVideo)..initialize().then((_){
      setState(() {});
      _cameraVideoPlayerController.play();
    });
  }



  getCategorySizeFuture() async{
    CollectionReference collectionReference = await Firestore.instance.collection("bazaarCategories");
    QuerySnapshot querySnapshot = await collectionReference.getDocuments();
    int size = querySnapshot.documents.length;
    return size;
  }

  initializeList(List<bool>inputs ) async{
    int size = await getCategorySizeFuture();
    setState(() {
      for(int i =0; i<size; i++){
        inputs.add(true);
      }
    });
  }



  @override
  void initState() {
    //getUserPhone();

    //initializeList(inputs);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("userName in bazaarProfilePgae= $userName");
    print("userPhone in bazaarProfilePgae= $userPhoneNo");

    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Builder(
            builder:(context)=> Container(
            padding: EdgeInsets.fromLTRB(15, 150, 0, 0),
            child: Center(
              child: Column(
                children: <Widget>[
                  if(_video != null)
                    _videoPlayerController.value.initialized
                    ? AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController),
                    )
                        : Container()
                  else
                    Text('BECOME A BAZAARWALA !',style: GoogleFonts.openSans()),
                    SizedBox(
                      height: 15,
                    ),
                    Text('Lets start by adding your advertisement:',style: GoogleFonts.openSans()),
                  RaisedButton(
                    onPressed: (){
                      _pickVideoFromGallery();
                    },
                    child: Text("Choose a video from Gallery",style: GoogleFonts.openSans()),
                  ),
                  Text('or',style: GoogleFonts.openSans()),
//                FutureBuilder<Object>(
//                  future: _pickVideoFromCamer(),
//                  builder: (context, snapshot) {
//                    switch(snapshot.connectionState){
//                      case ConnectionState.done:
//                        return RaisedButton(
//                          onPressed: (){
//                            _pickVideoFromCamer();
//                          },
//                          child: Text("Record from camera",style: GoogleFonts.openSans()),
//                        );
//                      default: if(snapshot.hasError) return Text('Dont know what');
                      //}
                      RaisedButton(
                        onPressed: (){
                          _pickVideoFromCamer();
                        },
                        child: Text("Record from camera",style: GoogleFonts.openSans()),
                      ),
                     // );
                   // }
                 // ),
                  IconButton(
                    icon: Icon(Icons.location_on),
                    onPressed: (){
                      Future<Position> location  = GeolocationServiceState().getLocation();//setting user's location
                      location.then((val){
                        setState(() {
                          _bazaarWalaLocation = val;
                          print("val in _bazaarWalaLocation: $val");
                          print("_bazaarWalaLocation in initstate = $_bazaarWalaLocation");
                          double latitude = _bazaarWalaLocation.latitude;
                          double longitude =  _bazaarWalaLocation.longitude;

                          print("latitude in bazaar : $latitude");

                          GeolocationServiceState().pushBazaarWalasLocationToFirebase(latitude, longitude);
                        });
                      });
                    },
                  ),
                  RaisedButton(
                    onPressed: (){
                     showDialog(
                         context: context,
                       builder: (context){
                           return
                             CheckBoxCategorySelector(userPhoneNo: userPhoneNo, userName: userName,);
                       }
                     );
                    },
                    child: Text("Select from category",style: GoogleFonts.openSans()),
                  ),


                  if(!(_video == null && _cameraVideo == null))//show the apply button only when a new image is selected, else no need
                  RaisedButton(
                    onPressed: (){
//                            if(_galleryImage != null) image = basename(_galleryImage.path);
//                            if(_cameraImage != null) image = basename(_cameraImage.path);
                      uploadVideoToFirestore(context);
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

                ]
            ),
          ),
        ),
      )
      ),
    );
  }

//  String userPhoneNo;
//
//  Future<void> getUserPhone() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    userPhoneNo = prefs.getString('userPhoneNo');
//    setState(() {
//      this.userPhoneNo = userPhoneNo;
//    });
//    print("userPhoneNo: $userPhoneNo");
//    print("prefs: $prefs");
//  }

  Future uploadVideoToFirestore(BuildContext context) async{
    String fileName = basename(userPhoneNo+'bazaarProfilePicture');
    //String fileName = basename(_galleryImage.path);
    StorageReference firebaseStorageReference= FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageReference.putFile(_video);
    StorageTaskSnapshot imageURLFuture = await uploadTask.onComplete;
    String videoURL = await imageURLFuture.ref.getDownloadURL();
    print("imageurl: $videoURL");
    Firestore.instance.collection("videos").document(userPhoneNo).setData({'url':videoURL});

    setState(() {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture uploaded'),));
    });
  }
}
