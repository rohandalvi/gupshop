import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/PushToFirebase/friendsCollection.dart';
import 'package:gupshop/PushToFirebase/profilePicturesCollection.dart';
import 'package:gupshop/PushToFirebase/pushToMessageReadUnreadCollection.dart';
import 'package:gupshop/PushToFirebase/recentChatsCollection.dart';
import 'package:gupshop/PushToFirebase/usersCollection.dart';
import 'package:gupshop/image/displayCircularPicture.dart';
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

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String isName;
  String profilePictureURL= ImageConfig.userDpPlaceholderFirebase;

  _NameScreenState({@required this.userPhoneNo});

  @override
  Widget build(BuildContext context) {
    return WillPopScope( /// to not let the user go back from name_screen
      onWillPop: () async => false,/// a required for WillPopScope
        child: Scaffold(
          body: Center(
            child: ListView(//to remove renderflex overflow error
              shrinkWrap: true,
              children: <Widget>[
                avatar(),
                name(),
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
                      UsersCollection(userPhoneNo: userPhoneNo).setName(userName: userName);

                      RecentChatsCollection(userPhoneNo: userPhoneNo).setBlankData();

                      /// if the user is reBoarding then dont use the new URL as
                      /// the profile picture is already set in the database
                      ProfilePicturesCollection(userPhoneNo: userPhoneNo).setPicture(profilePictureURL);

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
                        prefs.setString(TextConfig.userName, userName);
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
          if(profilePictureSnapshot.data != null){
            profilePictureURL = profilePictureSnapshot.data;
          }

          return DisplayCircularPicture(
            image: NetworkImage(profilePictureURL),
            width: WidgetConfig.twoHundredWidth,
            height: WidgetConfig.twoHundredHeight,
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
          if(nameSnapshot.data != null){
            userName = nameSnapshot.data;
          }

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
