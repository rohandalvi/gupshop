import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contact/generated/i18n.dart';
import 'package:gupshop/links/checkLinkValidity.dart';
import 'package:gupshop/models/message.dart';
import 'package:gupshop/models/news_message.dart';
import 'package:gupshop/models/text_message.dart';
import 'package:gupshop/news/fakeNewsText.dart';
import 'package:gupshop/news/newsStatisticsCollection.dart';
import 'package:gupshop/news/newsComposerBody.dart';
import 'package:gupshop/news/newsIdCollection.dart';
import 'package:gupshop/service/addToFriendsCollection.dart';
import 'package:gupshop/service/recentChats.dart';
import 'package:gupshop/individualChat/firebaseMethods.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customScaffoldBody.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customTextFormField.dart';
import 'package:gupshop/links/openLinks.dart';

class NewsComposer extends StatefulWidget {
  bool groupExits;
  String friendN;
  String userPhoneNo;
  String userName;
  List<dynamic> listOfFriendNumbers;
  String conversationId;
  String groupName;
  String value;
  TextEditingController controller;
  ScrollController listScrollController;
  String title;
  String link;
  String newsBody;
  var isForward;


  NewsComposer({
    this.groupExits,
    this.friendN,
    this.userPhoneNo,
    this.userName,
    this.listOfFriendNumbers,
    this.conversationId,
    this.groupName,
    this.value,
    this.controller,
    this.listScrollController,
    this.title,this.link,this.newsBody,
    this.isForward,
  });

  @override
  NewsComposerState createState() => NewsComposerState();
}

