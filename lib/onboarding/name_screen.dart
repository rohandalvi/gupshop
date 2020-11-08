import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/PushToFirebase/friendsCollection.dart';
import 'package:gupshop/PushToFirebase/profilePicturesCollection.dart';
import 'package:gupshop/PushToFirebase/pushToMessageReadUnreadCollection.dart';
import 'package:gupshop/PushToFirebase/recentChatsCollection.dart';
import 'package:gupshop/PushToFirebase/usersCollection.dart';
import 'package:gupshop/navigators/navigateToHome.dart';
import 'package:gupshop/onboarding/onBoardingTrace.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/intConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/retriveFromFirebase/profilePictures.dart';
import 'package:gupshop/widgets/customFlushBar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customTextFormField.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home.dart';

//=>LoginScreen => NameScreen => Home

class NameScreen extends StatefulWidget {
  final String userPhoneNo;
  String userName;

  NameScreen({@required this.userPhoneNo});

  @override
  _NameScreenState createState() => _NameScreenState(userPhoneNo: userPhoneNo);
}

class _NameScreenState extends State<NameScreen> {
  String userName;
  final String userPhoneNo;
  List<String> phoneNumberList;

//  String imageUrl = "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/%2B15857547599ProfilePicture?alt=media&token=0a4a79f5-7989-4e14-8927-7b4ca39af7d7";
  //static final formKey = new GlobalKey<FormState>();
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String isName;
  String profilePictureURL= ImageConfig.userDpPlaceholderFirebase;

  _NameScreenState({@required this.userPhoneNo});

