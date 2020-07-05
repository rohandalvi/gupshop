import 'dart:async';
import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contact/generated/i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/models/chat_List.dart';
import 'package:gupshop/service/addToFriendsCollection.dart';
import 'package:gupshop/service/conversationDetails.dart';
import 'package:gupshop/service/createFriendsCollection.dart';
import 'package:gupshop/service/customNavigators.dart';
import 'package:gupshop/service/displayAvatarFromFirebase.dart';
import 'package:gupshop/service/findFriendNumber.dart';
import 'package:gupshop/service/getConversationId.dart';
import 'package:gupshop/service/imagePickersDisplayPicturesFromURLorFile.dart';
import 'package:gupshop/service/recentChats.dart';
import 'package:gupshop/service/sendAndDisplayMessages.dart';
import 'package:gupshop/service/videoPicker.dart';
import 'package:gupshop/service/viewPicturesVideosFromChat.dart';
import 'package:gupshop/widgets/blankScreen.dart';
import 'package:gupshop/widgets/buildMessageComposer.dart';
import 'package:gupshop/widgets/colorPalette.dart';
import 'package:gupshop/widgets/customDialogBox.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';
import 'package:gupshop/widgets/displayPicture.dart';
import 'package:gupshop/widgets/forwardMessagesSnackBarTitleText.dart';
import 'package:gupshop/widgets/fromNameAndTimeStamp.dart';
import 'package:gupshop/widgets/sideMenu.dart';
import 'package:intl/intl.dart';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';

class IndividualChat extends StatefulWidget {
  final String conversationId;
  final String userPhoneNo;
  final String userName;
  final String friendName;/// this should be a list
  List<dynamic> listOfFriendNumbers;
  final Map forwardMessage;
  final bool notGroupMemberAnymore;

  IndividualChat(
      {Key key, @required this.conversationId, @required this.userPhoneNo, @required this.userName, @required this.friendName,this.forwardMessage, this.listOfFriendNumbers, this.notGroupMemberAnymore})
      : super(key: key);
  @override
  _IndividualChatState createState() => _IndividualChatState(
      conversationId: conversationId,
      userPhoneNo: userPhoneNo,
      userName: userName,
      friendName: friendName,
      forwardMessage: forwardMessage,
      listOfFriendNumbers: listOfFriendNumbers,
      notGroupMemberAnymore: notGroupMemberAnymore,
  );

}



class _IndividualChatState extends State<IndividualChat> {
  String conversationId;
  final String userPhoneNo;
  final String userName;
  final String friendName;/// this should be list
  List<dynamic> listOfFriendNumbers;
  final Map forwardMessage;
  final bool notGroupMemberAnymore;

  static int numberOfImageInConversation = 0;///for giving number to the images sent in conversation for
  ///storing in firebase

  _IndividualChatState(
      {@required this.conversationId, @required this.userPhoneNo, @required this.userName, @required this.friendName, this.forwardMessage, this.listOfFriendNumbers, this.notGroupMemberAnymore});

  String value = ""; //TODo

  TextEditingController _controller = new TextEditingController(); //to clear the text  when user hits send button//TODO- for enter
  ScrollController listScrollController = new ScrollController(); //for scrolling the screen
  StreamController streamController= new StreamController();
  List<DocumentSnapshot> documentList;//made for getting old batch of messages when the scrolling limit of 10 messages at a time is reached
  List<DocumentSnapshot> additionalList;
  CollectionReference collectionReference;
  Stream<QuerySnapshot> stream;
  int limitCounter = 1;

  ScrollNotification notification;
  bool isLoading = false;
  bool scroll = false;
  bool isPressed = false;
  VideoPlayerController controller;

  String friendN;
  var groupExits;
  String groupName;


  checkIfGroup() async{
    bool temp = await CheckIfGroup().ifThisIsAGroup(conversationId);
    String tempGroupName = await CheckIfGroup().getGroupName(conversationId);
    setState(() {
      groupExits = temp;
    });

    if(groupExits == false) {
      setState(() {
        friendN = FindFriendNumber().friendNumber(listOfFriendNumbers, userPhoneNo);
      });
    } else {
      setState(() {
        friendN = conversationId;
        groupName = tempGroupName;
      });
    }
  }

