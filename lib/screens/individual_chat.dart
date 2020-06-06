import 'dart:async';
import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter_contact/generated/i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/models/chat_List.dart';
import 'package:gupshop/service/customNavigators.dart';
import 'package:gupshop/service/displayAvatarFromFirebase.dart';
import 'package:gupshop/service/imagePickersDisplayPicturesFromURLorFile.dart';
import 'package:gupshop/service/recentChats.dart';
import 'package:gupshop/widgets/colorPalette.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/displayPicture.dart';
import 'package:gupshop/widgets/forwardMessagesSnackBarTitleText.dart';
import 'package:gupshop/widgets/sideMenu.dart';
import 'package:intl/intl.dart';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transparent_image/transparent_image.dart';

class IndividualChat extends StatefulWidget {
  final String conversationId;
  final String userPhoneNo;
  final String userName;
  final String friendName;
  final String friendNumber;
  final Map forwardMessage;

  IndividualChat(
      {Key key, @required this.conversationId, @required this.userPhoneNo, @required this.userName, @required this.friendName, @required this.friendNumber,this.forwardMessage})
      : super(key: key);
  @override
  _IndividualChatState createState() => _IndividualChatState(
      conversationId: conversationId,
      userPhoneNo: userPhoneNo,
      userName: userName,
      friendName: friendName,
      friendNumber: friendNumber,
      forwardMessage: forwardMessage,
  );

}



class _IndividualChatState extends State<IndividualChat> {
  final String conversationId;
  final String userPhoneNo;
  final String userName;
  final String friendName;
  final String friendNumber;
  final Map forwardMessage;

  static int numberOfImageInConversation = 0;///for giving number to the images sent in conversation for
  ///storing in firebase

  _IndividualChatState(
      {@required this.conversationId, @required this.userPhoneNo, @required this.userName, @required this.friendName, @required this.friendNumber, this.forwardMessage});

  String value = ""; //TODo

  TextEditingController _controller = new TextEditingController(); //to clear the text  when user hits send button//TODO- for enter
  ScrollController listScrollController = new ScrollController(); //for scrolling the screen
  StreamController streamController= new StreamController();
  List<DocumentSnapshot> documentList;//made for getting old batch of messages when the scrolling limit of 10 messages at a time is reached
  CollectionReference collectionReference;
  Stream<QuerySnapshot> stream;

  ScrollNotification notification;
  bool isLoading = false;
  bool scroll = false;
  bool isPressed = false;


  @override
  void initState() {
    print("numberOfImage: $numberOfImageInConversation");

    /*
    adding collectionReference and stream in initState() is essential for making the autoscroll when messages hit the limit
    when user scrolls
    update - the above comment might be wrong, because passing the stream directly to
    streambuilder without initializing in initState also paginates alright.
     */
    collectionReference = Firestore.instance.collection("conversations").document(conversationId).collection("messages");
    stream = collectionReference.orderBy("timeStamp", descending: true).limit(10).snapshots();


    ///if isThereAForwardMessage == true, then initialize that method of sending the message
    ///here in the initstate():
    print("forwardMessage out: $forwardMessage");
    if(forwardMessage != null){
      print("forwardMessage: $forwardMessage");
      var data = forwardMessage;
      String conversationId = data["conversationId"];

      //var data = {"body":value, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
      Firestore.instance.collection("conversations").document(conversationId).collection("messages").add(data);

      setState(() {
        documentList = null;
      });

//      if(data["body"] != null) pushMessageDataToFirebase(false, data);
//      else pushMessageDataToFirebase(true, data);
      print("in init");
      print("data[imageURL] :${data["imageURL"]}");


      if(data["imageURL"] != null) data = createDataToPushToFirebase(true, "📸", userName, userPhoneNo, conversationId);
      ///Navigating to RecentChats page with pushes the data to firebase
      RecentChats(message: data, convId: conversationId, userNumber:userPhoneNo, userName: userName ).getAllNumbersOfAConversation();

//      _controller.clear();//used to clear text when user hits send button
//      listScrollController.animateTo(//for scrolling to the bottom of the screen when a next text is send
//        0.0,
//        curve: Curves.easeOut,
//        duration: const Duration(milliseconds: 300),
//      );
    }

    super.initState();
  }


