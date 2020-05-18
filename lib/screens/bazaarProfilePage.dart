//import 'dart:html';
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
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

  List<bool> inputs = new List<bool>();
  int categorySize;

  final _formKey = GlobalKey<FormState>();

  bool isSelected = false;


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
    QuerySnapshot querySnapshot = await Firestore.instance.collection("bazaarCategories").getDocuments();

    if(querySnapshot == null) return CircularProgressIndicator();//to avoid red screen(error)

    int size = querySnapshot.documents.length;
    return size;
  }

  initializeList(List<bool>inputs ) async{
    print("initializeList");
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
    print("userName in bazaarProfilePgae= $userName");
    print("userPhone in bazaarProfilePgae= $userPhoneNo");

    return Scaffold(
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
                  onPressed: () async{
                   bool _isSelected = await _categorySelectorCheckListDialogBox(context);
                   setState(() {
                     print("_isSelected: $_isSelected");
                     isSelected = _isSelected;
                   });
                  },
                  child: Text("Select from category",style: GoogleFonts.openSans()),
                ),
              if(moveForward(isSelected))
              RaisedButton(
                onPressed: (){
                uploadVideoToFirestore(context);
                pushCategorySelectedToFirebase();
                },
              color: Colors.transparent,
              splashColor: Colors.transparent,
              //highlightColor: Colors.blueGrey,
              elevation: 0,
              hoverColor: Colors.blueGrey,
              child: Text('SAVE',style: GoogleFonts.openSans(
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
    );
  }

  bool moveForward(bool isSelected) {
    bool result;
      result = ((_video != null || _cameraVideo != null) && isSelected == true);
    print("Video : $_video} and Camera: $_cameraVideo and IsSelected: $isSelected");
    print("result : $result");
    return result;
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
                          stream: Firestore.instance.collection("bazaarCategories").snapshots(),
                          builder: (context, snapshot) {

                            if(snapshot.data == null) return CircularProgressIndicator();

                            print("snapshot.data in category selector: ${snapshot.data.documents[0].documentID}");
                            QuerySnapshot querySnapshot = snapshot.data;

                            List<DocumentSnapshot> listOfDocumentSnapshot = snapshot.data.documents;

                            print("categorylength: ${snapshot.data.documents.length}");
                            int categoryLength = snapshot.data.documents.length;

                            print("inputs: $inputs");


                            //A RenderFlex overflowed by 299361 pixels on the bottom.
                            //solution - use Container and constraints
                            return Container(//toDo- make the size of the container flexible
                              height: 300,
                              width: 300,
                              child: ListView.builder(
                                  itemCount: categoryLength,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {

                                    //RenderFlex children have non-zero flex but incoming height constraints are unbounded.
                                    return Container(//container was wrapped with sized box before, but we dont need it because we are using column and  flexible which are giving sizes
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Flexible(
                                            fit: FlexFit.loose,
                                            flex: 1,
                                            child: CheckboxListTile(
                                              title: Text(querySnapshot.documents[index].documentID),
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
                          print("categorySelected: ${ifNoCategorySelected()}");
                          if(ifNoCategorySelected() == true){
                            print("context: true");
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

  void itemChange(bool val, int index){
    setState(() {
      inputs[index] = val;
    });
  }


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