  @override
  Widget build(BuildContext context) {
    return WillPopScope( /// to not let the user go back from name_screen
      onWillPop: () async => false,/// a required for WillPopScope
//      child: MaterialApp(
        child: Scaffold(
//    home: Scaffold(
          body: Center(
            child: ListView(//to remove renderflex overflow error
              shrinkWrap: true,
              children: <Widget>[
                avatar(),
                name(),
//                Container(
//                  child: CustomTextFormField(
//                        maxLength: IntConfig.textFormFieldLimitTwentyFive, /// name length restricted to 25 letters
//                        onChanged: (val){
//                          setState(() {
//                            this.isName= val;
//                            this.userName= val;
//                          });
//                        },
//                        formKeyCustomText: formKey,
//                        onFieldSubmitted: (name){
//                          final form = formKey.currentState;
//                          if(form.validate()){
//                            setState(() {
//                              this.userName= name;
//                            });
//                          }
//                        },
//                        labelText: TextConfig.enterName,
//                      ),
//
//                  padding: EdgeInsets.only(left: PaddingConfig.twenty, top: PaddingConfig.thirtyFive, right: PaddingConfig.twenty),
//                ),
                CustomIconButton(
                  iconNameInImageFolder: IconConfig.forwardIcon,
                  onPressed: ()async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String userNameForSP = prefs.getString('userName');
                    print("userNameForSP in name_screen: $userNameForSP");



                    /// ToDo : put all the firebase calls in if(userName != null){}
                    ///Add first time user’s number to database:
                    ///For adding data, we need to use set() method
                    ///We dont have userPhone and name both at the login_screen, we get both
                   /// of them in the name_screen, so we will add them in that file only.

                    if(userName == null || userName == ""){
                      CustomFlushBar(customContext: context,
                        text: CustomText(text:TextConfig.nameRequiredText,))
                          .showFlushBarStopHand();
                    }

                    if(userName != null && userName != TextConfig.blankString){
                      print("userName in onPressed : $userName");
                      UsersCollection(userPhoneNo: userPhoneNo).setName(userName: userName);

                      //add userPhoneNumber to our database. Add to the users collection:
                      RecentChatsCollection(userPhoneNo: userPhoneNo).setBlankData();

                      ///creating a document with the user's phone number in profilePictures collection which would have no data set for the profile picture itself if the  user logs in for the first time, later he can add the profile picture  himself
                      /// also setting a placeholder
                      /// The placeholder imageurl  as the user picture url we have stored in firebase
//                      String url = ImageConfig.userDpPlaceholderFirebase;

                      /// if the user is reBoarding then dont use the new URL as
                      /// the profile picture is already set in the database
                      print("profilePictureURL in onPressed : $profilePictureURL");
                      ProfilePicturesCollection(userPhoneNo: userPhoneNo).setPicture(profilePictureURL);
//                      String existingUrl = await ProfilePictures(userPhoneNo: userPhoneNo).getProfilePicture();
//                      print("existingUrl : $existingUrl");
//                      if(existingUrl == null){
//                        ProfilePicturesCollection(userPhoneNo: userPhoneNo).setPicture(url);
//                      }

                      List<String> nameList = new List();
                      nameList.add(userName);

                      phoneNumberList = new List();
                      phoneNumberList.add(userPhoneNo);
                      ///groupName is set  to null, to identify group from individual which is required in createGroup page to show only individuals and not group in search

                      FriendsCollection(userPhoneNo: userPhoneNo).setMeAsFriend(phoneNumberList, nameList);

                      /// for 1st brand new conversation, the messageReadUnread
                      /// would not have userPhoneNo
                      PushToMessageReadUnreadCollection(userNumber: userPhoneNo).setBlankDocument();

                      setState(() {
                        prefs.setString('userName', userName);
                      });



                      NavigateToHome().navigateNoBrackets(context);

                      /// Trace
                      OnBoardingTrace().createNewUser();
                    }
                  },
                ),

              ],
            ),
          ),
        ),
//      ),
    );
  }

  avatar(){
    return FutureBuilder(
      future: ProfilePictures(userPhoneNo: userPhoneNo).getProfilePicture(),
      builder: (BuildContext context, AsyncSnapshot profilePictureSnapshot) {
        if (profilePictureSnapshot.connectionState == ConnectionState.done) {
          print("profilePictureSnapshot.data : ${profilePictureSnapshot.data}");
          if(profilePictureSnapshot.data != null){
            profilePictureURL = profilePictureSnapshot.data;
          }
          print("profilePictureURL : $profilePictureURL");

          return Container(
            width: WidgetConfig.hundredWidth,
            height: WidgetConfig.hundredHeight,
            child:
            Image(
              image: NetworkImage(profilePictureURL),
            ),
          );
        }
        return Container(
          width: WidgetConfig.hundredWidth,
          height: WidgetConfig.hundredHeight,
          child:
          Image(
            image: AssetImage(ImageConfig.userDpPlaceholder),
          ),
        );
      },
    );
  }

  name(){
    return FutureBuilder(
      future: UsersCollection(userPhoneNo: userPhoneNo).getName(),
      builder: (BuildContext context, AsyncSnapshot nameSnapshot) {
        if (nameSnapshot.connectionState == ConnectionState.done) {
          print("nameSnapshot.data : ${nameSnapshot.data}");
          if(nameSnapshot.data != null){
            userName = nameSnapshot.data;
          }
          print("userName : $userName");

          return Container(
            child: CustomTextFormField(
              maxLength: IntConfig.textFormFieldLimitTwentyFive, /// name length restricted to 25 letters
              onChanged: (val){
                this.isName= val;
                this.userName= val;
//                setState(() {
//                  this.isName= val;
//                  this.userName= val;
//                });
              },
              formKeyCustomText: formKey,
              onFieldSubmitted: (name){
                final form = formKey.currentState;
                if(form.validate()){
                  this.userName = name;
//                  setState(() {
//                    this.userName= name;
//                  });
                }
              },
              initialValue: userName == null ? TextConfig.blankString : userName,
              labelText: TextConfig.enterName,
            ),

            padding: EdgeInsets.only(left: PaddingConfig.twenty, top: PaddingConfig.thirtyFive, right: PaddingConfig.twenty),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
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