  @override
  Widget build(BuildContext context){
    return Stack(
      children: <Widget>[
        Material(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.0),//the distance between gupShop and tabBars
              child: appBar(context, friendName),
            ),
            //appBar(),
            body: showMessagesAndSendMessageBar(),
          ),
        ),
        _scrollToBottomButton(),
      ],
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
          }
        ),
      title: Material(
        //color: Theme.of(context).primaryColor,
        child: ListTile(
          contentPadding: EdgeInsets.only(top: 4),
//          contentPadding: EdgeInsets.symmetric(vertical: 5),
          leading:
//          Padding(
//            padding: EdgeInsets.only(top: 5),
//            child: Material(
//              child: DisplayAvatarFromFirebase().displayAvatarFromFirebase(friendNumber, 30, 27),
//            ),
//          ),
          GestureDetector(
            onTap: (){
              CustomNavigator().navigateToChangeProfilePicture(context, friendName,  true, friendNumber);
            },
            child: DisplayAvatarFromFirebase().displayAvatarFromFirebase(friendNumber, 25, 23.5, false),//toDo- check if false is right  here
          ),

          title: CustomText(text: friendName,),
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

  showMessagesAndSendMessageBar(){
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), //to take out the keyboard when tapped on chat screen
      //             onVerticalDragStart: _scrollToBottomButton(),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: stream,
                builder: (context, snapshot) {
                  print("just checking");
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
                  if(documentList == null){documentList = snapshot.data.documents;}

                  return NotificationListener<ScrollUpdateNotification>(
                    child: ListView.separated(
                      controller: listScrollController, //for scrolling messages
                      //shrinkWrap: true,
                      reverse: true,
                      itemCount: documentList.length,
                      itemBuilder: (context, index) {
                        var messageBody;
                        var imageURL;

                        bool isLoading  = true;//for circularProgressIndicator

                        if(documentList[index].data["imageURL"] == null){
                          print("text message");
                          messageBody = documentList[index].data["body"];
                        }else{
                          print("image");
                          imageURL = documentList[index].data["imageURL"];

                        }
                        //var messageBody = documentList[index].data["body"];
                        var fromName = documentList[index].data["fromName"];
                        Timestamp timeStamp = documentList[index].data["timeStamp"];
                        bool isMe = false;

                        if (fromName == userName) isMe = true;

                        return ListTile(
                          title: GestureDetector(
//                              onTap: (){
//                                print("onTap pressed");
//                                FocusScope.of(context).unfocus();///Not working!!
//                              },
                            onLongPress: (){
                              if(isPressed == false){///show snackbar only once
                                isPressed = true;
                                String forwardMessage;
                                String forwardImage;
                                print("on longPress: $messageBody");

                                ///extract the message in a variable called forwardMessage(ideally there should be
                                /// a list of messages and not just one variable..this is a @todo )
                                if(messageBody != null){
                                  forwardMessage = messageBody;
                                }else forwardImage = imageURL;




                                ///show snackbar
                                return Flushbar(
                                  padding : EdgeInsets.all(10),
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
                                      else data = {"imageURL":forwardImage, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};


                                      print("data in flushbar: $data");
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
                              child: imageURL == null?
                              Text(messageBody,): showImage(imageURL),
                              //message
                            ),
                          ),
                          subtitle: Container(
                            width: MediaQuery.of(context).size.width,
                           // height: MediaQuery.of(context).size.height,
                            alignment: isMe? Alignment.centerRight: Alignment.centerLeft,


//                            margin: isMe ? EdgeInsets.only(left: 40.0) : EdgeInsets.only(left: 0),//if not this then the timeStamp gets locked to the left side of the screen. So same logic as the messages above
                            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),//pretty padding- for some margin from the side of the screen as well as the top of parent message
                            child: Text(//time
                              DateFormat("dd MMM kk:mm")
                                  .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp.millisecondsSinceEpoch.toString()))),//converting firebase timestamp to pretty print
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic
                              ),
                            ),
                          ),
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

                        print("notification: $notification");

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
                            print("notfication in start: $notification");
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
                        print("You are at top");

//                        if(isLoading == true) {//ToDo- check if this is  working with an actual phone
//                          CircularProgressIndicator();}
                        fetchAdditionalMessages();
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

//  showPopUpMenuOnLongPress(){
//    showMenu(
//        context: null,
//        position: null,
//        items: PopupMenuEntry<T>
//    );
//  }

  showImage(String imageURL){
    try{
      print("in try");
      return
        DisplayPicture().chatPictureFrame(imageURL);
    }
    catch (e){
      print("in catch");
      return Icon(Icons.image);}
  }

  _buildMessageComposer() {//the type and send message box
    return StatefulBuilder(
      builder: (context, StateSetter setState){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          height: 70,
          color: Colors.white,
          child: ListTile(
            leading:
                IconButton(
                  icon: SvgPicture.asset('images/image2vector.svg',),
                  onPressed: () async{
                    var data = await sendImage();
                    pushMessageDataToFirebase(true, data);
                    setState(() {
                      documentList = null;
                    });
                  },
                ),
            title: TextField(
              //textCapitalization: TextCapitalization.sentences,
              maxLines: null,
              onChanged: (value){
                setState(() {
                  this.value=value;///by doing this we are setting the value to value globally
                });
//            this.value=value;
                //_controller.clear();
              },
              scrollController: new ScrollController(),
              controller: _controller,//used to clear text when user hits send button
            ),
            trailing: IconButton(
              icon: SvgPicture.asset('images/paperPlane.svg',),///or forward2
              onPressed: () {

                if(value!="") {
                  ///if there is not text, then dont send the message
                  var data = {"body":value, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
                  Firestore.instance.collection("conversations").document(conversationId).collection("messages").add(data);

                  setState(() {
                    documentList = null;
                  });


                  ///Navigating to RecentChats page with pushes the data to firebase
                  RecentChats(message: data, convId: conversationId, userNumber:userPhoneNo, userName: userName ).getAllNumbersOfAConversation();

                  _controller.clear();//used to clear text when user hits send button
                  listScrollController.animateTo(//for scrolling to the bottom of the screen when a next text is send
                    0.0,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 300),
                  );
                }
              },
            ),
          ),
        );
      },

    );
  }


  ///this method picks and crops the image, then converts it to a String which is used to
  ///create a data object to be pushed to firebase, which gets displayed on the screen as
  ///a message
  sendImage() async{
    numberOfImageInConversation++;
    print("numberOfImageInConversation++ : $numberOfImageInConversation");
    print("in sendImage");
    File image = await ImagesPickersDisplayPictureURLorFile().pickImageFromGallery();
    File croppedImage = await ImagesPickersDisplayPictureURLorFile().cropImage(image);
    String imageURL = await ImagesPickersDisplayPictureURLorFile().getImageURL(croppedImage, userPhoneNo, numberOfImageInConversation);
    return createDataToPushToFirebase(true, imageURL, userName, userPhoneNo, conversationId);

  }


  ///this method creates the data to be pushed to firebase
  createDataToPushToFirebase(bool isImage, String value, String userName, String fromPhoneNumber, String conversationId){
    if(isImage == true){
      return {"imageURL":value, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
    } return {"body":value, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
  }

  pushMessageDataToFirebase(bool isImage, var data){
      Firestore.instance.collection("conversations").document(conversationId).collection("messages").add(data);
      ///Navigating to RecentChats page with pushes the data to firebase

      if(isImage == true){
        var data = createDataToPushToFirebase(true, "📸", userName, userPhoneNo, conversationId);
        RecentChats(message: data, convId: conversationId, userNumber:userPhoneNo, userName: userName ).getAllNumbersOfAConversation();
      }else
        RecentChats(message: data, convId: conversationId, userNumber:userPhoneNo, userName: userName ).getAllNumbersOfAConversation();

  }




  _scrollToBottomButton(){//the button with down arrow that should appear only when the user scrolls
      return Visibility(
        visible: scroll,
        child: Align(
            alignment: Alignment.centerRight,
            child:
            //scrollListener() ?
            FloatingActionButton(
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
  fetchAdditionalMessages() async {
    try {
      List<DocumentSnapshot>  newDocumentList  =  (await collectionReference
          .orderBy("timeStamp", descending: true)
          .startAfterDocument(documentList[documentList.length-1])
          .limit(10).getDocuments())
          .documents;

      if(newDocumentList.isEmpty) return;

      setState(() {//setting state is essential, or new messages(next batch of old messages) does not get loaded
        documentList.addAll(newDocumentList);
      });
    } catch(e) {
      streamController.sink.addError(e);
    }

  }
}