class NewsComposerState extends State<NewsComposer> {
  String newsId;
  bool linkEntered = true;
  bool titleEntered = true;
  bool newsEntered = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: CustomAppBar(
            title: widget.isForward != null ? CustomText(text : 'Forward a NEWS !') : CustomText(text : 'Create a NEWS !'),
            onPressed: (){Navigator.pop(context);},
          ),
      ),
      body: CustomScaffoldBody(
        body: NewsComposerBody(
          children: <Widget>[
            CustomTextFormField(
              labelText: 'Enter the News Title',
              errorText: (widget.title == "" || (widget.title == null && titleEntered == false)) ? 'Title Required' : null,
              maxLength: 15,
              initialValue: widget.title,/// for showing value of forward messages
              onFieldSubmitted: (val){
                titleEntered = true;
              },
              onChanged: (titleVal){
                setState(() {
                  widget.title = titleVal;
                  //titleEntered = true;
                });
              },
            ),
            CustomTextFormField(
              labelText: 'Enter a valid News link',
              maxLines: 1,
              initialValue: widget.link,
              errorText: widget.link == "" || (widget.link == null && linkEntered == false) ? 'Valid Link Required' : null,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
              onFieldSubmitted: (val){
                linkEntered = true;
                print("onFieldSubmitted");
              },
              onChanged: (linkVal){
                setState(() {
                  widget.link = linkVal;
                  //linkEntered = true;
                });
              },
              /// different style of border:
              /// border: OutlineInputBorder(
              ///  borderRadius: BorderRadius.circular(10),
              /// ),
              onTap: (){
                if(widget.link != null && widget.link != ""){
                  OpenLinks().open(widget.link);
                }
              },
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blue,
                ///decoration: TextDecoration.underline/// this is giving an underline to Enter the link too
              ) ,
            ),
            CustomTextFormField(
              labelText: 'Give some intro about the news',
              maxLines: 2,
              maxLength: 50,
              initialValue: widget.newsBody,
              errorText: widget.newsBody == "" || (widget.newsBody == null && newsEntered == false) ? 'News Required' : null,
              onFieldSubmitted: (val){
                newsEntered = true;
              },
              onChanged: (newsVal){
                setState(() {
                  widget.newsBody = newsVal;
                  //newsEntered = true;
                });
              },
              onTap: () async{
                bool isLinkValid;
                if(widget.link != null || widget.link != ""){
                  /// verify if the link is correct:
                  try {
                    isLinkValid = await CheckLinkValidity().check(widget.link);
                  }
                  catch (err) {
                    setState(() {
                      widget.link = "";
                    });
                  }
                }
              },
            ),
            CustomIconButton(
              onPressed: () async{
                final navigator = Navigator.of(context);
                print("navigator: $navigator");

                /// widget.link == null, widget.title == null, widget.newsBody == null
                /// to make the fields required:
                if(widget.link == null ){
                  setState(() {
                    linkEntered = false;
                  });
                }
                if(widget.title == null){
                  setState(() {
                    titleEntered = false;
                  });
                }
                if(widget.newsBody == null){
                  setState(() {
                    newsEntered = false;
                  });
                }

                /// send data to recentchats and conversation collections only when
                /// all the required fields are filled:
                if(widget.link != null && widget.link != "" &&
                    widget.title != null && widget.title != "" &&
                    widget.newsBody != null && widget.newsBody != ""){
                  var newsData ={
                    'title' : widget.title,
                    'link' : widget.link,
                    'news' : widget.newsBody,
                  };

                  /// creating a news Id for new news as it would be used to tag all
                  /// the people who are forwarding the message
                  newsId = await NewsIdCollection().createNewsId(newsData);

                  await sendToRecentChatsAndConversations(
                    widget.groupExits,
                    widget.friendN,
                    widget.userPhoneNo,
                    widget.userName,
                    widget.listOfFriendNumbers,
                    widget.conversationId,
                    widget.groupName,
                    widget.value,
                    widget.controller,
                    widget.listScrollController,
                    newsId,
                  );

                  /// sending the user back to individual chat
                  Navigator.of(context).pop();
                }
              },
              iconNameInImageFolder: 'paperPlane',
            ),
            FakeNewsText(),
          ],
        ),
      ),
    );
  }



  sendToRecentChatsAndConversations(
      bool groupExits, String friendN, String userPhoneNo, String userName,
      List<dynamic> listOfFriendNumbers, String conversationId, String groupName,
      String value, TextEditingController controller, ScrollController listScrollController, String newsId) async {

    int trueBy=0;
    int fakeBy =0;
    int reportedBy =0;

    if (groupExits == false) {
      var myNumberExistsInFriendsFriendsCollectionWaiting = await Firestore
          .instance.collection("friends_$friendN").document(userPhoneNo).get();
      var myNumberExistsInFriendsFriendsCollection = myNumberExistsInFriendsFriendsCollectionWaiting
          .data;
      if (myNumberExistsInFriendsFriendsCollection == null) {
        List<String> nameListForOthers = new List();
        nameListForOthers.add(userName);
        AddToFriendsCollection()
            .extractNumbersFromListAndAddToFriendsCollection(
            listOfFriendNumbers, conversationId, userPhoneNo, nameListForOthers,
            null, null);
      }
    }
    if (groupExits == true) {
      DocumentSnapshot adminNumberFuture = await Firestore.instance.collection(
          "conversationMetadata").document(conversationId).get();
      String adminNumber = adminNumberFuture.data["admin"];
      print("adminNumber: $adminNumber");

      await Future.wait(listOfFriendNumbers.map((element) async {
        print("element: $element");
        var myNumberExistsInFriendsFriendsCollectionWaiting = await Firestore
            .instance.collection("friends_$element")
            .document(conversationId)
            .get();
        var myNumberExistsInFriendsFriendsCollection = myNumberExistsInFriendsFriendsCollectionWaiting
            .data;
        print(
            "myNumberExistsInFriendsFriendsCollection: $myNumberExistsInFriendsFriendsCollection");
        if (myNumberExistsInFriendsFriendsCollection == null) {
          List<String> nameListForOthers = new List();
          nameListForOthers.add(groupName);
          AddToFriendsCollection()
              .extractNumbersFromListAndAddToFriendsCollection(
              listOfFriendNumbers, conversationId, conversationId,
              nameListForOthers, groupName, adminNumber);
        }
      }));
    }

    if (widget.link != null && widget.title != null) {
      ///if there is not text, then dont send the message


      /// when a news gets created, it gets pushed to three collections:
      /// 1) news collection
      /// 2) conversations collection
      /// 3) newsStatistics


      /// data creation for pushing to conversations collection:
      IMessage newsMessageForConversationCollection = NewsMessage(newsId: newsId, conversationId: conversationId, fromName: userName, fromNumber: userPhoneNo, timestamp: DateTime.now());

      /// pushing to newsStatistics:
      /// increase the count only if the user doesnt exist in newsStatistics trueBy collection
      bool hasForwardedOrCreatedNewsAlready = await NewsStatisticsCollection().checkIfUserExistsAndAddToSet(newsId, userPhoneNo, userName, 'trueBy', true);
      await NewsStatisticsCollection().checkIfUserExistsAndAddToSet(newsId, userPhoneNo, userName, 'fakeBy', false);
      await NewsStatisticsCollection().checkIfUserExistsAndAddToSet(newsId, userPhoneNo, userName, 'reportedBy', false);
      if(hasForwardedOrCreatedNewsAlready == false){trueBy++;}

      /// pushing news to conversation collection
      FirebaseMethods().pushToFirebaseConversatinCollection(newsMessageForConversationCollection.fromJson());

      /// pushing news to news collection
      FirebaseMethods().pushToNewsCollection(newsId, widget.link,  trueBy,  fakeBy,  reportedBy, widget.title, widget.newsBody);

      IMessage newsMessageForRecentChats = TextMessage(text: "📰 NEWS", fromNumber: userPhoneNo, fromName: userName, conversationId: conversationId,timestamp: DateTime.now());

      //var dataForRecentChats = CreateMessageDataToPushToFirebase(isNews: true, userPhoneNo: userPhoneNo, userName: userName, conversationId: conversationId).create();

      ///Navigating to RecentChats page with pushes the data to firebase
      RecentChats(message: newsMessageForRecentChats.fromJson(),
          convId: conversationId,
          userNumber: userPhoneNo,
          userName: userName,
          listOfOtherNumbers: listOfFriendNumbers,
          groupExists: groupExits).getAllNumbersOfAConversation();

      controller.clear(); //used to clear text when user hits send button
      listScrollController
          .animateTo( //for scrolling to the bottom of the screen when a next text is send
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }
}
