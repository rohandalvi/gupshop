import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/navigators/navigateToHome.dart';
import 'package:gupshop/onboarding/onBoardingTrace.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
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

  String imageUrl = "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/%2B15857547599ProfilePicture?alt=media&token=0a4a79f5-7989-4e14-8927-7b4ca39af7d7";
  //static final formKey = new GlobalKey<FormState>();
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String isName;

  _NameScreenState({@required this.userPhoneNo});

  @override
  Widget build(BuildContext context) {
    return WillPopScope( /// to not let the user go back from name_screen
      onWillPop: () async => false,/// a required for WillPopScope
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: ListView(//to remove renderflex overflow error
              shrinkWrap: true,
              children: <Widget>[
                displayNameBadge(),
                //ProfilePictureAndButtonsScreen(userPhoneNo: userPhoneNo, imageUrl: imageUrl, height: 390, width: 390,),
                Container(
                  child: CustomTextFormField(
                        maxLength: 25, /// name length restricted to 25 letters
                        onChanged:
                            (val){
                          setState(() {
                            this.isName= val;
                            this.userName= val;
                          });
                        },
                        formKeyCustomText: formKey,
                        onFieldSubmitted: (name){
                          final form = formKey.currentState;
                          if(form.validate()){
                            setState(() {
                              this.userName= name;
                            });
                          }
                        },
                        labelText: TextConfig.enterName,
                      ),

                  padding: EdgeInsets.only(left: PaddingConfig.twenty, top: PaddingConfig.thirtyFive, right: PaddingConfig.twenty),
                ),
                IconButton(
                  icon: SvgPicture.asset('images/nextArrow.svg',),
                  onPressed: ()async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String userNameForSP = prefs.getString('userName');
                    print("userNameForSP in name_screen: $userNameForSP");



                    /// ToDo : put all the firebase calls in if(userName != null){}
                    ///Add first time user’s number to database:
                    ///For adding data, we need to use set() method
                    ///We dont have userPhone and name both at the login_screen, we get both
                   /// of them in the name_screen, so we will add them in that file only.
                    Firestore.instance.collection("users").document(userPhoneNo).setData({'name':userName});

                    //add userPhoneNumber to our database. Add to the users collection:
                    Firestore.instance.collection("recentChats").document(userPhoneNo).setData({});

                    ///creating a document with the user's phone number in profilePictures collection which would have no data set for the profile picture itself if the  user logs in for the first time, later he can add the profile picture  himself
                    /// also setting a placeholder
                    /// The placeholder imageurl  as the user picture url we have stored in firebase
                    String url = "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/user.png?alt=media&token=28bcfc15-31da-4847-8f7c-efdd60428714";
                    Firestore.instance.collection("profilePictures").document(userPhoneNo).setData({'url' : url});

                    List<String> nameList = new List();
                    nameList.add(userName);

                    phoneNumberList = new List();
                    phoneNumberList.add(userPhoneNo);
                    ///groupName is set  to null, to identify group from individual which is required in createGroup page to show only individuals and not group in search
                    Firestore.instance.collection("friends_$userPhoneNo").document(userPhoneNo).setData({'phone': phoneNumberList, 'nameList' : nameList, 'groupName' : null, 'isMe': true});///necessary to create data, orsearch in contact search page shows error

                    setState(() {
                      prefs.setString('userName', userName);
                    });

                    if(userName == null){
                      Flushbar(
                        icon: SvgPicture.asset(
                            'images/stopHand.svg',
                          width: IconConfig.flushbarIconThirty,
                          height: IconConfig.flushbarIconThirty,
                        ),
                        flushbarStyle: FlushbarStyle.GROUNDED,
                        backgroundColor: Colors.white,
                        duration: Duration(seconds: 5),
                        forwardAnimationCurve: Curves.decelerate,
                        reverseAnimationCurve: Curves.easeOut,
                        titleText: CustomText(text : 'Name required'),
                        message: "Please enter your name to move forward",
                      )..show(context);
                    }

                    if(userName != null){
                      NavigateToHome().navigateNoBrackets(context);
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                            builder: (context) => Home(
//                                userPhoneNo: userPhoneNo,
//                                userName: userName),//pass Name() here and pass Home()in name_screen
//                          )
//                      );

                      OnBoardingTrace().createNewUser();
                    }
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  displayNameBadge(){
    return Container(
      width: WidgetConfig.hundredWidth,
      height: WidgetConfig.hundredHeight,
      child:
        Image(
          image: AssetImage(ImageConfig.userDpPlaceholder),
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