  /// get conversationId required for:
  ///
  getConversationId() async{

    /// only an individualChat would come here to create a conversationId as groupChat would get its conversationId in createNameForGroup page
    /// an individualChat would always have groupName as null,
    /// only a groupChat would have groupName
    String id = await GetConversationId().createNewConversationId(userPhoneNo, listOfFriendNumbers, null);

    setState(() {
      conversationId = id;
    });

    await checkIfGroup();

    ///push to my friends collection here
    List<dynamic> nameListForMe = new List();
    nameListForMe.add(friendName);

    /// as we are in this method, this has to be an individual chat and not a group chat as,
    /// group chat when comes to individualchat page will always have conversationId
    /// and hence would never come to this method
    AddToFriendsCollection().addToFriendsCollection(listOfFriendNumbers, id,userPhoneNo,nameListForMe,null,null);///use listOfNumberHere

    ///push to all others friends collection here
    List<dynamic> nameListForOthers = new List();
    nameListForOthers.add(userName);
    AddToFriendsCollection().extractNumbersFromListAndAddToFriendsCollection(listOfFriendNumbers, id, userPhoneNo, nameListForOthers, null, null);

    /// also push the conversationId to conversations:
    Firestore.instance.collection("conversations").document(id).setData({});

    await forwardMessages(id);
  }

  forwardMessages(String conversationId) async{
    await checkIfGroup();
    if(forwardMessage != null) {

      /// forward messages needs to be given this conversation's conversationId
      forwardMessage["conversationId"] = conversationId;
      var data = forwardMessage;

      DocumentReference forwardedMessageId = await SendAndDisplayMessages().pushToFirebaseConversatinCollection(data);

      if(data["videoURL"] != null) data = createDataToPushToFirebase(true, false, "📹", userName, userPhoneNo, conversationId);
      else if(data["imageURL"] != null) data = createDataToPushToFirebase(false, true, "📸", userName, userPhoneNo, conversationId);
      ///Navigating to RecentChats page with pushes the data to firebase
      /// if group chat:

      print("listOfOtherNumbers: $listOfFriendNumbers");
      RecentChats(message: data, convId: conversationId, userNumber:userPhoneNo, userName: userName, listOfOtherNumbers: listOfFriendNumbers, groupExists: groupExits ).getAllNumbersOfAConversation();
    }
  }


