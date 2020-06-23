import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/screens/changeProfilePicture.dart';
import 'package:gupshop/service/addToFriendsCollection.dart';
import 'package:gupshop/service/customNavigators.dart';
import 'package:gupshop/service/getConversationId.dart';
import 'package:gupshop/service/imagePickersDisplayPicturesFromURLorFile.dart';
import 'package:gupshop/service/profilePictureAndButtonsScreen.dart';
import 'package:gupshop/service/pushToProfilePictures.dart';
import 'package:gupshop/widgets/colorPalette.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customTextField.dart';
import 'package:gupshop/widgets/customTextFormField.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

//=>LoginScreen => NameScreen => Home

class CreateGroupName_Screen extends StatefulWidget {
  final String userPhoneNo;
  String userName;
  final List<String> listOfNumbersInAGroup;

  CreateGroupName_Screen({@required this.userPhoneNo, @required this.userName, @required this.listOfNumbersInAGroup});

  @override
  _CreateGroupName_ScreenState createState() => _CreateGroupName_ScreenState(userPhoneNo: userPhoneNo);
}

class _CreateGroupName_ScreenState extends State<CreateGroupName_Screen> {
  String userName;

  final String userPhoneNo;
  final List<String> listOfNumbersInAGroup;

  String imageUrl = "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/%2B15857547599ProfilePicture?alt=media&token=0a4a79f5-7989-4e14-8927-7b4ca39af7d7";
  static final formKey = new GlobalKey<FormState>();

  String groupName;

  _CreateGroupName_ScreenState({@required this.userPhoneNo, @required this.userName, @required this.listOfNumbersInAGroup});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ListView(//to remove renderflex overflow error
            shrinkWrap: true,
            children: <Widget>[
              displayNameBadge(),
              //ProfilePictureAndButtonsScreen(userPhoneNo: userPhoneNo, imageUrl: imageUrl, height: 390, width: 390,),
              Container(
                child: CustomTextFormField(
                  onChanged:
                      (val){
                    setState(() {
                      this.groupName= val;
                    });
                  },
                  formKey: formKey,
                  onFieldSubmitted: (name){
                    final form = formKey.currentState;
                    if(form.validate()){
                      setState(() {
                        //this.userName= name;
                      });
                    }
                  },
                  labelText: "Enter your Group Name",
                ),

                padding: EdgeInsets.only(left: 20, top: 35, right: 20),
              ),
              IconButton(
                icon: SvgPicture.asset('images/nextArrow.svg',),
                onPressed: ()async{
                  /// create a conversationMetadata which would also have a groupName
                  /// the groupName would be our identifier if the conversation is individual or group
                  String id = await GetConversationId().createNewConversationId(userPhoneNo, listOfNumbersInAGroup, groupName);

                  /// add this group to all the numbers in the listOfNumbersInAGroup
                  List<String> nameList = new List();
                  nameList.add(groupName);
                  AddToFriendsCollection().extractNumbersFromListAndAddToFriendsCollection(listOfNumbersInAGroup, id, id, nameList, groupName);
                  /// add this group in creator's number
                  AddToFriendsCollection().addToFriendsCollection(userPhoneNo, null, nameList, id, groupName);

                  /// add to conversations to avoid italic conversationId
                  Firestore.instance.collection("conversations").document(id).setData({});

                  PushToProfilePictures().newGroupProfilePicture(id);

                  if(groupName == null){
                    Flushbar(
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
                        'Name required',
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: ourBlack,
                          ),
                        ),
                      ),
                      message: "Please enter your name to move forward",
                    )..show(context);
                  }

                  if(groupName != null){
                    CustomNavigator().navigateToIndividualChat(context, null, userName, userPhoneNo, groupName, listOfNumbersInAGroup, null);
                  }
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  displayNameBadge(){
    return Container(
      width: 100,
      height: 100,
      child:
      Image(
        image: AssetImage('images/groupManWoman.png'),
      ),
//      IconButton(
//        icon: SvgPicture.asset(
//        'images/userFace.svg',
//        width: 500,
//        height: 500,
//      ),
//      ),
    );
  }
}


///Vertically Center & Horizontal Center- Center components of a Listview in a scaffold
///Scaffold(
//  appBar: new AppBar(),
//  body: Center(
//    child: new ListView(
//      shrinkWrap: true,
//        padding: const EdgeInsets.all(20.0),
//        children: [
//          Center(child: new Text('ABC'))
//        ]
//    ),
//  ),
//);

///Only Vertical Center
///Scaffold(
//  appBar: new AppBar(),
//  body: Center(
//    child: new ListView(
//      shrinkWrap: true,
//        padding: const EdgeInsets.all(20.0),
//        children: [
//          new Text('ABC')
//        ]
//    ),
//  ),
//);