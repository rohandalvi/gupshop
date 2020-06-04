import 'dart:async';
import 'dart:io';

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
import 'package:gupshop/widgets/sideMenu.dart';
import 'package:intl/intl.dart';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IndividualChat extends StatefulWidget {
  final String conversationId;
  final String userPhoneNo;
  final String userName;
  final String friendName;
  final String friendNumber;

  IndividualChat(
      {Key key, @required this.conversationId, @required this.userPhoneNo, @required this.userName, @required this.friendName, @required this.friendNumber,})
      : super(key: key);
  @override
  _IndividualChatState createState() => _IndividualChatState(
      conversationId: conversationId,
      userPhoneNo: userPhoneNo,
      userName: userName,
      friendName: friendName,
      friendNumber: friendNumber
  );

}



class _IndividualChatState extends State<IndividualChat> {
  final String conversationId;
  final String userPhoneNo;
  final String userName;
  final String friendName;
  final String friendNumber;

  static int numberOfImageInConversation = 0;//for giving number to the images sent in conversation for
  //storing in firebase

  _IndividualChatState(
      {@required this.conversationId, @required this.userPhoneNo, @required this.userName, @required this.friendName, @required this.friendNumber,});

  String value = ""; //TODo

  TextEditingController _controller = new TextEditingController(); //to clear the text  when user hits send button//TODO- for enter
  ScrollController listScrollController = new ScrollController(); //for scrolling the screen
  StreamController streamController= new StreamController();
  List<DocumentSnapshot> documentList;//made for getting old batch of messages when the scrolling limit of 10 messages at a time is reached
  CollectionReference collectionReference;
  Stream<QuerySnapshot> stream;

  ScrollNotification notification;

  bool isLoading =  true;


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
            child: DisplayAvatarFromFirebase().displayAvatarFromFirebase(friendNumber, 25, 23.5),
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
                          title: Container(
                            width: MediaQuery.of(context).size.width,
                           // height: MediaQuery.of(context).size.height,
                            alignment: isMe? Alignment.centerRight: Alignment.centerLeft,///to align the messages at left and right
//                            decoration: BoxDecoration(
//                              borderRadius: BorderRadius.all(Radius.circular(5)),
//                            ),
                            //margin: isMe ? EdgeInsets.only(left: 40.0) : EdgeInsets.only(left: 0),
                            //EdgeInsets.only(left: 40.0) : EdgeInsets.only(left: 0),
                            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0), ///for the box covering the text, when horizontal is increased, the photo size decreases
                            //color: isMe ? isMeChatColor: notMeChatColor,
                            //Color(0xFFF9FBE7) : Color(0xFFFFEFEE),
                            child: imageURL == null?
                            Text(messageBody,): showImage(imageURL),
                            //message
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
                      ///onNotification allows us to know when we have reached the limit of the messages
                      ///once the limit is reached, documentList is updated again  with the next 10 messages using
                      ///the fetchAdditionalMesages()
                      if(notification.metrics.atEdge
                          &&  !((notification.metrics.pixels - notification.metrics.minScrollExtent) <
                              (notification.metrics.maxScrollExtent-notification.metrics.pixels))) {
                        print("You are at top");

                        if(isLoading == true) {//ToDo- check if this is  working with an actual phone
                          CircularProgressIndicator();
                        }

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

  showImage(String imageURL){
    try{
      print("in try");
      return
        DisplayPicture().chatPictureFrame(imageURL);
//        Container(
//            width: 250,
//            height: 250,
//            child: Image(image: NetworkImage(imageURL),
//              fit: BoxFit.cover,
//            ),
//          decoration: BoxDecoration(
//            borderRadius: BorderRadius.all(Radius.circular(50.0)),
//           // border: Border(top: BorderSide(place color here)),///for colored border
//          ),
//        );
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
                  this.value=value;//by doing this we are setting the value to value globally
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
                  //if there is not text, then dont send the message
                  var data = {"body":value, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
                  Firestore.instance.collection("conversations").document(conversationId).collection("messages").add(data);
//                  DocumentSnapshot documentSnapshot=  await documentReference.get();
//                  List<DocumentSnapshot>  newDocumentList = [ documentSnapshot];

                  setState(() {
                    documentList = null;
                  });


                  //Navigating to RecentChats page with pushes the data to firebase
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
      }

  }




  _scrollToBottomButton(){//the button with down arrow that should appear only when the user scrolls
//    if(notification is ScrollUpdateNotification){
    return Align(
        alignment: Alignment.centerRight,
        child:
        //scrollListener() ?
        FloatingActionButton(
          child: IconButton(
            icon: Icon(Icons.keyboard_arrow_down),
          ),
          onPressed: (){
//          Scrollable.ensureVisible(context);
            listScrollController.animateTo(//for scrolling to the bottom of the screen when a next text is send
              0.0,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            );
          },
        )
      //: new Align(),
    );
//    } return Align();
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
        //streamController.add(documentList);
        isLoading = false;
      });
    } catch(e) {
      streamController.sink.addError(e);
    }

  }
}