  @override
  void initState() {

    /*
    adding collectionReference and stream in initState() is essential for making the autoscroll when messages hit the limit
    when user scrolls
    update - the above comment might be wrong, because passing the stream directly to
    streambuilder without initializing in initState also paginates alright.
     */

    if(conversationId == null) {
      getConversationId();
      /// also create a conversations_number collection
    }else{
      ///if forwardMessage == true, then initialize that method of sending the message
      ///here in the initstate():
      print("conversationId in individualChat in else: $conversationId");
      forwardMessages(conversationId);
    }

    super.initState();
  }




  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async => CustomNavigator().navigateToHome(context, userName, userPhoneNo),
      child: Stack(
        children: <Widget>[
          Material(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(60.0),//the distance between gupShop and tabBars
                child: appBar(context, friendName),
              ),
              //appBar(),
              /// if a member is removed from the group, then he should not be seeing the conversations
              /// once he enters the individual chat page
              /// So, displaying the conversations only when he is a group member
              body: notGroupMemberAnymore == false ? showMessagesAndSendMessageBar(context)
              : BlankScreen(),
            ),
          ),
          _scrollToBottomButton(),
        ],
      ),
    );
  }



  appBar(BuildContext context, String friendName){
    return AppBar(
        backgroundColor: secondryColor.withOpacity(.03),
        elevation: 0,
        leading: IconButton(
        icon: SvgPicture.asset('images/backArrowColor.svg',),
          onPressed:(){
            Navigator.pop(context);
            CustomNavigator().navigateToHome(context, userName, userPhoneNo);
          }
        ),
      title: Material(
        //color: Theme.of(context).primaryColor,
        child: ListTile(
          contentPadding: EdgeInsets.only(top: 4),
          leading: GestureDetector(
            onTap: (){
              if(groupExits){
                /// if  its a group, then change profile picture can be done by anyone
                CustomNavigator().navigateToChangeProfilePicture(context, friendName,  false, friendN, conversationId);/// if its a group then profile pictures are searched using conversationId
                /// if curfew on for group then  change profile picture can be done by only by admin
//                if(iAmAdmin == true){
//                  CustomNavigator().navigateToChangeProfilePicture(context, friendName,  false, friendN, conversationId);/// if its a group then profile pictures are searched using conversationId
//                }
              }
            else CustomNavigator().navigateToChangeProfilePicture(context, friendName,  true, friendN, null);/// if its a group then profile pictures are searched using conversationId
            },
            child: friendN == null ? CircularProgressIndicator() : DisplayAvatarFromFirebase().displayAvatarFromFirebase(friendN, 25, 23.5, false),
          ),
          title: GestureDetector(
              child: CustomText(text: friendName,),
            onTap:(){
                if(notGroupMemberAnymore == false){
                  DialogHelper(userNumber: userPhoneNo, listOfGroupMemberNumbers: listOfFriendNumbers, conversationId: conversationId, isGroup: groupExits).customShowDialog(context);
                }

            }
          ),
          subtitle: CustomText(text: 'Put last seen here',).subTitle(),
          trailing: Wrap(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.video_call),
              ),
              IconButton(
                icon: Icon(Icons.phone),
              ),
            ],
          ),
        ),
      ),
    );
  }



  /*
  List<DocumentSnapshot> documentList;
  if(documentList == null){
                    documentList = snapshot.data.documents;
                  }

   This documentList is made to add next 10 messages to the stream. We cannot directly
   add the messages to the stream. So, we are creating a list and adding next 10 messages
   to it, when the scroll hits the top of the screen.
   When this happens fetchAdditionalMessages() gets called. In this method, we are adding
   next 10 messages to documentList by calling it in stateState(). Because of this,
   the widget Widget Build rebuilds itself and the Streambuilder builds again.
   Now putting the condition
       if(documentList == null){
            documentList = snapshot.data.documents;
          }

   we are making sure that this method if the screen has not reached the top then take
   messages from the stream, else take the messages as added by fectAdditionalMessages.

   When the user sends a message, we are again making the documentList null, because we
   want it to take the messages from the stream again.
   */



  showMessagesAndSendMessageBar(BuildContext context){
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), //to take out the keyboard when tapped on chat screen
      //             onVerticalDragStart: _scrollToBottomButton(),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection("conversations").document(conversationId).collection("messages").orderBy("timeStamp", descending: true).limit(limitCounter*10).snapshots(),
                    //stream,
                    builder: (context, snapshot) {
                      if(snapshot.data == null) return CircularProgressIndicator();//to avoid error - "getter document was called on null"

                      /*
                       we are making sure that if the screen has not reached the top then take
                       messages from the stream, else take the messages as added by
                       fetchAdditionalMessages:(code snippet from fetchAdditionalMessages):
                            setState(() {//setting state is essential, or new messages(next batch of old messages) does not get loaded
                              documentList.addAll(newDocumentList);
                            });

                        if documentList== null => use stream
                        else(its not when  new 10 messages are added to the documentList)
                        else => use that documentList
                       */
                      documentList = snapshot.data.documents;
//                      if(additionalList!=null) {
//                        documentList.addAll(additionalList);
//                        additionalList = null;
//                      }
//                      else {
//                        print("In else");
//                      }

                      return NotificationListener<ScrollUpdateNotification>(
                        child: ListView.separated(
                          controller: listScrollController, //for scrolling messages
                          //shrinkWrap: true,
                          reverse: true,
                          itemCount: documentList.length,
                          itemBuilder: (context, index) {
                            var messageBody;
                            var imageURL;
                            var videoURL;

                            bool isLoading  = true;//for circularProgressIndicator

                            if(documentList[index].data["videoURL"] != null){
                              videoURL = documentList[index].data["videoURL"];
                              controller = VideoPlayerController.network(videoURL);
                            }
                            else if(documentList[index].data["imageURL"] == null){
                              messageBody = documentList[index].data["body"];

                            }else{
                              imageURL = documentList[index].data["imageURL"];
                            }
                            //var messageBody = documentList[index].data["body"];
                            var fromName = documentList[index].data["fromName"];
                            Timestamp timeStamp = documentList[index].data["timeStamp"];
                            String fromNameForGroup = documentList[index].data["fromName"]; /// for group messages
                            bool isMe = false;

                            if (fromName == userName) isMe = true;

                            return ListTile(
                              title: GestureDetector(
                              onTap: (){
                                String openMessage;
                                bool isPicture;
                               // FocusScope.of(context).unfocus();///Not working!!
                                if(messageBody != null){
                                  openMessage = null;
                                }else if(videoURL != null){
                                  openMessage = videoURL;
                                  isPicture = false;
                                }else {
                                  openMessage = imageURL;
                                  isPicture = true;
                                }

                                if(openMessage != null){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewPicturesVideosFromChat(payLoad: openMessage, isPicture: isPicture,),//pass Name() here and pass Home()in name_screen
                                      )
                                  );
                                }
                              },
                                onLongPress: (){
                                  if(isPressed == false){///show snackbar only once
                                    isPressed = true;
                                    String forwardMessage;
                                    String forwardImage;
                                    String forwardVideo;

                                    ///extract the message in a variable called forwardMessage(ideally there should be
                                    /// a list of messages and not just one variable..this is a @todo )
                                    if(messageBody != null){
                                      forwardMessage = messageBody;
                                    }else if(videoURL != null){
                                      forwardVideo = videoURL;
                                    }else forwardImage = imageURL;


                                    ///show snackbar
                                    return Flushbar(
                                      //showProgressIndicator: true,
                                      flushbarStyle: FlushbarStyle.GROUNDED,
                                      padding : EdgeInsets.all(6),
                                      borderRadius: 8,
                                      backgroundColor: Colors.white,

                                      dismissDirection: FlushbarDismissDirection.HORIZONTAL,

                                      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
                                      titleText: ForwardMessagesSnackBarTitleText(
                                        ///what to do after the user longPresses a message
                                        onTap: (){
                                          ///open search page
                                          ///on selecting a contact, send message to that contact

                                          var data;
                                          if(forwardMessage != null) data = {"body":forwardMessage, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
                                          else if(forwardVideo != null) data = {"videoURL":forwardVideo, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
                                          else data = {"imageURL":forwardImage, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};


                                          print("data in flushbar: $data");
                                          print("userName: $userName");
                                          print("userPhoneNo: $userPhoneNo");
                                          CustomNavigator().navigateToContactSearch(context, userName,  userPhoneNo, data);
                                        },
                                      ),
                                      message: 'Change',
                                      onStatusChanged: (val){
                                        print("val: $val");
                                        ///if the user longPresses the button once, dismesses it and later presses
                                        ///it again then the snackbar was not appearing, because isPressed was
                                        ///set to true. So when the flushbar is dismissed, we are setting isPressed
                                        ///to false again, so the snackbar can appear again
                                        if(val == FlushbarStatus.DISMISSED){
                                          isPressed = false;
                                        }
                                      },

                                    )..show(context);
                                  } return Container();



                                  /// UI:
                                  /// on longPress show a mini snackBar which has the option of forward or copy
                                  /// and remove the sendMessage box
                                  /// On pressing forward, take the user to the search which is ordered in the
                                  /// form of list of users(i.e search with the latest conversation on top)
                                  /// On sending the message, take, keep a button of done on the search page
                                  ///
                                  /// backend:
                                  ///
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: isMe? Alignment.centerRight: Alignment.centerLeft,///to align the messages at left and right
                                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0), ///for the box covering the text, when horizontal is increased, the photo size decreases
                                  child: videoURL != null  ? showVideo(videoURL, controller) :imageURL == null?
                                  CustomText(text: messageBody,): showImage(imageURL),
                                  //message
                                ),
                              ),
                              isThreeLine: true,
                              subtitle: FromNameAndTimeStamp(
                                  visible: ((groupExits==null? false : groupExits) && isMe==false),/// groupExits==null? false : groupExits was showing error because groupExists takes time to calculate as it is a future, so we are just adding a placeholder,
                                  fromName:  CustomText(text: fromNameForGroup,fontSize: 12,),
                                  isMe: isMe,
                                  timeStamp:Text(//time
                                    DateFormat("dd MMM kk:mm")
                                        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp.millisecondsSinceEpoch.toString()))),//converting firebase timestamp to pretty print
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic
                                    ),
                                  ),
                              ),
