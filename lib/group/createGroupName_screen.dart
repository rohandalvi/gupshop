import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/PushToFirebase/pushToConversationCollection.dart';
import 'package:gupshop/PushToFirebase/pushToMessageTypingCollection.dart';
import 'package:gupshop/navigators/navigateToIndividualChat.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/service/addToFriendsCollection.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customFlushBar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customNavigators.dart';
import 'package:gupshop/service/getConversationId.dart';
import 'package:gupshop/service/pushToProfilePictures.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customTextFormField.dart';

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

  String imageUrl = ImageConfig.groupDpPlaceholderStorageImage;
  final formKey = new GlobalKey<FormState>();

  String groupName;

  _CreateGroupName_ScreenState({@required this.userPhoneNo, @required this.userName, @required this.listOfNumbersInAGroup});

  @override
  Widget build(BuildContext context) {
//    return MaterialApp(
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(WidgetConfig.appBarSeventy),
          child: CustomAppBar(
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: ListView(//to remove renderflex overflow error
            shrinkWrap: true,
            children: <Widget>[
              displayNameBadge(),
              //ProfilePictureAndButtonsScreen(userPhoneNo: userPhoneNo, imageUrl: imageUrl, height: 390, width: 390,),
              Container(
                child: CustomTextFormField(
                  onChanged: (val){
                    setState(() {
                      this.groupName= val;
                    });
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

                padding: EdgeInsets.only(left: PaddingConfig.twenty,
                    top: PaddingConfig.thirtyFive, right: PaddingConfig.twenty),
              ),
              CustomIconButton(
                iconNameInImageFolder: IconConfig.forwardIcon,
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
                  PushToConversationCollection().setBlankData(id);
                  //Firestore.instance.collection("conversations").document(id).setData({});

                  PushToProfilePictures().newGroupProfilePicture(id);

                  /// setData to messageTyping collection:
                  PushToMessageTypingCollection(conversationId: id, userNumber: userPhoneNo).pushTypingStatus();


                  if(groupName == null || groupName == ""){
                    CustomFlushBar(
                      text: CustomText(text: TextConfig.nameRequiredText,),
                      message: TextConfig.nameRequiredText,
                      customContext: context,
                    ).showFlushBarStopHand();
//                    Flushbar(
//                      icon: SvgPicture.asset(
//                        'images/stopHand.svg',
//                        width: IconConfig.flushbarIconThirty,
//                        height: IconConfig.flushbarIconThirty,
//                      ),
//                      flushbarStyle: FlushbarStyle.GROUNDED,
//                      backgroundColor: Colors.white,
//                      duration: Duration(seconds: 5),
//                      forwardAnimationCurve: Curves.decelerate,
//                      reverseAnimationCurve: Curves.easeOut,
//                      titleText: Text(
//                        'Name required',
//                        style: GoogleFonts.openSans(
//                          textStyle: TextStyle(
//                            fontWeight: FontWeight.w600,
//                            color: ourBlack,
//                          ),
//                        ),
//                      ),
//                      message: "Please enter name to move forward",
//                    )..show(context);
                  } else{
                    NavigateToIndividualChat(
                        conversationId: id,
                        userName: userName,
                      userPhoneNo: userPhoneNo,
                      friendName: groupName,
                      data: null,
                      notGroupMemberAnymore: false,
                      listOfFriendNumbers: listOfNumbersInAGroup,
                    ).navigateNoBrackets(context);
                    //CustomNavigator().navigateToIndividualChat(context, id, userName, userPhoneNo, groupName, listOfNumbersInAGroup, null, false);
                  }
                },
              ),

            ],
          ),
        ),
      );
//    );
  }

  displayNameBadge(){
    return Container(
      width: WidgetConfig.hundredWidth,
      height: WidgetConfig.hundredHeight,
      child:
      Image(
        image: AssetImage(ImageConfig.groupDpPlaceholderImage),
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