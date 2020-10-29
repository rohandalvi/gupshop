
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/image/profilePictureAndButtonsScreen.dart';
import 'package:gupshop/retriveFromFirebase/profilePictures.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home.dart';

class ChangeProfilePicture extends StatefulWidget {
  String userName;
  String userPhoneNo;
  bool viewingFriendsProfile;
  String groupConversationId;
  Map<String, ChatListCache> chatListCache;
  String conversationId;
  String imageURL;


  ChangeProfilePicture({@required this.userName, @required this.viewingFriendsProfile,
    @required this.userPhoneNo, this.groupConversationId, this.chatListCache, this.conversationId,
    this.imageURL
  });

  @override
  _ChangeProfilePictureState createState() => _ChangeProfilePictureState(userName: userName, viewingFriendsProfile: viewingFriendsProfile, userPhoneNo: userPhoneNo, groupConversationId: groupConversationId);
}

class _ChangeProfilePictureState extends State<ChangeProfilePicture> {

    String userName;

    String imageURL;
    String userPhoneNo;
    bool viewingFriendsProfile;
    String groupConversationId;


    _ChangeProfilePictureState({@required this.userName, @required this.viewingFriendsProfile, @required this.userPhoneNo, this.groupConversationId});

    @override
    void initState() {
      getUserPhone();
      super.initState();
    }

    ///This class is a display class for profile picture and buttons.
    ///the profile picture and buttons are made in ProfilePictureAndButtonsScreen.



    /// For snackbar: This context cannot be used directly, as the context there is no context given to the scaffold
    /// The context in the Widget build(Buildcontext context) is the context of that build widget, but not
    /// of the Scaffold, we get error :
    /// - Scaffold.of() called with a context that does not contain a Scaffold.
    /// To avoid, this we wrap the widget Center with Builder, which takes context as its parameter
    /// Update: As we no longer user the snackbar we dont need the  Builder
    @override
    Widget build(BuildContext context) {
      print("imageURL in changeProfile : ${widget.imageURL}");
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(WidgetConfig.appBarSeventy),
            child: CustomAppBar(
              onPressed:(){
             // Navigator.pop(context);
              /// if navigating to home from here for change of profile picture for groupchat would give wrong username , because the username would pass as the groupName to the homescreen
            if(viewingFriendsProfile == true || groupConversationId != null){/// if its a group chat, then navigate to individualchat and not home
              Navigator.pop(context, true);
            } else{

              Map<String,dynamic> navigatorMap = new Map();
              navigatorMap[TextConfig.userName] = userName;
              navigatorMap[TextConfig.userPhoneNo] = userPhoneNo;

              Navigator.pushNamed(context, NavigatorConfig.home, arguments: navigatorMap);
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(//@TODo pass userName to this page
//                    builder: (context) => Home(userName: userName,userPhoneNo: userPhoneNo,),//routing to home screen for now, but should be routed to sideMenu
//                  )
//              );
            }
            },),
        ),
        backgroundColor: Colors.white,
        body: Container(
              padding: EdgeInsets.symmetric(horizontal: PaddingConfig.sixteen),
              child:
              /// widget.imageURL would be null when:
              /// - when the profile is viewed from bazaar
              widget.imageURL == null ?
              StreamBuilder(
                  stream:
                  ProfilePictures(userPhoneNo: userPhoneNo).getStream(),
                  //Firestore.instance.collection("profilePictures").document(userPhoneNo).snapshots(),
                  builder: (context, snapshot) {
                    String imageUrl;

                    if(snapshot.data == null) return CircularProgressIndicator();//to avoid error - "getter do

                    imageUrl = snapshot.data['url'];
                    if(imageUrl == null) imageUrl = ImageConfig.userDpPlaceholder;
                    //'images/user.png';///this is the placeholder for the 1st time user, test it using an actual phone

                    return ProfilePictureAndButtonsScreen(
                      userPhoneNo: userPhoneNo, imageUrl: imageUrl,
                      height: WidgetConfig.threeSixtyHeight,
                      width: WidgetConfig.threeSixtyWidth,userName: userName,
                      viewingFriendsProfile: viewingFriendsProfile,
                      groupConversationId: groupConversationId,
                      chatListCache: widget.chatListCache,
                      conversationId: widget.conversationId,
                    );
                  }
              ) :
                ProfilePictureAndButtonsScreen(
                userPhoneNo: userPhoneNo, imageUrl: widget.imageURL, height: WidgetConfig.threeSixtyHeight, width: WidgetConfig.threeSixtyWidth,userName: userName,
                viewingFriendsProfile: viewingFriendsProfile, groupConversationId: groupConversationId,
                chatListCache: widget.chatListCache, conversationId: widget.conversationId,
        )
        ),
      );
    }

//    cache(){
//      return (widget.chatListCache != null && widget.chatListCache.containsKey(widget.conversationId) == true
//      && widget.chatListCache[widget.conversationId].fullScreenPicture != null);
//    }
//
//    cachedDp(){
//      return widget.chatListCache[widget.conversationId].fullScreenPicture;
//    }
//
//    addToCache(ProfilePictureAndButtonsScreen dp){
//      widget.chatListCache[widget.conversationId].fullScreenPicture = dp;
//    }












  /*
  When apply button is pressed on change profile page then the image gets stored in firestore storage
  How:
    Use path for making a simple path of the image file
    Create an instance of StorageRefrence and pass the path to it//get the file name
    Use StorageUploadTask putFile  method to on the StorageRefrence instance//put it to firebase
    Use StorageTaskSnapshot on the the StorageUploadTask above//to know then the task is completed
    Then setState()//to display the image
   */
  /*
    But this context cannot be used directly, as the context there is no context given to the scaffold
    The context in the Widget build(Buildcontext context) is the context of that build widget, but not
    of the Scaffold, we get error :
    - Scaffold.of() called with a context that does not contain a Scaffold.
    To avoid, this we wrap the widget Center with Builder, which takes context as its parameter
   */


    Future<void> getUserPhone() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userPhoneNo = prefs.getString('userPhoneNo');
      setState(() {
        this.userPhoneNo = userPhoneNo;
      });
    }




}