//                              Column(
//                                children: <Widget>[
//                                  Visibility(
//                                    visible: ((groupExits==null? false : groupExits) && isMe==false),/// groupExits==null? false : groupExits was showing error because groupExists takes time to calculate as it is a future, so we are just adding a placeholder
//                                    child: Container(
//                                      width: MediaQuery.of(context).size.width,
//                                        alignment:  Alignment.centerLeft,
//                                        padding:  EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
//                                        child: CustomText(text: fromNameForGroup,fontSize: 12,)
//                                    ),
//                                  ),
////                                  groupExits == true ?
////                                  (isMe==false ? CustomText(text: fromNameForGroup,fontSize: 12,) : Container())
////                                      : Container(),
//                                  Container(
//                                    width: MediaQuery.of(context).size.width,
//                                   // height: MediaQuery.of(context).size.height,
//                                    alignment: isMe? Alignment.centerRight: Alignment.centerLeft,
//
//
////                            margin: isMe ? EdgeInsets.only(left: 40.0) : EdgeInsets.only(left: 0),//if not this then the timeStamp gets locked to the left side of the screen. So same logic as the messages above
//                                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),//pretty padding- for some margin from the side of the screen as well as the top of parent message
//                                    child: Text(//time
//                                      DateFormat("dd MMM kk:mm")
//                                          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp.millisecondsSinceEpoch.toString()))),//converting firebase timestamp to pretty print
//                                      style: TextStyle(
//                                          color: Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic
//                                      ),
//                                    ),
//                                  ),
//                                ],
//                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.white,
                          ),
                        ),
                        onNotification: (notification) {
                          /// ScrollUpdateNotification :
                          /// for listining when the user scrolls up
                          /// Show the scrolltobottom button only when the user scrolls up
                          if(notification is ScrollUpdateNotification){

                            //print("notification: $notification");

                            /// *** explaintaion of if(notification.scrollDelta > 0):
                            /// The problem we has was, setting the state of scroll to false in
                            /// _scrollToTheBottom methos was making the scroll false, but while
                            /// scrolling down there used to be another update on ScrollUpdateNotification
                            /// and it would again set the scroll to true in setState
                            /// So we had to figure out a way to set the state to true only when the
                            /// user is scrolling up.
                            /// if(notification.scrollDelta > 0):
                            ///if we print notification, then we can note that if the screen scrolls
                            ///down then the scrollDelta shows in minus.
                            //someone from stackoverflow said :
                            //if (scrollNotification.metrics.pixels - scrollNotification.dragDetails.delta.dy > 0)
                            //but this was giving us error that delta was called on null, so i used :
                            //if(notification.scrollDelta > 0)
                            if(notification.scrollDelta > 0){
                              setState(() {
                                scroll = true;
                              });
                            }


                            ///scroll button to disappear when the user goes down manually
                            ///without pressing the scrollDown button
                            if(notification.metrics.atEdge
                                &&  !((notification.metrics.pixels - notification.metrics.maxScrollExtent) >
                                    (notification.metrics.minScrollExtent-notification.metrics.pixels))){
                              setState(() {
                                scroll = false;
                              });
                            }
                          }

                          ///onNotification allows us to know when we have reached the limit of the messages
                          ///once the limit is reached, documentList is updated again  with the next 10 messages using
                          ///the fetchAdditionalMesages()
                          if(notification.metrics.atEdge
                              &&  !((notification.metrics.pixels - notification.metrics.minScrollExtent) <
                                  (notification.metrics.maxScrollExtent-notification.metrics.pixels))) {

//                        if(isLoading == true) {//ToDo- check if this is  working with an actual phone
//                          CircularProgressIndicator();}
                          setState(() {
                            limitCounter++;
                          });
                            //fetchAdditionalMessages();
                          }
                          return true;
                        },
                      );
                    }),
              ),
          _buildMessageComposer(),//write and send new message bar
        ],
      ),
    );
  }


  showVideo(String videoURL, VideoPlayerController controller){
    try{
      return
        CustomVideoPlayer(videoURL: videoURL);
    }
    catch (e){
      return Icon(Icons.image);}
  }


  showImage(String imageURL){
    try{
      return
        DisplayPicture().chatPictureFrame(imageURL);
    }
    catch (e){
      return Icon(Icons.image);}
  }


  _buildMessageComposer() {//the type and send message box
    return StatefulBuilder(
      builder: (context, StateSetter setState){
        return BuildMessageComposer(
          firstOnPressed: () async{
            var data = await sendImage();
            pushMessageDataToFirebase(false,true, data);
            setState(() {

            });
          },
          secondOnPressed: () async{
            var data = await sendVideo();
            pushMessageDataToFirebase(true,false, data);
            setState(() {

            });
          },
          onChangedForTextField: (value){
            setState(() {
              this.value=value;///by doing this we are setting the value to value globally
            });
          },
          onPressedForSendingMessageIcon:() async{
            /// when mynumber sends message to a friendNumber in whose friends
            /// collection mynumber does not exist, we have to add that person in
            /// his friends because recent chats wont work then

            ///push to all others friends collection here
            ///this wont ever happen in case of groupchat, because in groupchat all members already have
            ///group as their friend as we have set it this way in createNameForGroup_screen page
            if(groupExits == false){
              var myNumberExistsInFriendsFriendsCollectionWaiting = await Firestore.instance.collection("friends_$friendN").document(userPhoneNo).get();
              var myNumberExistsInFriendsFriendsCollection = myNumberExistsInFriendsFriendsCollectionWaiting.data;
              if(myNumberExistsInFriendsFriendsCollection == null){
                List<String> nameListForOthers = new List();
                nameListForOthers.add(userName);
                AddToFriendsCollection().extractNumbersFromListAndAddToFriendsCollection(listOfFriendNumbers, conversationId, userPhoneNo, nameListForOthers, null, null);
              }
            }
            if(groupExits == true){
              DocumentSnapshot adminNumberFuture = await Firestore.instance.collection("conversationMetadata").document(conversationId).get();
              String adminNumber = adminNumberFuture.data["admin"];
              print("adminNumber: $adminNumber");

              await Future.wait(listOfFriendNumbers.map((element) async{
//              listOfFriendNumbers.forEach((element) async {
                print("element: $element");
                var myNumberExistsInFriendsFriendsCollectionWaiting = await Firestore.instance.collection("friends_$element").document(conversationId).get();
                var myNumberExistsInFriendsFriendsCollection = myNumberExistsInFriendsFriendsCollectionWaiting.data;
                print("myNumberExistsInFriendsFriendsCollection: $myNumberExistsInFriendsFriendsCollection");
                if(myNumberExistsInFriendsFriendsCollection == null){
                  List<String> nameListForOthers = new List();
                  nameListForOthers.add(groupName);
                  AddToFriendsCollection().extractNumbersFromListAndAddToFriendsCollection(listOfFriendNumbers, conversationId, conversationId, nameListForOthers, groupName, adminNumber);
//                                                                                        listOfNumbersInAGroup, id, id, nameList, groupName, userPhoneNo
                }
              }));

            }



            if(value!="") {
              ///if there is not text, then dont send the message
              var data = {"body":value, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
              SendAndDisplayMessages().pushToFirebaseConversatinCollection(data);

              ///Navigating to RecentChats page with pushes the data to firebase
              RecentChats(message: data, convId: conversationId, userNumber:userPhoneNo, userName: userName, listOfOtherNumbers: listOfFriendNumbers, groupExists:groupExits).getAllNumbersOfAConversation();

              _controller.clear();//used to clear text when user hits send button
              listScrollController.animateTo(//for scrolling to the bottom of the screen when a next text is send
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            }
          },

          scrollController: new ScrollController(),
          controller: _controller,
        );
      },

    );
  }


  ///this method picks and crops the image, then converts it to a String which is used to
  ///create a data object to be pushed to firebase, which gets displayed on the screen as
  ///a message
  sendImage() async{
    numberOfImageInConversation++;

    File image = await ImagesPickersDisplayPictureURLorFile().pickImageFromGallery();
    File croppedImage = await ImagesPickersDisplayPictureURLorFile().cropImage(image);
    String imageURL = await ImagesPickersDisplayPictureURLorFile().getImageURL(croppedImage, userPhoneNo, numberOfImageInConversation);
    return createDataToPushToFirebase(false, true, imageURL, userName, userPhoneNo, conversationId);

  }

  sendVideo() async{
    numberOfImageInConversation++;

    File video = await VideoPicker().pickVideoFromGallery();

    String videoURL = await ImagesPickersDisplayPictureURLorFile().getVideoURL(video, userPhoneNo, numberOfImageInConversation);

    return createDataToPushToFirebase(true, false, videoURL, userName, userPhoneNo, conversationId);

  }


  ///this method creates the data to be pushed to firebase
  createDataToPushToFirebase(bool isVideo, bool isImage, String value, String userName, String fromPhoneNumber, String conversationId){
    if(isVideo == true){
      return {"videoURL":value, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
    }

    if(isImage == true){
      return {"imageURL":value, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
    } return {"body":value, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
  }

  ///this method can be used in place of line 498 to navigate to recentChats, but wait, it cant be
  ///becuase there is setState in between, this method is used only to send pictures in
  ///     IconButton(
  ///                  icon: SvgPicture.asset('images/image2vector.svg',),
  ///                  onPressed: () async{
  ///                    var data = await sendImage();
  ///                    pushMessageDataToFirebase(true, data);
  ///                    setState(() {
  ///                      documentList = null;
  ///                    });
  ///                  },
  ///                )
  pushMessageDataToFirebase(bool isVideo, bool isImage, var data){
      Firestore.instance.collection("conversations").document(conversationId).collection("messages").add(data);
      ///Navigating to RecentChats page with pushes the data to firebase
      if(isVideo == true){
        var data = createDataToPushToFirebase(true, false, "📹", userName, userPhoneNo, conversationId);
        RecentChats(message: data, convId: conversationId, userNumber:userPhoneNo, userName: userName , listOfOtherNumbers: listOfFriendNumbers, groupExists: groupExits).getAllNumbersOfAConversation();
      }

      if(isImage == true){
        var data = createDataToPushToFirebase(false, true, "📸", userName, userPhoneNo, conversationId);
        RecentChats(message: data, convId: conversationId, userNumber:userPhoneNo, userName: userName, listOfOtherNumbers: listOfFriendNumbers, groupExists: groupExits ).getAllNumbersOfAConversation();
      }

  }




  _scrollToBottomButton(){///the button with down arrow that should appear only when the user scrolls
      return Visibility(/// a placeholder widget isValid widget
        visible: scroll,
        child: Align(
            alignment: Alignment.centerRight,
            child:
            //scrollListener() ?
            FloatingActionButton(
              tooltip: 'Scroll to the bottom',
              backgroundColor: Colors.transparent,
              elevation: 0,
//              hoverColor: Colors.transparent,

              highlightElevation: 0,
              child: IconButton(
                icon: SvgPicture.asset('images/downArrow.svg',)
                //SvgPicture.asset('images/downChevron.svg',)
              ),
              onPressed: (){
//          Scrollable.ensureVisible(context);
              setState(() {
                scroll = false;
                print("scrill: $scroll");
              });
                listScrollController.animateTo(//for scrolling to the bottom of the screen when a next text is send
                  0.0,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                );
              },
            )
          //: new Align(),
        ),
      );
  }


  ///fetching next batch of messages when user scrolls up for previous messages
//  fetchAdditionalMessages() async {
//    try {
//      print("Fetching ${documentList[documentList.length-1]}");
//      print("Size  ${documentList.length}");
//      List<DocumentSnapshot>  newDocumentList  =  (await Firestore.instance.collection("conversations").document(conversationId).collection("messages")
//          .orderBy("timeStamp", descending: true)
//          .startAfterDocument(documentList[documentList.length-1])
//          .limit(10).getDocuments())
//          .documents;
//
//      print("Got additional messges of size ${newDocumentList.length}");
//      if(newDocumentList.isEmpty) return;
//      additionalList = [];
//
//      setState(() {//setting state is essential, or new messages(next batch of old messages) does not get loaded
//        additionalList.addAll(newDocumentList);
//      });
//    } catch(e) {
//      streamController.sink.addError(e);
//    }
//
//  }
}



