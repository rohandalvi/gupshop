import 'dart:async';
import 'dart:io';

import 'package:flutter_contact/generated/i18n.dart';
import 'package:gupshop/models/chat_List.dart';
import 'package:gupshop/service/imagePickersDisplayPicturesFromURLorFile.dart';
import 'package:gupshop/service/recentChats.dart';
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
            appBar: appBar(),
            body: showMessagesAndSendMessageBar(),
          ),
        ),
        _scrollToBottomButton(),
      ],
    );
  }



  appBar(){
    return AppBar(
      title: Material(
        color: Theme.of(context).primaryColor,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(),
          leading: SizedBox(
            height: 50,
            width: 35,
            child : ClipOval(
              //child: snapshot.data.data,
              child: SideMenuState().getProfilePicture(friendNumber),
            ),
          ),
          title: Text(
            friendName,//name of the person with whom we are chatting right now, displayed at the top in the app bar
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            'Put last seen here',
          ),
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

                        bool isLoading  = true;

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
                            margin: isMe ? EdgeInsets.only(left: 40.0) : EdgeInsets.only(left: 0),
                            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0), //for the box covering the text
                            color: isMe ? Color(0xFFF9FBE7) : Color(0xFFFFEFEE),
                            child: imageURL == null?
                            Text(messageBody,):
                            showImage(imageURL),
                            //message
                          ),
                          subtitle: Container(
                            margin: isMe ? EdgeInsets.only(left: 40.0) : EdgeInsets.only(left: 0),//if not this then the timeStamp gets locked to the left side of the screen. So same logic as the messages above
                            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),//pretty padding- for some margin from the side of the screen as well as the top of parent message
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
                      /*
                       onNotification allows us to know when we have reached the limit of the messages
                       once the limit is reached, documentList is updated again  with the next 10 messages using
                       the fetchAdditionalMesages()
                       */
                      if(notification.metrics.atEdge
                          &&  !((notification.metrics.pixels - notification.metrics.minScrollExtent) <
                              (notification.metrics.maxScrollExtent-notification.metrics.pixels))) {
                        print("You are at top");

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
      return Image(image: NetworkImage(imageURL),);}
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
                  icon: Icon(Icons.camera_alt),
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
              icon: Icon(Icons.send),
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



  sendImage() async{
    numberOfImageInConversation++;
    print("numberOfImageInConversation++ : $numberOfImageInConversation");
    print("in sendImage");
    File image = await ImagesPickersDisplayPictureURLorFile().pickImageFromGallery();
    String imageURL = await ImagesPickersDisplayPictureURLorFile().getImageURL(image, userPhoneNo, numberOfImageInConversation);
    return createDataToPushToFirebase(true, imageURL, userName, userPhoneNo, conversationId);

  }

  createDataToPushToFirebase(bool isImage, String value, String userName, String fromPhoneNumber, String conversationId){
    if(isImage == true){
      return {"imageURL":value, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
    } return {"body":value, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
  }

  pushMessageDataToFirebase(bool isImage, var data){
      Firestore.instance.collection("conversations").document(conversationId).collection("messages").add(data);
      //Navigating to RecentChats page with pushes the data to firebase

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


//fetching next batch of messages when user scrolls up for previous messages
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
      });
    } catch(e) {
      streamController.sink.addError(e);
    }

  }
}



