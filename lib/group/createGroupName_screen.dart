import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/PushToFirebase/pushToMessageTypingCollection.dart';
import 'package:gupshop/screens/changeProfilePicture.dart';
import 'package:gupshop/service/addToFriendsCollection.dart';
import 'package:gupshop/widgets/customNavigators.dart';
import 'package:gupshop/service/getConversationId.dart';
import 'package:gupshop/image/imagePickersDisplayPicturesFromURLorFile.dart';
import 'package:gupshop/service/profilePictureAndButtonsScreen.dart';
import 'package:gupshop/service/pushToProfilePictures.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customTextField.dart';
import 'package:gupshop/widgets/customTextFormField.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home.dart';

//=>LoginScreen => NameScreen => Home

class CreateGroupName_Screen extends StatefulWidget {
  final String userPhoneNo;
  String userName;
  final List<String> listOfNumbersInAGroup;

  CreateGroupName_Screen({@required this.userPhoneNo, @required this.userName, @required this.listOfNumbersInAGroup});

  @override
  _CreateGroupName_ScreenState createState() => _CreateGroupName_ScreenState(userPhoneNo: userPhoneNo, userName: userName, listOfNumbersInAGroup: listOfNumbersInAGroup);
}

class _CreateGroupName_ScreenState extends State<CreateGroupName_Screen> {
  String userName;

  final String userPhoneNo;
  final List<String> listOfNumbersInAGroup;

  String imageUrl = "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/%2B15857547599ProfilePicture?alt=media&token=0a4a79f5-7989-4e14-8927-7b4ca39af7d7";
  final formKey = new GlobalKey<FormState>();

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
                    print("groupName in onChanged : $groupName");
                  },
                  formKeyCustomText: formKey,
                  onFieldSubmitted: (name){
                    final form = formKey.currentState;
                    if(form.validate()){
                      setState(() {
                        //this.userName= name;
                      });
                    }
                  },
                  labelText: "Enter your Group Name",
                  maxLength: 20,
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
                  /// in friendsCollection we have phoneList as a field for storing the numbers of the friends.
                  /// It is required for forwarding messages to a group. Having that list ensures that the
                  /// forward message is forwarded to all members of the ggroup
                  AddToFriendsCollection(friendListForGroupForFriendsCollection: listOfNumbersInAGroup).extractNumbersFromListAndAddToFriendsCollection(listOfNumbersInAGroup, id, id, nameList, groupName, userPhoneNo);
                  /// add this group in creator's number
                  List<String> nameListForMyNumber = new List();/// would have the conversationId only
                  nameListForMyNumber.add(id);
                  AddToFriendsCollection(friendListForGroupForFriendsCollection: listOfNumbersInAGroup).addToFriendsCollection(nameListForMyNumber, id, userPhoneNo, nameList,groupName, userPhoneNo);/// **

                  /// add to conversations to avoid italic conversationId
                  Firestore.instance.collection("conversations").document(id).setData({});

                  PushToProfilePictures().newGroupProfilePicture(id);

                  /// setData to messageTyping collection:
                  PushToMessageTypingCollection(conversationId: id, userNumber: userPhoneNo).pushTypingStatus();

                  print("groupName : $groupName");
                  if(groupName == null || groupName == ""){
                    Flushbar(
                      icon: SvgPicture.asset(
                        'images/stopHand.svg',
                        width: 30,
                        height: 30,
                      ),
                      flushbarStyle: FlushbarStyle.GROUNDED,
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
                      message: "Please enter name to move forward",
                    )..show(context);
                  } else{
                    CustomNavigator().navigateToIndividualChat(context, id, userName, userPhoneNo, groupName, listOfNumbersInAGroup, null, false);
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